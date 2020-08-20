local player = ...

local af = Def.ActorFrame{
	InitCommand=function(self) end,
	OnCommand=function(self)
		if ECS.Mode == "ECS" then
			local song_name = GAMESTATE:GetCurrentSong():GetDisplayFullTitle()

			local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
			local PercentDP = stats:GetPercentDancePoints()
			local percent = FormatPercentScore(PercentDP)
			-- Format the Percentage string, removing the % symbol
			percent = percent:gsub("%%", "")
			local score = tonumber(percent)/100

			AddPlayedSong(ECS.Players[PROFILEMAN:GetPlayerName(player)], song_name, score, ECS.Player.Relics, stats:GetFailed())
		end
	end,

}

return af