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

local args = { Player=player, NumHighScores=8, RoundsAgo=1 }

pane[#pane+1] = LoadActor(THEME:GetPathB("", "_modules/HighScoreList.lua"), args)

return pane
