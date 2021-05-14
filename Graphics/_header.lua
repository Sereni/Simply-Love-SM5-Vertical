-- tables of rgba values
local dark  = {0,0,0,0.9}
local light = {0.65,0.65,0.65,1}

return Def.ActorFrame{
	Name="Header",

	Def.Quad{
		InitCommand=function(self)
			self:zoomto(_screen.w, 16):vertalign(top):x(_screen.cx)
			if ThemePrefs.Get("VisualStyle") == "SRPG5" then
				self:diffuse(GetCurrentColor(true))
			elseif DarkUI() then
				self:diffuse(dark)
			else
				self:diffuse(light)
			end
		end,
		ScreenChangedMessageCommand=function(self)
			local topscreen = SCREENMAN:GetTopScreen():GetName()
			if ThemePrefs.Get("VisualStyle") == "SRPG5" then
				self:diffuse(GetCurrentColor(true))
			end
		end,
		ColorSelectedMessageCommand=function(self)
			if ThemePrefs.Get("VisualStyle") == "SRPG5" then
				self:diffuse(GetCurrentColor(true))
			end
		end,
	},
}
