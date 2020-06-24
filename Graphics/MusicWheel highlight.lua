local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems")
-- subtract 2 from the total number of MusicWheelItems
-- one MusicWheelItem will be offsceen above, one will be offscreen below
local NumVisibleItems = NumWheelItems - 2

local WheelWidth = THEME:GetMetric("MusicWheel", "WheelWidth")

return Def.Quad{
    InitCommand=function(self)
        self:zoomto(WheelWidth,_screen.h/(NumVisibleItems) - 1):x(26)
    end
}