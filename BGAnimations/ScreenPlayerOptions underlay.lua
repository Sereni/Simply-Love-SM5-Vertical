return Def.Quad{
	Name="ExplanationBackground",
	InitCommand=function(self)
		self:diffuse(0,0,0,0)
		:horizalign(left):vertalign(top)
		:setsize(233.2, 29)
		:xy(19.8, _screen.h-79)
	end,
	OnCommand=function(self) self:linear(0.2):diffusealpha(0.8) end,
}
