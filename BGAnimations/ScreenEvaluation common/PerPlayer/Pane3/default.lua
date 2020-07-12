-- Pane3 displays a list of HighScores for the stepchart that was played.

local player = ...

local mods = SL[ToEnumShortString(player)].ActiveModifiers
-- No records in DoNotJudgeMe mode.
if mods.DoNotJudgeMe then return end

local pane = Def.ActorFrame{
	Name="Pane3",
	InitCommand=function(self)
		self:visible(false)
		self:y(_screen.cy - 53):zoom(0.65)
	end
}

-- row_height of a HighScore line
local rh = 20
local args = { Player=player, RoundsAgo=1, RowHeight=rh}

-- if the player is using a profile (local or USB)
if PROFILEMAN:IsPersistentProfile(player) then

	-- top 5 machine HighScores
	numHighScores = 5
	args.NumHighScores = numHighScores
	pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)

	-- horizontal line visually separating machine HighScores from player HighScores
	pane[#pane+1] = Def.Quad{ InitCommand=function(self) self:zoomto(100, 1):y(rh*(numHighScores+1)):diffuse(1,1,1,0.33) end }

	-- top 3 player HighScores
	args.NumHighScores = 3
	args.Profile = PROFILEMAN:GetProfile(player)
	pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)..{
		InitCommand=function(self) self:y(rh*(numHighScores+1)) end
	}

-- else the player is not using a profile
else
	-- top 9 machine HighScores
	args.NumHighScores = 9
	pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)
end

return pane
