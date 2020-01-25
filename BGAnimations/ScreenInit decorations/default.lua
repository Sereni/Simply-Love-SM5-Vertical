local slc = SL.Global.ActiveColorIndex

local af = Def.ActorFrame{}

-- - - - - - - - - - -
-- Constants defining UI element position depending on horizontal or vertical screen
local arrow_zoom =	(IsVerticalScreen() and 0.07 or 0.1)
local arrow_x =		(IsVerticalScreen() and 35 or 50)

af[#af+1] = Def.Quad{
	InitCommand=function(self) self:zoomto(_screen.w,0):diffuse(Color.Black):Center() end,
	OnCommand=function(self) self:accelerate(0.3):zoomtoheight(128):diffusealpha(0.9):sleep(2.5) end,
	OffCommand=function(self) self:accelerate(0.3):zoomtoheight(0) end
}

-- loop to add 7 SM5 arrows to the primary ActorFrame
for i=1,7 do
	af[#af+1] = Def.ActorFrame {
		InitCommand=function(self) self:Center() end,
		OnCommand=function(self) self:sleep(3):queuecommand("Hide") end,
		HideCommand=function(self) self:visible(false) end,

		LoadActor("white_logo.png")..{
			InitCommand=cmd(zoom, arrow_zoom; diffuse, GetHexColor(slc-i-3); diffusealpha,0; x, (i-4) * arrow_x ),
			OnCommand=cmd(sleep, i*0.1 + 0.2; linear,0.75; diffusealpha,1; linear,0.75;diffusealpha,0)
		},
		LoadActor("highlight.png")..{
			InitCommand=cmd(zoom, arrow_zoom; diffusealpha,0; x, (i-4) * arrow_x),
			OnCommand=cmd(sleep, i*0.1 + 0.2; linear,0.75; diffusealpha,0.75; linear,0.75;diffusealpha,0)
		}
	}
end

af[#af+1] = LoadFont("Common Normal")..{
	Text=ScreenString("ThemeDesign"),
	InitCommand=function(self) self:diffuse(GetHexColor(slc)):diffusealpha(0):Center() end,
	OnCommand=function(self) self:sleep(3):linear(0.25):diffusealpha(1) end,
	OffCommand=function(self) self:linear(0.25):diffusealpha(0) end,
}

return af
