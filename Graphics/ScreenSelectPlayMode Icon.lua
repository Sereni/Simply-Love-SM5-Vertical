local gc = Var("GameCommand")
local index = gc:GetIndex()
local text = gc:GetName()

-- text description of each mode ("Casual", "ITG", "FA+")
return LoadFont("_wendy small")..{
	Name="ModeName"..index,
	Text=ScreenString(text),

	InitCommand=function(self) self:maxwidth(256) end,
	GainFocusCommand=function(self) self:stoptweening():linear(0.1):zoom(0.4):diffuse(PlayerColor(PLAYER_1)) end,
	LoseFocusCommand=function(self) self:stoptweening():linear(0.1):zoom(0.2):diffuse(color("#888888")) end,
	OffCommand=function(self) self:linear(0.2):diffusealpha(0) end
}
