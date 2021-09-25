local t = Def.ActorFrame{}

if ThemePrefs.Get("RainbowMode") then
	t[#t+1] = Def.Quad{
		InitCommand=function(self) self:FullScreen():Center():diffuse( Color.White ) end
	}
end

if ThemePrefs.Get("VisualTheme") == "Mario" then
	t[#t+1] = Def.Sprite {
			Texture=THEME:GetPathG("", "_ECSX/bg.png"),
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoom(SCREEN_HEIGHT/	self:GetHeight())
			end,
		}
else
	t[#t+1] = LoadActor( THEME:GetPathB("", "_shared background"))
end

return t
