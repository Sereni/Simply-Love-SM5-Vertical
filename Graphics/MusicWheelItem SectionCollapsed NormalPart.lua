-- Two of the items from metrics.ini are for padding, exclude from height.
-- TODO Figure out if that's the correct thing to do.
local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems") - 2

return Def.ActorFrame{
	InitCommand=function(self) self:x(26) end,

	Def.Quad{ InitCommand=function(self) self:diffuse(color("#000000")):zoomto(_screen.w/2.1675, _screen.h/NumWheelItems) end },
	Def.Quad{ InitCommand=function(self) self:diffuse(color("#283239")):zoomto(_screen.w/2.1675, _screen.h/NumWheelItems - 2) end }
}
