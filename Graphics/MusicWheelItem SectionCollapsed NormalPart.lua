local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems")
-- subtract 2 from the total number of MusicWheelItems
-- one MusicWheelItem will be offsceen above, one will be offscreen below
local NumVisibleItems = NumWheelItems - 2

local WheelWidth = THEME:GetMetric("MusicWheel", "WheelWidth")

return Def.ActorFrame{
	-- the MusicWheel is centered via metrics under [ScreenSelectMusic]; offset by a slight amount to the right here
	InitCommand=function(self) self:x(26) end,

	Def.Quad{ InitCommand=function(self) self:diffuse(color("#000000")):zoomto(WheelWidth, _screen.h/NumVisibleItems - 1) end },
	Def.Quad{ InitCommand=function(self) self:diffuse(color("#283239")):zoomto(WheelWidth, _screen.h/NumVisibleItems - 1) end }
}