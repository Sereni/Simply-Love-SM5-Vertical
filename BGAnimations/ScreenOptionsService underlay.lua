-- Quad at the bottom of the screen behind the explanation of the current OptionRow.
return Def.Quad{
	Name="ExplanationBackground",
	InitCommand=function(self)
		self:diffuse(color("#071016"))
		:horizalign(left):vertalign(top)
		:setsize(233.2, 29)
		:xy(18.4, _screen.h-100)
	end,
	OnCommand=function(self) self:linear(0.2):diffusealpha(DarkUI() and 1 or 0.8) end,
}
