local af, num_panes = unpack(...)

if not af
or type(num_panes) ~= "number"
then
	return
end

-- -----------------------------------------------------------------------
-- local variables

local panes, active_pane = {}, {}

local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
local players = GAMESTATE:GetHumanPlayers()

local mpn = GAMESTATE:GetMasterPlayerNumber()

-- since we're potentially retrieving from player profile
-- perform some rudimentary validation by clamping both
-- values to be within permitted ranges
-- FIXME: num_panes won't be accurate if any panes were nil,
--        so this is more like "validation" than validation

local primary_i   = clamp(SL[ToEnumShortString(mpn)].EvalPanePrimary,   1, num_panes)
local secondary_i = clamp(SL[ToEnumShortString(mpn)].EvalPaneSecondary, 1, num_panes)

-- -----------------------------------------------------------------------
-- initialize local tables (panes, active_pane) for the the input handling function to use

for controller=1,2 do

	panes[controller] = {}

	-- Iterate through all potential panes, and only add the non-nil ones to the
	-- list of panes we want to consider.
	for i=1,num_panes do

		local pane = af:GetChild("Panes"):GetChild( ("Pane%i_SideP%i"):format(i, controller) )

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

	-- get a "controller number" and an "other controller number"
	-- if the input event came from GameController_1, cn will be 1 and ocn will be 2
	-- if the input event came from GameController_2, cn will be 2 and ocn will be 1
	--
	-- we'll use these integers to index the active_pane table, which keeps track
	-- of which pane is currently showing on each side
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
