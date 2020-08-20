-- TODO(Sereni): layout
local pane_width = 240
local pane_height = 70
local padding = 10

local af = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(490, _screen.cy - 15)
	end,
}


for i=1,5 do

	local pane = Def.ActorFrame{
		Name="RelicPane"..i,
		InitCommand=function(self) self:xy(10, i*(pane_height) - 212) end,
		OffCommand=function(self)
			self:sleep(0.04 * i):linear(0.2):diffusealpha(0)
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.name then
				if params.name == "(nothing)" then
					self:diffusealpha(0.65)
				else
					self:diffusealpha(1)
				end
			end
		end
	}


	-- primary gray pane
	pane[#pane+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(pane_width, pane_height-2)
				:diffuse(color("#666666"))
				:diffusealpha( DarkUI() and 0.95 or 0.75)
		end,
	}

	-- side black pane
	pane[#pane+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(pane_height+10, pane_height-2):halign(0):x(-120)
				:diffuse(color("#111111"))
				:diffusealpha( DarkUI() and 0.95 or 0.75)
		end,
	}

	-- relic image
	for relic in ivalues(ECS.Relics) do
		pane[#pane+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_relics/" .. relic.img),
			InitCommand=function(self)
				self:xy(-106, -33)
				self:visible(false):zoom(0.25):align(0,0)
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
			self:xy(-80, 18)
				:align(0.5,0):zoom(0.8)
				-- :wrapwidthpixels((pane_height)/0.9)
				:maxwidth(pane_height+10)
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
			self:xy(-35, -32):vertspacing(-6)
				:align(0,0):zoom(0.8)
				:wrapwidthpixels(189)
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
			self:xy(-35, 15)
				:align(0,0):zoom(0.8)
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
			else
				self:settext("")
			end
		end
	}


	af[#af+1] = pane
end

return af
