-- Pane3 displays a list of HighScores for the stepchart that was played.

local player = unpack(...)

local mods = SL[ToEnumShortString(player)].ActiveModifiers
-- No records in DoNotJudgeMe mode.
if mods.DoNotJudgeMe then return end

local pane = Def.ActorFrame{
	InitCommand=function(self)
		-- TODO: Not sure if this is aligned, might have to remove it ~Roujo
		self:y(_screen.cy - 53):zoom(0.65)
	end
}

-- -----------------------------------------------------------------------

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local NumHighScores = math.min(9, PREFSMAN:GetPreference("MaxHighScoresPerListForMachine"))

local HighScoreIndex = {
	-- Machine HighScoreIndex will always be -1 in EventMode and is effectively useless there
	Machine =  pss:GetMachineHighScoreIndex(),
	Personal = pss:GetPersonalHighScoreIndex()
}

-- -----------------------------------------------------------------------
-- custom logic to (try to) assess if a MachineHighScore was achieved when in EventMode

local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
local StepsOrTrail = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)
local MachineHighScores = PROFILEMAN:GetMachineProfile():GetHighScoreList(SongOrCourse,StepsOrTrail):GetHighScores()

local EarnedMachineHighScoreInEventMode = function()
	-- if no DancePoints were earned, it's not a HighScore
	if pss:GetPercentDancePoints() <= 0.01 then return false end
	-- If a MachineHighScore has been earned, there will be 1 or more machine high scores at this point.
	-- There may be 0 machine high scores if the score just earned by a player was not a pass.
	if #MachineHighScores < 1 then return false end
	-- otherwise, check if this score is better than the worst current HighScore retrieved from MachineProfile
	return pss:GetHighScore():GetPercentDP() >= MachineHighScores[math.min(NumHighScores, #MachineHighScores)]:GetPercentDP()
end

-- -----------------------------------------------------------------------

local EarnedMachineRecord = GAMESTATE:IsEventMode() and EarnedMachineHighScoreInEventMode() or HighScoreIndex.Machine >= 0
local EarnedTop2Personal  = (HighScoreIndex.Personal >= 0 and HighScoreIndex.Personal < 3)

-- -----------------------------------------------------------------------

-- Novice players frequently improve their own score while struggling to
-- break into an overall leaderboard.  The lack of *visible* leaderboard
-- progress can be frustrating/demoralizing, so let's do what we can to
-- alleviate that.
--
-- If this score is not high enough to be a machine record, but it *is*
-- good enough to be a top-2 personal record, show two HighScore lists:
-- 1-8 machine HighScores, then 1-2 personal HighScores
--
-- If the player isn't using a profile (local or USB), there won't be any
-- personal HighScores to compare against.
--
-- Also, this 5+3 shouldn't show up on privately owned machines where only
-- one person plays, which is a common scenario in 2020.
--
-- This idea of showing both machine and personal HighScores to help new players
-- track progress is based on my experiences maintaining a heavily-used
-- public SM5 machine for several years while away at school.


-- 20px RowHeight by default, which works for displaying 5 machine HighScores
local args = { Player=player, RoundsAgo=1, RowHeight=20}

if (not EarnedMachineRecord and EarnedTop2Personal) then

	-- top 5 machine HighScores
	numHighScores = 5
	args.NumHighScores = numHighScores
	pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)

	-- horizontal line visually separating machine HighScores from player HighScores
	pane[#pane+1] = Def.Quad{ InitCommand=function(self) self:zoomto(100, 1):y(args.RowHeight*(numHighScores+1)):diffuse(1,1,1,0.33) end }

	-- top 3 player HighScores
	args.NumHighScores = 3
	args.Profile = PROFILEMAN:GetProfile(player)
	pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)..{
		InitCommand=function(self) self:y(args.RowHeight*(numHighScores+1)) end
	}


-- the player did not meet the conditions to show the 5+3 HighScores
-- just show top 9 machine HighScores
else
	-- top 9 machine HighScores
	args.NumHighScores = 9
	pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)
end

return pane
