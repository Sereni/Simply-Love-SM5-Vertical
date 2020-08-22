-- TODO(Sereni): layout
return Def.ActorFrame{
	Def.Quad {
		OnCommand=function(self)
			self:zoomto(_screen.w*0.5,_screen.h*0.0625)
				:halign(0):x(-_screen.cx + 48)
		end
	}
}
