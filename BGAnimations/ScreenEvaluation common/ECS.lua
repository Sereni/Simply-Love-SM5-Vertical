local player = ...

local af = Def.ActorFrame{
	InitCommand=function(self) end,
	OnCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		local ecs_player = ECS.Players[PROFILEMAN:GetPlayerName(player)]

		local song_name = song:GetDisplayFullTitle()
		local group_name = song:GetGroupName()

		local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
		local PercentDP = stats:GetPercentDancePoints()
		local percent = FormatPercentScore(PercentDP)
		-- Format the Percentage string, removing the % symbol
		percent = percent:gsub("%%", "")
		local score = tonumber(percent)/100

		local failed = stats:GetFailed()

		if ECS.Mode == "ECS" then
			AddPlayedSong(ecs_player, song_name, score, ECS.Player.Relics, failed)
			if failed then
				SOUND:PlayOnce(THEME:GetPathS("", "mario_oof.ogg"))
			else
				SOUND:PlayOnce(THEME:GetPathS("", "mario_1up.ogg"))
			end
		elseif ECS.Mode == "Marathon" then
			if ((GetDivision() == "upper" and group_name == "ECS10 - Upper Marathon" and song_name == "In Memoriam") or
				(GetDivision() == "mid" and group_name == "ECS10 - Mid Marathon" and song_name == "ECS Classics (Side B-A)") or
				(GetDivision() == "lower" and group_name == "ECS10 - Lower Marathon" and song_name == "ECS Classics (Side A)")) then

				ECS.Player.TotalMarathonPoints = 35000 * score
				if failed then
					SOUND:PlayOnce(THEME:GetPathS("", "mario_oof.ogg"))
				else
					ECS.Player.TotalMarathonPoints = ECS.Player.TotalMarathonPoints + 10000
					SOUND:PlayOnce(THEME:GetPathS("", "mario_1up.ogg"))
				end
				-- Relics for marathons are always applied regarldess of pass/fail.
				for relic in ivalues(ECS.Player.Relics) do
					if relic.name ~= "(nothing)" then
						-- All marathon relics return pure numeric values. We don't need to pass any real values to the score function.
						ECS.Player.TotalMarathonPoints = (ECS.Player.TotalMarathonPoints +
							relic.score(--[[ecs_player=]]nil, --[[song_info=]]nil, --[[song_data=]]nil, --[[relics_used]]nil, --[[ap=]]nil))
					end
				end
				ECS.Player.TotalMarathonPoints = math.floor(ECS.Player.TotalMarathonPoints)
			end
		end
	end,

}

return af
