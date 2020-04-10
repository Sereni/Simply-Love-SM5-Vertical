-- Two of the items from metrics.ini are for padding, exclude from height.
local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems") - 2

return Def.ActorFrame{
	InitCommand=function(self) self:x(26) end,

	Def.Quad{ InitCommand=function(self) self:diffuse(color("#000000")):zoomto(_screen.w/2.1675, _screen.h/NumWheelItems) end },
	Def.Quad{ InitCommand=function(self) self:diffuse(color("#4c565d")):zoomto(_screen.w/2.1675, _screen.h/NumWheelItems - 2) end }
}
