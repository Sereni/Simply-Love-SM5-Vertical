-- Pane2 displays per-columnm judgment counts.
-- In "dance" the columns are left, down, up, right.
-- In "pump" the columns are downleft, upleft, center, upright, downright
-- etc.

local player, controller = unpack(...)

return Def.ActorFrame{
	-- ExpandForDoubleCommand() does not do anything here, but we check for its presence in
	-- this ActorFrame in ./InputHandler to determine which panes to expand the background for
	ExpandForDoubleCommand=function() end,

	LoadActor("./Percentage.lua", player),
	LoadActor("./JudgmentLabels.lua", player),
	LoadActor("./Arrows.lua", player)
}