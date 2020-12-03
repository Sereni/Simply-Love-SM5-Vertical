-- Conditional "tech radar" for ECFA 2021

-- only need to draw one, since both players will be viewing the same chart
local player = GAMESTATE:GetMasterPlayerNumber()

local rowh = 12
local colw = 114
local columns = 1

local width = 125
local height = 105

local headerh = 12

local xpos = width / 2
local ypos = _screen.cy + 165

local barw = colw - 50
local barxadd = 38

local zoom = .6

local radarOffsetX = 30
local radarOffsetY = 25

local labelOffsetX = -15
local labelOffsetY = -5

local elements = {
	{key = "speed", label = "Speed"},
	{key = "stamina", label = "Stamina"},
	{key = "tech", label = "Technique"},
	{key = "movement", label = "Movement"},
	{key = "rhythms", label = "Rhythms"},
	{key = "gimmick", label = "Gimmicks"}
}

local gimmicks = {[-1] = "N/A", [0] = "None", [1] = "Light", [2] = "Medium", [3] = "Heavy"}
local gmkcolors = {Color.Green, Color.Yellow, {1,0.2,0.2,1}}

local rcolors = { {3, Color.Green}, {6, Color.Yellow}, {9, Color.Orange}, {10, {1,0.1,0.1,1}}}
local radarBlue = Color.Blue
local radarTeal = color("#80c9f0")
radarTeal[4] = .7

local radar = {
	speed = 0,
	stamina = 0,
	tech = 0,
	movement = 0,
	rhythms = 0,
	gimmick = 0,
}-- this gets set in af's SetCommand

	-- we use these to initializate the groove radar
local zeroVert = {{radarOffsetX,radarOffsetY,0},radarTeal}
local zeroVerts = {}
for i = 1, 12 do
	zeroVerts[#zeroVerts+1] = zeroVert
end

local getRadarVert = function(index, value)
	local x = 0
	local y = 0
	if index and value then
		angle = 1.25664 * index 
		x = radarOffsetX + 5 * value * math.sin(angle)
		y = radarOffsetY + 5 * value * -math.cos(angle)
	end
	return {x, y, 0}
end

local getPentagon = function(size)
	local verts = {}
	for i = 1, 6 do
		angle = 1.25664 * i
		x = radarOffsetX + 10 * size * math.sin(angle)
		y = radarOffsetY + 10 * size * -math.cos(angle)
		verts[#verts+1] = {{x,y,0},radarBlue}
	end
	return verts
end

local getGrooveRadarBg = function()
	t = Def.ActorFrame{}
	for i = 1, 3 do
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
		self:decelerate(0.2)
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
						local color = radarTeal
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
						local color = radarBlue
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

local startx = -width/2 + 6
local starty = -height/2 + headerh*1.5 + 2

-- add "grid" elements
for i, t in ipairs(elements) do
	-- label
	if t.key ~= "gimmick" then
		local angle = 1.25664 * i 
		local labelx = labelOffsetX + 40 * math.sin(angle)
		local labely = labelOffsetY + 40 * -math.cos(angle)
		local col = (i-1) % columns
		local row = math.floor((i-1)/columns)
		af[#af+1] = LoadFont("Common Normal")..{
			Text = t.label,
			InitCommand = function(self) self:xy(labelx, labely)
				:horizalign("left"):zoom(zoom)
				if t.key ~= "gimmick" then self:maxwidth(42/0.8) end
			end
		}
	end
--GRID	-- bars for visual effect
--GRID	if t.key ~= "gimmick" then
--GRID		af[#af+1] = Def.Quad{
--GRID			InitCommand = function(self) self:xy(startx + (col * (colw + 10)) + barxadd, starty + row*rowh)
--GRID				:horizalign("left"):diffuse(Color.Black):zoomto(barw, rowh-4) end
--GRID		}
--GRID		af[#af+1] = Def.Quad{
--GRID			InitCommand = function(self) self:xy(startx + (col * (colw + 10)) + barxadd, starty + row*rowh)
--GRID				:horizalign("left"):zoomto(0, rowh-4) end,
--GRID			SetCommand = function(self)
--GRID				if radar and radar[t.key] then
--GRID					self:stoptweening()
--GRID					local color = Color.White
--GRID					for c in ivalues(rcolors) do
--GRID						if radar[t.key] <= c[1] then color = c[2] break end
--GRID					end
--GRID					self:decelerate(0.1)
--GRID					self:diffuse(color)
--GRID					self:zoomx((radar[t.key]/10) * barw)
--GRID				end
--GRID			end
--GRID		}
--GRID	end
--GRID	-- values
--GRID	af[#af+1] = LoadFont("Common Normal")..{
--GRID		Text = "",
--GRID		InitCommand = function(self) self:xy(startx + (col * (colw + 10) + colw), starty + row*rowh)
--GRID			:horizalign("right"):zoom(zoom) end,
--GRID		SetCommand = function(self)
--GRID			if radar then
--GRID				local text
--GRID				if t.key == "gimmick" then
--GRID					text = gimmicks[radar.gimmick] or "None"
--GRID					self:diffuse(gmkcolors[radar.gimmick] or Color.White)
--GRID				else
--GRID					text = tostring(radar[t.key])
--GRID				end
--GRID				self:settext(text)
--GRID			end
--GRID		end
--GRID	}
end

-- max dp
af[#af+1] = LoadFont("Common Normal")..{
	Text = "Max DP:",
	InitCommand = function(self)
		self:xy(startx, starty + 6*rowh + 3):horizalign("left"):zoom(zoom*1.2)
	end,
	SetCommand = function(self)
		local steps = GAMESTATE:GetCurrentSteps(player)
		if radar and steps then
			local dp = CalculateMaxDPByTechRadar(radar)
			if dp then self:settext("Max ECFA Points: "..ECFAPointString(dp)) end
		end
	end
}

-- cmod ok/no good
af[#af+1] = LoadFont("Common Normal")..{
	Text = "",
	InitCommand = function(self) self:xy(200, -165)
		:horizalign("right"):zoom(zoom) end,
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

return af
