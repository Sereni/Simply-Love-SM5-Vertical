-- TODO(Sereni): layout
local t = Def.ActorFrame{}

-- a row
t[#t+1] = Def.Quad {
	Name="RowBackgroundQuad",
	OnCommand=function(self)
		self:zoomto(_screen.w*0.5, _screen.h*0.0625)
			:halign(0):x(-_screen.cx + 48)
	end
}

-- black quad behind the title
t[#t+1] = Def.Quad {
	Name="TitleBackgroundQuad",
	OnCommand=function(self)
		self:zoomto(_screen.w*WideScale(0.18,0.15),_screen.h*0.0625)
			:halign(0):x(-_screen.cx + 48)
			:diffuse(Color.Black):diffusealpha(BrighterOptionRows() and 0.8 or 0.25)
	end
}

return t
