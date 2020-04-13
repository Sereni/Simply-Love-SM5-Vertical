local t = Def.ActorFrame{}

local NumWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems")
local WheelWidth = THEME:GetMetric("MusicWheel", "WheelWidth")

-- Each MusicWheelItem has two Quads drawn in front of it, blocking it from view.
-- Each of these Quads is half the height of the MusicWheelItem, and their y-coordinates
-- are such that there is an "upper" and a "lower" Quad.

-- The upper Quad has cropbottom applied while the lower Quad has croptop applied
-- resulting in a visual effect where the MusicWheelItems appear to "grow" out of the center to full-height.
-- FIXME: this 23, as well as a 26 appearing in Graphis/MusicWheelItem, makes part of the item hang
-- off the right side of the screen. This makes the wheel width misleading.
local x = _screen.w-WheelWidth/2 + 23
local rowHeight = _screen.h/NumWheelItems
local color = ThemePrefs.Get("RainbowMode") and Color.White or Color.Black

for i=1,NumWheelItems do
	-- upper
	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:x(x)
				:y( rowHeight/4 + rowHeight*i )
				:zoomto(WheelWidth, rowHeight/2)
				:diffuse(color)
		end,
		OnCommand = function(self) self:sleep(i*0.035):linear(0.1):cropbottom(1):diffusealpha(0.25):queuecommand("Hide") end,
		HideCommand = function(self) self:visible(false) end,
	}
	-- lower
	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:x(x)
				:y( rowHeight*3/4 + rowHeight*i )
				:zoomto(WheelWidth, rowHeight/2)
				:diffuse(color)
		end,
		OnCommand = function(self) self:sleep(i*0.035):linear(0.1):cropbottom(1):diffusealpha(0.25):queuecommand("Hide") end,
		HideCommand = function(self) self:visible(false) end,
	}
end

return t
