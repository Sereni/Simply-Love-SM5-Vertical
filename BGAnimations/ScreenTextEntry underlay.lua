local af = Def.ActorFrame{}

local border_width = 1
local ins_x = _screen.cx
local ins_y = _screen.cy-35
local ins_w = _screen.w*0.6
local ins_h = _screen.h*0.1
local txt_x = _screen.cx
local txt_y = _screen.cy+2
local txt_w = _screen.w*0.6
local txt_h = 30

-- darken the entire screen slightly
af[#af+1] = Def.Quad{
	InitCommand=function(self) self:FullScreen():diffuse(0,0,0,0) end,
	OnCommand=function(self) self:accelerate(0.5):diffusealpha(0.5) end,
	OffCommand=function(self) self:accelerate(0.5):diffusealpha(0) end
}

-- Intructions BG
af[#af+1] = Def.Quad {
	InitCommand=function(self) self:xy(ins_x, ins_y):zoomto(ins_w, ins_h):diffuse(GetCurrentColor()) end
}
-- white border
af[#af+1] = Border(ins_w, ins_h, border_width) .. {
	InitCommand=function(self) self:xy(ins_x, ins_y) end
}


-- Text Entry BG
af[#af+1] = Def.Quad {
	InitCommand=function(self) self:xy(txt_x, txt_y):zoomto(txt_w, txt_h):diffuse(0,0,0,1) end
}
-- white border
af[#af+1] = Border(txt_w, txt_h, border_width)..{
	InitCommand=function(self) self:xy(txt_x, txt_y) end
}

return af
