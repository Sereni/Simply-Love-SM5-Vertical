---------------------------------------------------------------------
-- OptionRow Wheel(s)
---------------------------------------------------------------------
local Rows = {
	"Relic1",
	"Relic2",
	"Relic3",
	"Relic4",
	"Relic5",
	"Exit"
}

-- TODO(Sereni): layout

local active_relics = {}
local is_going_back = false

local IsActiveRelic = function(relic)
	for _relic in ivalues(active_relics) do
		if _relic and _relic.name == relic.name then return true end
	end
	return false
end

-- this works because no single player in ECS has both Order of Ambrosia and Champion Belt
local GetNumActiveRows = function()
	local num_active_rows = 2
	for active_relic in ivalues(active_relics) do
		if active_relic.name == "Order of Ambrosia" then
			num_active_rows = num_active_rows + 2
		elseif active_relic.name == "Champion Belt" then
			num_active_rows = num_active_rows + 1
		end
	end
	return num_active_rows
end

local mpn = GAMESTATE:GetMasterPlayerNumber()
local profile_name = PROFILEMAN:GetPlayerName(mpn)

-- generate a table of possible/valid relics for the player to choose from
local player_relics = { {name="(nothing)"} }

for i,player_relic in ipairs(ECS.Players[profile_name].relics) do
	for master_relic in ivalues(ECS.Relics) do
		if master_relic.name == player_relic.name then
			if not master_relic.is_consumable or player_relic.quantity > 0 then
				if (ECS.Mode == "ECS" and not master_relic.is_marathon) or (ECS.Mode == "Marathon" and master_relic.is_marathon) then
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
local NumRowsToDraw = 6
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
		is_going_back = true
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

			SOUND:PlayOnce(THEME:GetPathS("", "_next row.ogg"))

			OptionRowWheels[pn]:scroll_by_amount(1)

			-- if we've NOW reached the end of the list, don't try to update the pane
			if OptionRowWheels[pn]:get_info_at_focus_pos() == Rows[#Rows] then return false end

			local row = OptionRowWheels[pn]:get_info_at_focus_pos()
			local relic = OptionRowWheels[pn][row]:get_info_at_focus_pos()

			-- broadcast this so that the relic panes to the right update
			SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( row.."Selected", relic )


		elseif event.button == "Select" then
			SOUND:PlayOnce(THEME:GetPathS("", "_prev row.ogg"))

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
				SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( row.."Selected", relic )
				SOUND:PlayOnce(THEME:GetPathS("", "_change value.ogg"))

				-- add the new relic to the active_relics table at the appropriate index
				local newly_active_relic = OptionRowWheels[pn][row]:get_info_at_focus_pos()
				local index = row:gsub("Relic", "")
				active_relics[tonumber(index)] = newly_active_relic

				-- update each row below accordingly
				for i=index+1, math.max(2, GetNumActiveRows()) do

					-- create a smaller list out of non-active relics
					local smaller_list = { {name="(nothing)"} }
					for _relic in ivalues(player_relics) do
						if not IsActiveRelic(_relic) and _relic.name ~= "(nothing)" then
							smaller_list[#smaller_list+1] = _relic
						end
					end

					-- set this optionrow's choices with the new smaller_list
					OptionRowWheels[pn]["Relic"..i]:set_info_set(smaller_list, 1)
					-- and add its focus to the active_relics table
					active_relics[i] = OptionRowWheels[pn]["Relic"..i]:get_info_at_focus_pos()
					-- finally, broadcast the pane to the right that it needs to update
					local relic = OptionRowWheels[pn]["Relic"..i]:get_info_at_focus_pos()
					SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "Relic"..i.."Selected", relic )
				end

				for i=GetNumActiveRows()+1, 4 do
					OptionRowWheels[pn]["Relic"..i]:set_info_set({{name="(nothing)"}}, 1)
					active_relics[i] = OptionRowWheels[pn]["Relic"..i]:get_info_at_focus_pos()
				end
			end

		end
	end

	return false
end

---------------------------------------------------------------------
-- Primary ActorFrame and children
---------------------------------------------------------------------
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
		self:sleep(0.15):queuecommand("StartMusic")

		for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
			local pn = ToEnumShortString(player)

			-- set_info_set() takes two arguments:
			--		a table of meaningful data to divvy up to wheel items
			--		the index of which item we want to initially give focus to
			OptionRowWheels[pn]:set_info_set(Rows, 1)

			for r, Row in ipairs(Rows) do

				if r < #Rows then

					if r < 3 then
						OptionRowWheels[pn][Row]:set_info_set(player_relics, 1)
						OptionRowWheels[pn][Row].focus_pos = 3
						OptionRowWheels[pn][Row]:scroll_by_amount(-1)
					end

					if r >= 3 then
						OptionRowWheels[pn][Row]:set_info_set({{name="(nothing)"}}, 1)
						OptionRowWheels[pn][Row].focus_pos = 3
						OptionRowWheels[pn][Row]:scroll_by_amount(-1)
					end

					local relic = OptionRowWheels[pn][Row]:get_info_at_focus_pos()
					active_relics[r] = relic
					SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( Row.."Selected", relic )
				end

				-- ensure that relic #1 is active
				local relic = OptionRowWheels[pn]["Relic1"]:get_info_at_focus_pos()
				SCREENMAN:GetTopScreen():GetChild("Overlay"):playcommand( "Relic1Selected", relic )
			end
		end

	end,
	StartMusicCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		local path = song:GetMusicPath()
		local preview_length = song:GetSampleLength()
		local preview_start = song:GetSampleStart()

		SOUND:PlayMusicPart(path, preview_start, preview_length, 0, 1, true, true, true)
	end,
	OffCommand=function(self)
		if not is_going_back then
			-- reset player relics table now
			ECS.Player.Relics = {}

			for active_relic in ivalues(active_relics) do
				if active_relic.name ~= "(nothing)" then
					table.insert(ECS.Player.Relics, active_relic)
					active_relic.action()
				end
			end
		end
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
	local x_pos = 190

	local OptionRow_mt = LoadActor("./OptionRowMT.lua", {NumRows=NumRowsToDraw, Player=player, Items=Rows, RowHeight=RowHeight})
	t[#t+1] = OptionRowWheels[pn]:create_actors( "OptionRowWheel"..pn, #Rows, OptionRow_mt, x_pos, 10)


	-- add an OptionRowWheel for each Option for each available player
	for k2, Row in ipairs(Rows) do
		local OptionRowChoice_mt = LoadActor("./OptionRowChoiceMT.lua", {NumRows=7, Player=player, Row=Row})
		x_pos = 210

		local num_choices = 5

		t[#t+1] = OptionRowWheels[pn][Row]:create_actors( "OptionRowChoiceWheel"..ToEnumShortString(player), num_choices, OptionRowChoice_mt, x_pos, k2*RowHeight)
	end
end

t[#t+1] = LoadActor("./pane.lua")

---------------------------------------------------------------------
return t
