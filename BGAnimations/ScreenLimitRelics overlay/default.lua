---------------------------------------------------------------------
-- OptionRow Wheel(s)
---------------------------------------------------------------------
local Rows = {
	"Relics",
	"Exit"
}

local mpn = GAMESTATE:GetMasterPlayerNumber()
local profile_name = PROFILEMAN:GetPlayerName(mpn)

-- generate a table of possible/valid relics for the player to choose from
local player_relics = {}
local chosen_relics = {}

for i,player_relic in ipairs(ECS.Players[profile_name].relics) do
	for master_relic in ivalues(ECS.Relics) do
		if master_relic.name == player_relic.name then
			if not master_relic.is_consumable or player_relic.quantity > 0 then
				if ECS.Mode == "ECS" and not master_relic.is_marathon then
					player_relics[#player_relics+1] = {
						name=master_relic.name,
						quantity=player_relic.quantity,
						is_consumable=master_relic.is_consumable,
						desc=master_relic.desc,
						effect=master_relic.effect,
						action=master_relic.action
					}
				end
			end
		end
	end
end

-- the number of rows that can be vertically stacked on-screen simultaneously
local NumRowsToDraw = 1
local header_height = 32
local footer_height = 32
local RowHeight = 70

local OptionRowWheels = {}

for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
	local pn = ToEnumShortString(player)

	-- Add one OptionWheel per human player
	OptionRowWheels[pn] = setmetatable({}, sick_wheel_mt)

	for optionrow in ivalues(Rows) do
		-- Add one OptionRowWheel per OptionRow
		OptionRowWheels[pn][optionrow] = setmetatable({} , sick_wheel_mt)
	end
end

---------------------------------------------------------------------
-- Initialize Generalized Event Handling function(s)
---------------------------------------------------------------------

local InputHandler = function(event)
	----------------------------------------------------------------------------

	-- if any of these, don't attempt to handle input
	if not event.PlayerNumber or not event.button or event.PlayerNumber ~= mpn then
		return false
	end

	if event.type == "InputEventType_FirstPress" and event.button == "Back" then
		SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand("Off")
								:sleep(0.85):queuecommand("TransitionBack")
	end


	-- truncate "PlayerNumber_P1" into "P1" and "PlayerNumber_P2" into "P2"
	local pn = ToEnumShortString(event.PlayerNumber)

	if event.type ~= "InputEventType_Release" then

		if event.button == "Start" then

			-- if we've reached the end of the list, don't wrap around
			if OptionRowWheels[pn]:get_info_at_focus_pos() == Rows[#Rows] then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
				return false
			end

			local row = OptionRowWheels[pn]:get_info_at_focus_pos()
			local relic = OptionRowWheels[pn][row]:get_info_at_focus_pos()
			
			local found_index = -1
			for i, chosen in ipairs(chosen_relics) do
				if chosen.name == relic.name then
					found_index = i
					break
				end
			end

			if found_index == -1 then
				if #chosen_relics < 10 then
					chosen_relics[#chosen_relics+1] = relic
					-- broadcast this so that the relic panes to the right update
					SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "Relic".. #chosen_relics .."Selected", relic )
				end
			else
				SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "Relic".. #chosen_relics .."Selected", nil )
				table.remove(chosen_relics, found_index)
				for i, chosen in ipairs(chosen_relics) do
					SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "Relic".. i .."Selected", chosen )
				end
			end

			if #chosen_relics >= 10 then
				OptionRowWheels[pn]:scroll_by_amount(1)
			end

			-- if we've NOW reached the end of the list, don't try to update the pane
			if OptionRowWheels[pn]:get_info_at_focus_pos() == Rows[#Rows] then return false end
		elseif event.button == "Select" then
			OptionRowWheels[pn]:scroll_by_amount(-1)
			-- if we've NOW reached the end of the list, don't try to update the pane
			if OptionRowWheels[pn]:get_info_at_focus_pos() == Rows[#Rows] then return false end

			local row = OptionRowWheels[pn]:get_info_at_focus_pos()
			local relic = OptionRowWheels[pn][row]:get_info_at_focus_pos()
			SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( row.."Selected", relic )


		elseif event.button == "MenuLeft" or event.button == "MenuRight" then

			local row = OptionRowWheels[pn]:get_info_at_focus_pos()

			-- if not the exit row
			if row ~= Rows[#Rows] then

				-- handle menuleft and menu right
				if event.button == "MenuLeft" then
					OptionRowWheels[pn][row]:scroll_by_amount(-1)
				elseif event.button == "MenuRight" then
					OptionRowWheels[pn][row]:scroll_by_amount(1)
				end

				local row = OptionRowWheels[pn]:get_info_at_focus_pos()
				local relic = OptionRowWheels[pn][row]:get_info_at_focus_pos()
				SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "RelicPreviewSelected", relic )
			end
		end
	end

	return false
end																									

local t = Def.ActorFrame{
	InitCommand=function(self)
		-- queue the next command so that we can actually GetTopScreen()
		self:queuecommand("Capture")

		if IsUsingWideScreen() then self:x(110) end
	end,
	CaptureCommand=function(self)
		-- attach our InputHandler to the TopScreen and pass it this ActorFrame
		-- so we can manipulate stuff more easily from there
		SCREENMAN:GetTopScreen():AddInputCallback( InputHandler )
	end,
	OnCommand=function(self)
		for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
			local pn = ToEnumShortString(player)

			-- set_info_set() takes two arguments:
			--		a table of meaningful data to divvy up to wheel items
			--		the index of which item we want to initially give focus to
			OptionRowWheels[pn]:set_info_set(Rows, 1)

			OptionRowWheels[pn]["Relics"]:set_info_set(player_relics, 1)
			OptionRowWheels[pn]["Relics"].focus_pos = 3
			OptionRowWheels[pn]["Relics"]:scroll_by_amount(-1)

			-- ensure that relic #1 is active
			local relic = OptionRowWheels[pn]["Relics"]:get_info_at_focus_pos()
			SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "RelicPreviewSelected", relic )
		end
	end,
	OffCommand=function(self)
		local all_relics = {}

		-- First add all the chosen relics.
		for chosen_relic in ivalues(chosen_relics) do
			for master_relic in ivalues(ECS.Relics) do
				if master_relic.name == chosen_relic.name then
					all_relics[#all_relics+1] = {
						name=chosen_relic.name,
						quantity=chosen_relic.quantity,
					}
				end
			end
		end

		-- Then add the available marathon relics.
		for player_relic in ivalues(ECS.Players[profile_name].relics) do
			for master_relic in ivalues(ECS.Relics) do
				if master_relic.name == player_relic.name then
					if master_relic.is_marathon then
						all_relics[#all_relics+1] = {
							name=player_relic.name,
							quantity=player_relic.quantity,
						}
					end
				end
			end
		end

		-- Update the complete table.
		ECS.Players[profile_name].relics = all_relics
	end,
	TransitionBackCommand=function(self)
		SCREENMAN:GetTopScreen():PostScreenMessage("SM_GoToPrevScreen",0)
	end,
	RelicActivatedMessageCommand=function(self, params)
	end,
	TransitionBackCommand=function(self)
		SCREENMAN:GetTopScreen():PostScreenMessage("SM_GoToPrevScreen",0)
	end,
	-- fade out when exiting the screen
	Def.Quad{
		InitCommand=function(self)
			self:FullScreen():diffuse(0,0,0,0)
			if IsUsingWideScreen() then self:Center():addx(-110) end
		end,
		OffCommand=function(self) self:sleep(0.3):linear(0.55):diffusealpha(1) end
	}
}

-- add an OptionWheel for each available player
for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	local pn = ToEnumShortString(player)
	-- local x_pos = _screen.cx-(_screen.w*160/640)
	local x_pos = 118

	local OptionRow_mt = LoadActor("./OptionRowMT.lua", {NumRows=NumRowsToDraw, Player=player, Items=Rows, RowHeight=RowHeight})
	t[#t+1] = OptionRowWheels[pn]:create_actors( "OptionRowWheel"..pn, #Rows, OptionRow_mt, x_pos, 10)


	-- add an OptionRowWheel for each Option for each available player
	for k2, Row in ipairs(Rows) do
		local OptionRowChoice_mt = LoadActor("./OptionRowChoiceMT.lua", {NumRows=7, Player=player, Row=Row})
		x_pos = 138

		local num_choices = 5

		t[#t+1] = OptionRowWheels[pn][Row]:create_actors( "OptionRowChoiceWheel"..ToEnumShortString(player), num_choices, OptionRowChoice_mt, x_pos, k2*RowHeight)
	end
end

t[#t+1] = LoadActor("./pane.lua")

-- ---------------------------------------------------------------------
return t