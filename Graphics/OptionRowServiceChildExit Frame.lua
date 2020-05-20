local row_bg_width = 358
local row_bg_height = 30
local row_bg_x = _screen.cx+72.5

return Def.Quad {
	InitCommand=function(self) self:zoomto(row_bg_width, row_bg_height):x(row_bg_x) end
}
