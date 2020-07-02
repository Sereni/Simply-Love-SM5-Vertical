-- TargetScore Graphs and Pacemaker contributed by JackG
-- ActionOnMissedTarget contributed by DinsFire64
-- cleanup + fixes by djpohly and andrewipark

-- ---------------------------------------------------------------
-- first, the usual suspects

local player = ...
local pn = ToEnumShortString(player)

-- Make sure that someone requested something from this file.
-- (There's a lot. See the long note near the end, just above the pacemaker implementation.)
local Pacemaker = SL[pn].ActiveModifiers.Pacemaker
local WantsTargetGraph = SL[pn].ActiveModifiers.DataVisualizations == "Target Score Graph"
local FailOnMissedTarget = PREFSMAN:GetPreference("EventMode") and SL[pn].ActiveModifiers.ActionOnMissedTarget == "Fail"
local RestartOnMissedTarget = PREFSMAN:GetPreference("EventMode") and SL[pn].ActiveModifiers.ActionOnMissedTarget == "Restart"
-- if none of them apply, bail now
if not (Pacemaker or WantsTargetGraph or FailOnMissedTarget or RestartOnMissedTarget) then return end

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

-- ---------------------------------------------------------------
-- some functions local to this file

 -- Finds the top score for the current song (or course) given a player.
local function GetTopScore(pn, kind)
	if not pn or not kind then return end

	local SongOrCourse, StepsOrTrail, scorelist

	if GAMESTATE:IsCourseMode() then
		SongOrCourse = GAMESTATE:GetCurrentCourse()
		StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
	else
		SongOrCourse = GAMESTATE:GetCurrentSong()
		StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
	end

	if kind == "Machine" then
		scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(SongOrCourse,StepsOrTrail)
	elseif kind == "Personal" then
		scorelist = PROFILEMAN:GetProfile(pn):GetHighScoreList(SongOrCourse,StepsOrTrail)
	end

	if scorelist then
		local topscore = scorelist:GetHighScores()[1]
		if topscore then return topscore:GetPercentDP() end
	end

	return 0
end

-- Ported from PSS.cpp, can be removed if that gets exported to Lua
local function GetCurMaxPercentDancePoints()
	local possible = pss:GetPossibleDancePoints()
	if possible == 0 then
		return 0
	end
	local currentMax = pss:GetCurrentPossibleDancePoints()
	if currentMax == possible then
		return 1
	end
	return currentMax / possible
end

-- ---------------------------------------------------------------
-- flags for fail/restart behavior

-- ---------------------------------------------------------------
-- possible targets, as defined in ./Scripts/SL-PlayerOptions.lua within TargetScore.Values()
-- { 'C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+', 'S-', 'S', 'S+', '*', '**', '***', '****', 'Machine best', 'Personal best' }

-- get personal best score
local pbGradeScore = GetTopScore(player, "Personal")

local target_grade = {
	-- the index of the target score chosen in the PlayerOptions menu
	index = tonumber(SL[pn].ActiveModifiers.TargetScore),
	-- the score the player is trying to achieve
	score = 0
}

if (target_grade.index == 17) then
	-- player set TargetGrade as Machine best
	target_grade.score = GetTopScore(player, "Machine")

elseif (target_grade.index == 18) then
	-- player set TargetGrade as Personal best
	target_grade.score = pbGradeScore
else
	-- player set TargetGrade as a particular letter grade
	-- anything from C- to ☆☆☆☆
	target_grade.score = THEME:GetMetric("PlayerStageStats", "GradePercentTier" .. string.format("%02d", 17 - target_grade.index))
end

-- if there is no personal/machine score, default to S as target
if target_grade.score == 0 then
	target_grade.score = THEME:GetMetric("PlayerStageStats", "GradePercentTier06")
end

-- ---------------------------------------------------------------
-- the main ActorFrame for this player

local player_af = Def.ActorFrame{
	OnCommand=function(self)
		self:xy(_screen.w-7, 58):zoom(0.25)
	end,
	-- any time we receive a judgment
	JudgmentMessageCommand=function(self,params)
		self:queuecommand("Update")
	end,
}

-- ---------------------------------------------------------------
-- FIXME: The ActionOnMissedTarget logic depends on the Pacemaker logic.
-- From a programmer's perspective, it makes sense to lump it all together in a single Actor,
-- but to the player, the Pacemaker and ActionOnMissedTarget are distinct features
-- that do not and should not depend on one another being active.
--
-- I've modified this file enough that the features can be activated independently now,
-- but there's still too much code involving disparate features in this one single file.
--
-- I don't have the time to fully detangle all this so it's staying this way until
-- someone rewrites this file OR human civilization ends in fire paving the way for GNU/Hurd.

if not SL[pn].ActiveModifiers.DoNotJudgeMe and (SL[pn].ActiveModifiers.Pacemaker or FailOnMissedTarget or RestartOnMissedTarget) then

	-- pacemaker text
	player_af[#player_af+1] = Def.BitmapText{
		-- FIXME this should use Wendy Monospace to prevent flicker whenever a 1 appears.
		-- For that, need to add +/- signs to the font file.
		Font="_wendy small",
		InitCommand=function(self)
			-- don't draw it if we don't need it
			self:visible(SL[pn].ActiveModifiers.Pacemaker)
			self:horizalign(right)
		end,
		UpdateCommand=function(self)
			local DPCurr = pss:GetActualDancePoints()
			local DPCurrMax = pss:GetCurrentPossibleDancePoints()
			local DPMax = pss:GetPossibleDancePoints()

			local percentDifference = (DPCurr - (target_grade.score * DPCurrMax)) / DPMax

			-- cap negative score displays
			percentDifference = math.max(percentDifference, -target_grade.score)

			local places = 2
			-- if there's enough dance points so that our current precision is ambiguous,
			-- i.e. each dance point is less than half of a digit in the last place,
			-- and we don't already display 2.5 digits,
			-- i.e. 2 significant figures and (possibly) a leading 1,
			-- add a decimal point.
			-- .1995 prevents flickering between .01995, which is rounded and displayed as ".0200", and
			-- and an actual .0200, which is displayed as ".020"
			while (math.abs(percentDifference) < 0.1995 / math.pow(10, places))
				and (DPMax >= 2 * math.pow(10, places + 2)) and (places < 4) do
				places = places + 1
			end

			self:settext(string.format("%+."..places.."f", percentDifference * 100))

			-- have we already missed so many dance points
			-- that the current goal is not possible anymore?
			if ((DPCurrMax - DPCurr) > (DPMax * (1 - target_grade.score))) then
				self:diffusealpha(0.65)

				-- check to see if the user wants to do something when they don't achieve their score.
				if FailOnMissedTarget then
					-- use SM_BeginFailed instead of SM_NotesEnded to *immediately* leave the screen instead of a nice fadeout.
					-- we want to get back into the next round because we want that score boi.
					SCREENMAN:GetTopScreen():PostScreenMessage("SM_BeginFailed", 0)
				elseif RestartOnMissedTarget then
					-- this setting assumes event mode, so no need for changing stage number.
					SCREENMAN:GetTopScreen():SetPrevScreenName("ScreenGameplay"):SetNextScreenName("ScreenGameplay"):begin_backing_out()
				end
			end
		end,
	}
end

return player_af
