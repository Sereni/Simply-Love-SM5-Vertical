local player = ...
local mods = SL[ToEnumShortString(player)].ActiveModifiers
-- No judgement in DoNotJudgeMe mode.
if mods.DoNotJudgeMe then
  return Def.ActorFrame{
		Name="Pane1",
		InitCommand=cmd(xy, 0, 250),
		LoadActor("otter.png")..{ OnCommand=function(self) self:zoomto(210,130) end }
	}
end

return Def.ActorFrame{
	Name="Pane1",

	-- Position all pane elements on the screen
	InitCommand=cmd(xy, 47, 200),

	-- labels (like "FANTASTIC, MISS, holds, rolls, etc.")
	LoadActor("./JudgmentLabels.lua", player),

	-- DP score displayed as a percentage
	LoadActor("./Percentage.lua", player),

	-- numbers (how many Fantastics? How many misses? etc.)
	LoadActor("./JudgmentNumbers.lua", player),
}
