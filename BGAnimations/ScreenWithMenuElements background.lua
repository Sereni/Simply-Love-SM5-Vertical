local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "_ECSX/bg.png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoom(SCREEN_HEIGHT/	self:GetHeight())
		end,
	}

return t
