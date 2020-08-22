-- TODO(Sereni): layout

local pane_width = 240
local pane_height = _screen.h-150
local padding = 10
local optrows = {
	bmts={},
	active = {false, false, false, false}
}

local mpn = GAMESTATE:GetMasterPlayerNumber()
local pn = ToEnumShortString(mpn)
local profile_name = PROFILEMAN:GetPlayerName(mpn)

-- generate a table of possible/valid relics for the player to choose from
local player_relics, active_relics = {}, {}

for i,player_relic in ipairs(ECS.Players[profile_name].relics) do
	for master_relic in ivalues(ECS.Relics) do
		if master_relic.name == player_relic.name then
			if player_relic.chg > 0 then
				player_relics[#player_relics+1] = {
					name=player_relic.name,
					chg=player_relic.chg,
					desc=master_relic.desc,
					effect=master_relic.effect,
					action=master_relic.action
				}
			end
		end
	end
end


-- for _relic in ivalues(ECS.Player.Relics) do
-- 	if _relic.chg and _relic.chg > 0 then
-- 		active_relics[#active_relics+1] = _relic
-- 	end
-- end


local GetNextAvailableRelic = function(dir, row_index)
	if #player_relics < 1 then return end

	local new_relic

	if dir > 0 then
		-- move the old_relic from the active table to the end of the general pool
		table.insert(player_relics, active_relics[row_index])
		new_relic = player_relics[1]
	else
		-- move the old relic from the active table to the front of the general pool
		table.insert(player_relics, 1, active_relics[row_index])
		new_relic = player_relics[#player_relics-1]
	end

	active_relics[row_index] = {
		name=new_relic.name,
		chg=new_relic.chg,
		desc=new_relic.desc,
		effect=new_relic.effect,
		action=new_relic.action
	}

	for j=1, #player_relics do
		if player_relics[j] and player_relics[j].name == new_relic.name then
			table.remove(player_relics, j)
		end
	end

	return new_relic
end

local EnableAndSetOptionRow = function(self, row_index, dir)
	if not dir then dir = 1 end
	local new_relic = GetNextAvailableRelic(dir, row_index)

	if new_relic then
		optrows.active[row_index] = true
		optrows.bmts[row_index]:settext( new_relic.name )
	end
end

local HandleMenuButtonPress = function(dir, row_index, self)
	if not optrows.active[row_index] then return end

	local new_relic = GetNextAvailableRelic(dir, row_index)

	if new_relic then
		-- update the optionrow item text (outside the scope of this overlay file)
		optrows.bmts[row_index]:settext( new_relic.name )
		-- update all pertinent actors within this overlay file
		self:playcommand("Relic"..row_index.."Selected", new_relic)

		if new_relic.name == "Champion Belt" then
			EnableAndSetOptionRow(self, 3)
			self:playcommand("Relic3Selected", active_relics[3])

		elseif new_relic.name == "Order of Ambrosia" then
			EnableAndSetOptionRow(self, 3)
			EnableAndSetOptionRow(self, 4)
			self:playcommand("Relic3Selected", active_relics[3])
			self:playcommand("Relic4Selected", active_relics[4])
		end
	end
end

local DisableOptionRow = function(self, row_index)
	if optrows.active[row_index] then
		local old_relic = active_relics[row_index]
		table.insert(player_relics, old_relic)
		active_relics[row_index] = nil
	end

	optrows.active[row_index] = false
	optrows.bmts[row_index]:settext( "n/a" )
	self:playcommand("Relic"..row_index.."Selected", nil)
end

-- ------------------------------------
local af = Def.ActorFrame{}

af.InitCommand=function(self)
	self:xy(_screen.w*WideScale(0.765,0.8), _screen.cy - 15)
end

af.OnCommand=function(self)
	for i=0,3 do
		table.insert(optrows.bmts, SCREENMAN:GetTopScreen():GetOptionRow(i):GetChild(""):GetChild("Item"))
	end

	-- for i,relic in ipairs(active_relics) do
	-- 	optrows.active[i] = true
	-- 	optrows.bmts[i]:settext( relic.name )
	-- 	self:playcommand("Relic"..i.."Selected", relic)
	--
	-- 	for j=1, #player_relics do
	-- 		if player_relics[j] and (player_relics[j].name == relic.name) then
	-- 			table.remove(player_relics, j)
	-- 			break
	-- 		end
	-- 	end
	-- end

	for i=(#active_relics+1),2 do
		local relic = GetNextAvailableRelic(1, i)
		if relic then
			EnableAndSetOptionRow(self, i)
			self:playcommand("Relic"..i.."Selected", active_relics[i])
		end
	end
end

af.OptionRowChangedMessageCommand=function(self, params)
	local OptionRowName = params.Title:GetParent():GetParent():GetName()
	self:playcommand("Hide"):playcommand("Update"..OptionRowName)
end

af["MenuLeft" .. pn .. "MessageCommand"]=function(self)
	local topscreen = SCREENMAN:GetTopScreen()
	local row_index = topscreen:GetCurrentRowIndex(mpn)+1
	HandleMenuButtonPress(-1, row_index, self)
end

af["MenuRight" .. pn .. "MessageCommand"]=function(self)
	local topscreen = SCREENMAN:GetTopScreen()
	local row_index = topscreen:GetCurrentRowIndex(mpn)+1
	HandleMenuButtonPress(1, row_index, self)
end


-- conveniently, double-stacking via Champion Belt + Order of Ambrosia is not
-- possible in ECS because no single player earned both those relics
-- so, we really only need to worry about catching a stacking relic from rows 1 and 2
af.Relic1SelectedCommand=function(self, params)
	if params.name == "Champion Belt" then

		if player_relics[1] then EnableAndSetOptionRow(self, 3) end

	elseif params.name == "Order of Ambrosia" then

		if player_relics[1] then EnableAndSetOptionRow(self, 3) end
		if player_relics[2] then EnableAndSetOptionRow(self, 4) end

	else
		if optrows.bmts[2]:GetText() == "Order of Ambrosia" then return end

		if optrows.bmts[2]:GetText() == "Champion Belt" then
			DisableOptionRow(self, 4)
			return
		end

		DisableOptionRow(self, 3)
		DisableOptionRow(self, 4)
	end
end
af.Relic2SelectedCommand=function(self, params)
	if params.name == "Champion Belt" then

		if player_relics[1] then EnableAndSetOptionRow(self, 3) end

	elseif params.name == "Order of Ambrosia" then

		if player_relics[1] then EnableAndSetOptionRow(self, 3) end
		if player_relics[2] then EnableAndSetOptionRow(self, 4) end

	else
		if optrows.bmts[1]:GetText() == "Order of Ambrosia" then return end
		if optrows.bmts[1]:GetText() == "Champion Belt" then
			DisableOptionRow(self, 4)
			return
		end

		DisableOptionRow(self, 3)
		DisableOptionRow(self, 4)
	end
end



af.OffCommand=function(self)
	-- reset player relics table now
	ECS.Player.Relics = {}

	for active_relic in ivalues(active_relics) do
		table.insert(ECS.Player.Relics, active_relic)
		active_relic.action()
	end
end


-- primary gray pane
af[#af+1] = Def.Quad{
	InitCommand=function(self)
		self:zoomto(pane_width, pane_height)
			:xy(10,1)
			:diffuse(color("#666666"))
			:diffusealpha( BrighterOptionRows() and 0.95 or 0.75)
	end,
}

-- upper black pane
af[#af+1] = Def.Quad{
	InitCommand=function(self)
		self:zoomto(pane_width, 100)
			:xy(10,-114)
			:diffuse(color("#111111"))
			:diffusealpha( BrighterOptionRows() and 0.95 or 0.75)
	end,
}


for i=1,4 do

	local pane = Def.ActorFrame{
		Name="RelicPane"..i,
		HideCommand=function(self) self:visible(false) end,
		["UpdateRelic"..i.."Command"]=function(self) self:visible(true) end
	}


	-- relic #
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		Text="Relic #"..i,
		InitCommand=function(self)
			self:xy(-pane_width/2 + padding*2, -pane_height/2 + padding)
				:align(0, 0):zoom(1)
				:wrapwidthpixels(pane_width-padding*2)
		end,
	}

	-- relic image
	for relic in ivalues(ECS.Relics) do
		pane[#pane+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_relics/" .. relic.img),
			InitCommand=function(self)
				self:xy(-pane_width/2 + padding*2, -134):visible(false):zoom(0.8):align(0,0)
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
			self:xy(-20, -pane_height/2 + padding)
				:align(0,0):zoom(1)
				:wrapwidthpixels((pane_width-padding*2)/0.9)
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.name then
				self:settext(params.name)
			else
				self:settext("")
			end
		end
	}

	-- relic desc
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-20, -130)
				:align(0,0):zoom(0.55)
				:wrapwidthpixels(((pane_width-padding*2)/1.6)/0.55)
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.desc then
				self:settext(params.desc)
			else
				self:settext("")
			end
		end
	}

	-- relic effect
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-pane_width/2 + padding*2, -50)
				:align(0,0):zoom(0.9)
				:wrapwidthpixels(((pane_width-padding*2)/0.9))
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.effect then
				self:settext("Effect:\n" .. params.effect)
			else
				self:settext("Effect:")
			end
		end
	}

	-- charge remaining
	pane[#pane+1] = LoadFont("Miso/_miso")..{
		InitCommand=function(self)
			self:xy(-pane_width/2 + padding*2, 30)
				:align(0,0):zoom(0.9)
				:wrapwidthpixels(((pane_width-padding*2)/0.9))
		end,
		["Relic"..i.."SelectedCommand"]=function(self, params)
			if params and params.chg then
				self:settext("Charge Remaining:\n" .. params.chg)
			else
				self:settext("Charge Remaining:")
			end
		end
	}


	af[#af+1] = pane
end


return af
