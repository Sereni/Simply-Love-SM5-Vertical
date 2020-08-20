local af = Def.ActorFrame{ InitCommand=function(self) self:Center() end }
local quotes = {
{
	{"In the race for success,\nspeed is less important\nthan stamina.", -90, -10},
	{"- B. C. Forbes", 55, 36}
},
{
	{"A stream is music and motion.", -100, -10},
	{"- Nelson Bryant", 104, 12}
},
{
	{"I honestly wasn't sure if I'd make it through Slam.\nThis is by far the hardest thing I've passed.", -130, -10},
	{"- Zetorux, ECS1", 120, 25}
},
{
	{"Are you asking about my stamina cap ?", -120, -10},
	{"- aijbot", 110, 12}
},
}

local body, author
local w = 310
-- ---------------------------------------

local af = Def.ActorFrame{
InitCommand=function(self)
	self:Center()
	local quote = quotes[math.random(#quotes)]
	body:settext(quote[1][1]):xy(quote[1][2],quote[1][3]):zoom(0.8)
	author:settext(quote[2][1]):xy(quote[2][2],quote[2][3]):zoom(0.8)
end
}

-- check SM5 version, current game (dance, pump, etc.), and RTT support
af[#af+1] = LoadActor("./CompatibilityChecks.lua")

-- -----------------------------------------------------------------------

local slc = SL.Global.ActiveColorIndex

-- - - - - - - - - - -
-- Constants defining UI element position depending on horizontal or vertical screen
local arrow_zoom =	(IsVerticalScreen() and 0.07 or 0.1)
local arrow_x =		(IsVerticalScreen() and 35 or 50)

-- semitransparent black quad as background for 7 decorative arrows
af[#af+1] = Def.Quad{
	InitCommand=function(self) self:zoomto(_screen.w,0):diffuse(Color.Black) end,
	OnCommand=function(self) self:accelerate(0.3):zoomtoheight(128):diffusealpha(0.9):sleep(2.5) end,
	OffCommand=function(self) self:accelerate(0.3):zoomtoheight(0) end
}

-- loop to add 7 SM5 logo arrows to the primary ActorFrame
for i=1,7 do

	local arrow = Def.ActorFrame{
		InitCommand=function(self) self:x((i-4) * arrow_x):diffusealpha(0) end,
		OnCommand=function(self)
			-- thonk
			if ThemePrefs.Get("VisualTheme")=="Thonk" then
				self:diffusealpha(1):rotationy(-90):sleep(i*0.1 + 0.2)
				self:smooth(0.25):rotationy(0):sleep(0.8):bouncebegin(0.8):y(_screen.h)
			-- everything else
			else
				self:sleep(i*0.1 + 0.2)
				self:linear(0.75):diffusealpha(1):linear(0.75):diffusealpha(0)
			end

			self:queuecommand("Hide")
		end,
		HideCommand=function(self) self:visible(false) end,
	}

	-- desaturated SM5 logo
	arrow[#arrow+1] = LoadActor("logo.png")..{
		InitCommand=function(self) self:zoom(arrow_zoom):diffuse(GetHexColor(slc-i-3, true)) end,
	}

	-- only add Thonk asset if needed
	if ThemePrefs.Get("VisualTheme")=="Thonk" then
		arrow[#arrow+1] = LoadActor("thonk.png")..{
			InitCommand=function(self) self:zoom(arrow_zoom):xy(6,-2) end,
		}
	end

	af[#af+1] = arrow
end

-- quote body
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		body = self
		self:diffuse(GetHexColor(slc)):diffusealpha(0):horizalign(left):vertspacing(-4)
	end,
	OnCommand=cmd(sleep,3; linear,0.25; diffusealpha,1),
	OffCommand=cmd(linear,0.25; diffusealpha,0)
}

-- quote author
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		author = self
		self:diffuse(GetHexColor(slc)):diffusealpha(0):horizalign(right)
	end,
	OnCommand=cmd(sleep,3; linear,0.25; diffusealpha,1),
	OffCommand=cmd(linear,0.25; diffusealpha,0)
}

return af
