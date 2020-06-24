local JoinOrUnjoinPlayersMaybe = function(style, player)
	-- if either player pressed START to choose a style, that player will have
	-- been passed into this function, and we want to unjoin the other player
	-- now for the sake of single or double
	-- if time ran out, no one will have pressed START, so unjoin whichever player
	-- isn't the MasterPlayerNumber
	player = player or GAMESTATE:GetMasterPlayerNumber()

	-- it's possible that PLAYER_1 was the MPN, but then PLAYER_2 selected single on this screen
	-- ensure that player is actually joined now to avoid having no one joined in ScreenSelectPlayMode
	if not GAMESTATE:IsHumanPlayer(player) then GAMESTATE:JoinPlayer(player) end

	-- OtherPlayer convenience table defined in _fallback/Scripts/00 init.lua
	GAMESTATE:UnjoinPlayer(OtherPlayer[player])
end

return Def.ActorFrame{
	OnCommand=function()
		JoinOrUnjoinPlayersMaybe("single", nil)
		GAMESTATE:SetCurrentStyle("single")
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
  end
}
