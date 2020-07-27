-- tables of rgba values
local dark  = {0,0,0,0.9}
local light = {0.65,0.65,0.65,1}

return Def.ActorFrame{
	Name="Header",

	Def.Quad{
		InitCommand=function(self)
			self:zoomto(_screen.w, 16):vertalign(top):x(_screen.cx)
			if DarkUI() then
				self:diffuse(dark)
			else
				self:diffuse(light)
			end
		end,
	},
}
