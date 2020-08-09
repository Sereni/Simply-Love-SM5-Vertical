local af, num_panes = unpack(...)

if not af
or type(num_panes) ~= "number"
then
	return
end

-- -----------------------------------------------------------------------

local panes, active_pane = {}, {}

local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
local players = GAMESTATE:GetHumanPlayers()

local mpn = GAMESTATE:GetMasterPlayerNumber()
-- -----------------------------------------------------------------------

for controller=1,2 do

	panes[controller] = {}

	-- Iterate through all potential panes, and only add the non-nil ones to the
	-- list of panes we want to consider.
	for i=1,num_panes do
		local pane_str = ("Pane%i_SideP%i"):format(i, controller)
		local pane = af:GetChild("Panes"):GetChild(pane_str)

		if pane ~= nil then
				pane:visible(i == 1)
				active_pane[controller] = 1
		 		table.insert(panes[controller], pane)
		end
	end
end

-- -----------------------------------------------------------------------
return function(event)
	if not (event and (event.PlayerNumber == mpn) and event.button) then return false end

	local  cn = tonumber(ToEnumShortString(event.controller))

	if event.type == "InputEventType_FirstPress" and panes[cn] then

		if event.GameButton == "MenuRight" or event.GameButton == "MenuLeft" then
			if event.GameButton == "MenuRight" then
				active_pane[cn] = ((active_pane[cn]    ) % #panes[cn]) + 1

			elseif event.GameButton == "MenuLeft" then
				active_pane[cn] = ((active_pane[cn] - 2) % #panes[cn]) + 1
			end

			-- hide all panes for this side
			for i=1,#panes[cn] do
				panes[cn][i]:visible(false)
			end
			-- show the panes we want on both sides
			panes[cn][active_pane[cn]]:visible(true)

			af:queuecommand("PaneSwitch")
		end
	end

	if PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") and event.type ~= "InputEventType_Repeat" then
		MESSAGEMAN:Broadcast("TestInputEvent", event)
	end

	return false
end
