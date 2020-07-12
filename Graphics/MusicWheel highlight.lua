local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems")
local WheelWidth = THEME:GetMetric("MusicWheel", "WheelWidth")

return Def.Quad{
    InitCommand=function(self)
        self:zoomto(WheelWidth,_screen.h/(NumWheelItems) - 1):x(26)
    end
}
