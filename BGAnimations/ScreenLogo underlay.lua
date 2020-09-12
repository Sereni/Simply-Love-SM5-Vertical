-- ECS Logo
local af = Def.ActorFrame{
	InitCommand=function(self)
		self:Center()
	end,
	OffCommand=function(self) self:linear(0.5):diffusealpha(0) end,
}

af[#af+1] = LoadActor(THEME:GetPathG("", "_logos/ecs (doubleres).png"))..{
	InitCommand=function(self) self:xy(2,10):zoom(0.25):shadowlength(0.75) end,
	OffCommand=function(self) self:linear(0.5):shadowlength(0) end
}

return af
