local row_height = 30
local row_width = 358.6
local row_bg_x = _screen.cx+92

local t = Def.ActorFrame{}
t.InitCommand=function(self) self:x(WideScale(12, 30)) end

-- a row
t[#t+1] = Def.Quad {
	Name="RowBackgroundQuad",
	InitCommand=function(self)
		self:x(row_bg_x):horizalign(center):zoomto(row_width, row_height)
	end,
}

return t
