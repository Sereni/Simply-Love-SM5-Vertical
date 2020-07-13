local NumPanes = ...
local players = GAMESTATE:GetHumanPlayers()

local af = Def.ActorFrame{}
af.Name="Panes"

local offset = {
	[PLAYER_1] = _screen.cx,
	[PLAYER_2] = _screen.cx
}

-- add available Panes to the ActorFrame via a loop
-- Note(teejusb): Some of these actors may be nil. This is not a bug, but
-- a feature for any panes we want to be conditional.
	for player in ivalues(players) do
		for i=1, NumPanes do
			local pn = ToEnumShortString(player)
			local player_pane = LoadActor("./Pane"..i, {player, player})

			if player_pane then
				af[#af+1] = Def.ActorFrame{
					Name="Pane"..i.."_".."Side"..pn,
					InitCommand=function(self) self:x(offset[player]) end,
					player_pane
				}
			end
		end
	end

return af
