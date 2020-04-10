-- Two of the items from metrics.ini are for padding, exclude from height.
local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems") - 2

return Def.Quad{ InitCommand=function(self) self:zoomto(_screen.w/2.1675,_screen.h/(NumWheelItems) - 4):x(26):y(-1) end }
