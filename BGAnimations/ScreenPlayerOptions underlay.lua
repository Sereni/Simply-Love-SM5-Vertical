-- Quad at the bottom of the screen behind the explanation of the current OptionRow.
return Def.Quad{
	Name="ExplanationBackground",
	InitCommand=function(self)
		self:diffuse(0,0,0,0)
		:horizalign(left):vertalign(top)
		:setsize(233.2, 29)
		:xy(18.4, _screen.h-80)
	end,
	OnCommand=function(self)
		self:linear(0.2):diffusealpha(0.8)
	end,
}
