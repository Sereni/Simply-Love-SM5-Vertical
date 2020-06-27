local num_items = THEME:GetMetric("MusicWheel", "NumWheelItems")
local item_width = THEME:GetMetric("MusicWheel", "WheelWidth")

return Def.ActorFrame{
	-- the MusicWheel is centered via metrics under [ScreenSelectMusic]; offset by a slight amount to the right here
	InitCommand=function(self) self:x(-49) end,

	Def.Quad{ InitCommand=function(self) self:horizalign(left):diffuse(0, 10/255, 17/255, 0.5):zoomto(item_width, (_screen.h/num_items)-1) end },
	Def.Quad{ InitCommand=function(self) self:horizalign(left):diffuse(DarkUI() and {1,1,1,0.5} or {10/255, 20/255, 27/255, 1}):zoomto(item_width, (_screen.h/num_items)-1) end }
}
