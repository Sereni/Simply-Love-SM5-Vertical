local pane_width = 220
local pane_height = 30
local padding = 10

local af = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(_screen.cx-289, _screen.cy + 100)
	end,
}

-- ====== Add the Relic Preview Pane ======

local pane = Def.ActorFrame{
	Name="RelicPreviewPane",
	InitCommand=function(self) self:xy(2 + pane_width, -278) end,
	OffCommand=function(self)
		self:sleep(0.04):linear(0.2):diffusealpha(0)
	end,
	RelicPreviewSelectedCommand=function(self, params)
		if params and params.name then
			if params.name == "(nothing)" then
				self:diffusealpha(0.65)
			else
				self:diffusealpha(1)
			end
		end
	end
}

-- relic image
for relic in ivalues(ECS.Relics) do
	pane[#pane+1] = Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/" .. relic.img),
		InitCommand=function(self)
			self:xy(-115, -20)
			self:visible(false):zoom(0.2):align(0,0)
		end,
		RelicPreviewSelectedCommand=function(self, params)
			self:visible(false)
			if params and relic.name == params.name then
				self:visible(true)
			end
		end
	}
end

-- relic effect
pane[#pane+1] = LoadFont("Miso/_miso")..{
	InitCommand=function(self)
		self:xy(-67, 2):vertspacing(-6)
			:align(0,0):zoom(0.5)
			:wrapwidthpixels(350)
	end,
	RelicPreviewSelectedCommand=function(self, params)
		if params and params.effect then
			self:settext(params.effect)
		else
			self:settext("")
		end
	end
}

-- charge remaining
pane[#pane+1] = LoadFont("Miso/_miso")..{
	InitCommand=function(self)
		self:xy(-67, 13)
			:align(0,0):zoom(0.5)
			:wrapwidthpixels(((pane_width-padding*2)/0.9))
	end,
	RelicPreviewSelectedCommand=function(self, params)
		if params then
			if not params.is_consumable then
				self:settext("Remaining: ∞")
			elseif params.quantity then
				self:settext("Remaining: " .. params.quantity)
			else
				self:settext("")
			end
			-- Allow long descriptions to take 2nd line
			if params.effect:len() > 50 then
				self:x(60)
			else
				self:x(-67)
			end
		else
			self:settext("")
		end
	end
}
af[#af+1] = pane

-- ====== Loop over for the 10 potentially selectable relics ======
for i=1,10 do
	local column = 1
	local row = i

	local pane = Def.ActorFrame{
		Name="RelicPane"..i,
		InitCommand=function(self) self:xy((2 + pane_width)*column, row*(pane_height) - 212) end,
		OffCommand=function(self)
			self:sleep(0.04 * column):linear(0.2):diffusealpha(0)
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.name then
				self:diffusealpha(1)
			end
		end
	}

	-- primary gray pane
	pane[#pane+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(pane_width, pane_height-2)
				:diffuse(color("#666666"))
				:diffusealpha( BrighterOptionRows() and 0.95 or 0.75)
		end,
	}

	-- side black pane
	pane[#pane+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(pane_height+10, pane_height-2):halign(0):x(-120)
				:diffuse(color("#111111"))
				:diffusealpha( BrighterOptionRows() and 0.95 or 0.75)
		end,
	}


	-- relic image
	for relic in ivalues(ECS.Relics) do
		pane[#pane+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_relics/" .. relic.img),
			InitCommand=function(self)
				self:xy(-118, -20)
				self:visible(false):zoom(0.2):align(0,0)
			end,
			["Relic"..i.."SelectedCommand"]=function(self, params)
				self:visible(false)
				if params and relic.name == params.name then
					self:visible(true)
				end
			end
		}
	end

	-- relic name
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-118, 5)
				:align(0,0):zoom(0.5)
				:maxwidth(70)
				:vertspacing(-6)
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.name then
				self:settext(params.name)
			else
				self:settext("")
			end
		end
	}

	-- relic effect
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-67, -11):vertspacing(-6)
				:align(0,0):zoom(0.5)
				:wrapwidthpixels(350)
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.effect then
				self:settext(params.effect)
			else
				self:settext("")
			end
		end
	}

	-- charge remaining
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-67, 1)
				:align(0,0):zoom(0.5)
				:wrapwidthpixels(((pane_width-padding*2)/0.9))
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params then
				if not params.is_consumable then
					self:settext("Remaining: ∞")
				elseif params.quantity then
					self:settext("Remaining: " .. params.quantity)
				else
					self:settext("")
				end
				-- Allow long descriptions to take 2nd line
				if params.effect:len() > 50 then
					self:x(60)
				else
					self:x(-67)
				end
			else
				self:settext("")
			end
		end
	}
	af[#af+1] = pane
end

return af
