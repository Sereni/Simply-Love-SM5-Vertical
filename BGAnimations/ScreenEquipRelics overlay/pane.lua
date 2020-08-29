local pane_width = 220
local pane_height = 50
local padding = 10

local af = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(130, _screen.cy-16)
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

	-- relic image
	for relic in ivalues(ECS.Relics) do
		pane[#pane+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_relics/" .. relic.img),
			InitCommand=function(self)
				self:xy(-115, -20)
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

	-- relic effect
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-67, 2):vertspacing(-6)
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
			self:xy(-67, 13)
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
				if params.name == "(nothing)" then
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
