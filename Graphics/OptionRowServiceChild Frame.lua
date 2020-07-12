local row_bg_width = 358
local row_bg_height = 30
local row_bg_x = _screen.cx+92

local title_bg_width = 115
local title_bg_x = row_bg_x - row_bg_width/2

local t = Def.ActorFrame{}
t.InitCommand=function(self) self:x(WideScale(12,30)) end

-- a row
t[#t+1] = Def.Quad {
	Name="RowBackgroundQuad",
	InitCommand=function(self)
	self:horizalign(center):x(row_bg_x):zoomto(row_bg_width, row_bg_height)
end
}

-- black quad behind the title
t[#t+1] = Def.Quad {
	Name="TitleBackgroundQuad",
	OnCommand=function(self)
		self:setsize(title_bg_width, _screen.h*0.0625)
			:halign(0):x(title_bg_x)
			:diffuse(Color.Black):diffusealpha( DarkUI() and 0.75 or 0.25)
	end
}

return t
