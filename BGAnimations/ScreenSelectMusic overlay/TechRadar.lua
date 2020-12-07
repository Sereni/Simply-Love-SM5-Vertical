-- Conditional "tech radar" for ECFA 2021

if SL.Global.GameMode ~= "ECFA" then return end

local player = GAMESTATE:GetMasterPlayerNumber()

local width = 125
local height = 112

local xpos = width / 2
local ypos = _screen.cy + 168

local zoom = .6

local radarOffsetX = 30
local radarOffsetY = 29

local labelOffsetX = -10
local labelOffsetY = -3

local elements = {
	{key = "speed", label = "Speed"},
	{key = "stamina", label = "Stamina"},
	{key = "tech", label = "Technique"},
	{key = "movement", label = "Movement"},
	{key = "rhythms", label = "Rhythms"},
	{key = "gimmick", label = "Gimmicks"}
}

local gimmicks = {[-1] = "N/A", [0] = "None", [1] = "Light", [2] = "Medium", [3] = "Heavy"}

local scaleColor = color("#28353f")
-- index+1 will match the color of the background
local primaryColor = ThemePrefs.Get("RainbowMode") and color("#7fb9e3") or GetHexColor(SL.Global.ActiveColorIndex + 1, true)
local radarBorder = primaryColor
local radarFill = primaryColor
radarFill[4] = .5 -- alpha

-- values are set in af's SetCommand
local radar = {
	speed = 0,
	stamina = 0,
	tech = 0,
	movement = 0,
	rhythms = 0,
	gimmick = 0,
}

	-- use these to initializate the groove radar
local zeroVert = {{radarOffsetX,radarOffsetY,0},radarFill}
local zeroVerts = {}
for i = 1, 12 do
	zeroVerts[#zeroVerts+1] = zeroVert
end

local getRadarVert = function(index, value)
	local x = 0
	local y = 0
	if index and value then
		angle = 1.25664 * index
		x = radarOffsetX + 5.5 * value * math.sin(angle)
		y = radarOffsetY + 5.5 * value * -math.cos(angle)
	end
	return {x, y, 0}
end

local getPentagon = function(size)
	local verts = {}
	for i = 1, 6 do
		angle = 1.25664 * i
		x = radarOffsetX + 11 * size * math.sin(angle)
		y = radarOffsetY + 11 * size * -math.cos(angle)
		verts[#verts+1] = {{x,y,0},scaleColor}
	end
	return verts
end

local getGrooveRadarBg = function()
	t = Def.ActorFrame{}
	for i = 1, 4 do
		t[#t+1] = Def.ActorMultiVertex{
			Name = "GrooveRadarBg"..i,
			InitCommand = function(self)
				self:visible(true)
				self:xy(-30,-30)
				self:SetDrawState{Mode="DrawMode_LineStrip"}
				self:SetVertices(getPentagon(i))
			end,
		}
	end
	return t
end


local af = Def.ActorFrame{
	Name = "TechRadar",
	InitCommand = function(self)
		self:xy(-xpos,ypos)
		self:playcommand("Set")
	end,
	CurrentSongChangedMessageCommand = function(self) self:playcommand("Set") end,
	CurrentStepsP1ChangedMessageCommand = function(self) self:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand = function(self) self:playcommand("Set") end,
	SetCommand = function(self)
		local active = IsECFA2021Song()
	if active then self:playcommand("Show") else self:playcommand("Hide") end
		if active then
			local steps = GAMESTATE:GetCurrentSteps(player)
			if not steps then return end
			radar = TechRadarFromSteps(steps)
		end
	end,
	ShowCommand = function(self)
		self:stoptweening()
		self:decelerate(0.2)
		self:x(xpos)
	end,
	HideCommand = function(self)
		self:stoptweening()
		self:decelerate(0.1)
		self:x(-xpos)
	end,

	-- bg quad
	Def.Quad{
		InitCommand = function(self) self:zoomto(width, height):diffuse(color("#1e282f")) end
	},
	-- Groove Radar bg
	getGrooveRadarBg(),
	-- Groove Radar fill
	Def.ActorMultiVertex{
		Name = "GrooveRadarFill",
		InitCommand = function(self)
			self:visible(true)
			self:xy(-30,-30)
			self:SetDrawState{Mode="DrawMode_QuadStrip"}
			self:SetVertices(zeroVerts)
		end,
		SetCommand = function(self)
			local active = IsECFA2021Song()
			self:visible(active)
			local verts = {}
			if active then
				for i, t in ipairs(elements) do
					if t.key ~= "gimmick" then
						local pos = getRadarVert(i,radar[t.key])
						local color = radarFill
						verts[#verts+1] = {pos,color}
						verts[#verts+1] = zeroVert
					end
				end
				verts[#verts+1] = verts[1]
				verts[#verts+1] = zeroVert
			else
				for i, t in ipairs(elements) do
					verts[#verts+1] = zeroVert
					verts[#verts+1] = zeroVert
				end
			end

			self:stoptweening()
			self:decelerate(0.4)
			self:SetDrawState{First= 1, Num= -1}
			self:SetVertices(verts)
		end,
		HideCommand = function(self)
			self:stoptweening()
			self:visible(false)
		end,
	},
	-- Groove Radar border
	Def.ActorMultiVertex{
		Name = "GrooveRadarBorder",
		InitCommand = function(self)
			self:visible(true)
			self:xy(-30,-30)
			self:SetDrawState{Mode="DrawMode_LineStrip"}
			self:SetVertices(zeroVerts)
		end,
		SetCommand = function(self)
			local active = IsECFA2021Song()
			self:visible(active)
			local verts = {}
			if active then
				for i, t in ipairs(elements) do
					if t.key ~= "gimmick" then
						local pos = getRadarVert(i,radar[t.key])
						local color = radarBorder
						verts[#verts+1] = {pos,color}
					end
				end
				verts[#verts+1] = verts[1]
			else
				for i, t in ipairs(elements) do
					verts[#verts+1] = zeroVert
				end
			end

			self:stoptweening()
			self:decelerate(0.4)
			self:SetDrawState{First= 1}
			self:SetNumVertices(#verts)
			self:SetVertices(verts)
		end,
		HideCommand = function(self)
			self:stoptweening()
			self:visible(false)
		end,
	},
}

-- Add groove radar labels
for i, t in ipairs(elements) do
	-- label
	if t.key ~= "gimmick" then
		local angle = 1.25664 * i
		local labelx = labelOffsetX + 52 * math.sin(angle)
		local labely = labelOffsetY + 45 * -math.cos(angle)
		af[#af+1] = LoadFont("Common Normal")..{
			Text = t.label,
			InitCommand = function(self) self:xy(labelx, labely)
				:horizalign("left"):zoom(zoom * 0.8)
				self:diffuse(color("#b5bdc5"))
				if t.key ~= "gimmick" then self:maxwidth(42/0.7) end
			end
		}
	end
end

-- max dp
af[#af+1] = LoadFont("Common Normal")..{
	Text = "Max DP:",
	InitCommand = function(self)
		self:xy(0, height/2 - 8):horizalign("center"):zoom(zoom * 0.9)
	end,
	SetCommand = function(self)
		local steps = GAMESTATE:GetCurrentSteps(player)
		if radar and steps then
			local dp = CalculateMaxDPByTechRadar(radar)
			if dp then self:settext("Max points: "..ECFAPointString(dp)) end
		end
	end
}

-- cmod ok/no good
af[#af+1] = LoadFont("Common Normal")..{
	Text = "",
	InitCommand = function(self) self:xy(-width/2 + 5, -height/2 + 8)
		:horizalign("left"):zoom(zoom * 0.7) end,
	SetCommand = function(self)
		if radar then
			local cmod = ((not radar.gimmick) or radar.gimmick < 1)
			self:diffuse(cmod and Color.Green or Color.Orange)
			self:settext(cmod and "CMOD OK" or "NO CMOD")
		end
		local active = IsECFA2021Song()
	self:visible(active)
	end
}

-- Gimmick indicator
af[#af+1] = LoadFont("Common Normal")..{
	Text = "",
	InitCommand = function(self) self:xy(-width/2 + 5, -height/2 + 16)
		:horizalign("left"):zoom(zoom * 0.7) end,
	SetCommand = function(self)
		if radar then
			if radar.gimmick > 0 then
				text = gimmicks[radar.gimmick]
			else
				text = ""
			end
			self:settext(text)
			self:diffuse(Color.Orange)
		end
		local active = IsECFA2021Song()
	self:visible(active)
	end
}


return af
