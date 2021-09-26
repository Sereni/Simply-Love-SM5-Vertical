local Players = GAMESTATE:GetHumanPlayers();
local isECS = ECS.Mode == "ECS" or ECS.Mode == "Marathon"

local t = Def.ActorFrame{
	LoadFont("Wendy/_wendy white")..{
		Text="GAME",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-85):croptop(1):fadetop(1):zoom(1):shadowlength(1):visible(not isECS) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},
	LoadFont("Wendy/_wendy white")..{
		Text="OVER",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-15):croptop(1):fadetop(1):zoom(1):shadowlength(1):visible(not isECS) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},

	-- Stats BG
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(_screen.w,_screen.h/4):xy(_screen.w/2, _screen.h-_screen.h/4/2):diffuse(color("#00000099"))
			if ThemePrefs.Get("RainbowMode") then self:diffuse(color("#000000dd")) end
		end,
	},
}

if isECS then
	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		Text="Final Set Points",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-50):croptop(1):fadetop(1):zoom(0.3):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	}

	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy):croptop(1):fadetop(1):zoom(0.8):shadowlength(1) end,
		OnCommand=function(self)
			self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1)

			if ECS.Mode == "ECS" then

				-- Add best 7 scores and also check which end of set relics were active.
				local total_points = 0
				local slime_badge = 0
				local agility_potion = 0
				local stamina_potion = 0
				local accuracy_potion = 0
				local tpa_standard = 0
				local memepeace_beret = 0
				local cultist_robes = 0

				for i=1,7 do
					local song_played = ECS.Player.SongsPlayed[i]
					if song_played ~= nil then
						total_points = total_points + song_played.points
						-- Relics are only active if you passed the song you used them on.
						if not song_played.failed then
							for relic in ivalues(song_played.relics_used) do
								if relic.name == "Slime Badge" then
									slime_badge = slime_badge + 1
								end
								if relic.name == "Agility Potion" then
									agility_potion = agility_potion + 1
								end
								if relic.name == "Stamina Potion" then
									stamina_potion = stamina_potion + 1
								end
								if relic.name == "Accuracy Potion" then
									accuracy_potion = accuracy_potion + 1
								end
								if relic.name == "TPA Standard" then
									tpa_standard = tpa_standard + 1
								end
								if relic.name == "Memepeace Beret" then
									memepeace_beret = memepeace_beret + 1
								end
								if relic.name == "Cultist Robes" then
									cultist_robes = cultist_robes + 1
								end
							end
						end
					end
				end

				-- Add additional BP from the end of set relics
				local songs_passed = 0
				local total_bpm = 0
				local tiers = {}
				local total_steps = 0
				local total_score = 0
				local total_over_95 = 0
				local cultist_songs = 0
				for song_played in ivalues(ECS.Player.SongsPlayed) do
					if not song_played.failed then
						total_bpm = total_bpm + song_played.bpm
						if tiers[song_played.bpm_tier] == nil then
							tiers[song_played.bpm_tier] = 0
						end
						tiers[song_played.bpm_tier] = tiers[song_played.bpm_tier] + 1
						total_steps = total_steps + song_played.steps
						songs_passed = songs_passed + 1
						total_score = total_score + song_played.score
						if song_played.score >= 0.95 then
							total_over_95 = total_over_95 + 1
						end

						if (song_played.stepartist:find("Archi") or
							song_played.stepartist:find("@@") or
							song_played.stepartist:find("Zaia") or
							song_played.stepartist:find("Aoreo") or
							song_played.stepartist:find("YourVinished") or
							song_played.stepartist:find("ITGAlex") or
							song_played.stepartist:find("Rems")) then
							cultist_songs = cultist_songs + 1
						end
					end
				end
				local slime_tiers = 0
				local beret_tiers = 0
				for tier, num in pairs(tiers) do
					-- Slime badge only considers tiers below 210 now.
					if tier < 210 then
						slime_tiers = slime_tiers + 1
					-- While the Memepeace beret only considers tiers 210 and above
					else
						beret_tiers = beret_tiers + 1
					end
				end

				if slime_badge > 0 then total_points = total_points + (100 * slime_tiers) * slime_badge end
				if agility_potion > 0 then total_points = total_points + (math.floor(((total_bpm / songs_passed) - 120)^1.3)) * agility_potion end
				if stamina_potion > 0 then total_points = total_points + (math.floor(total_steps / 75)) * stamina_potion end
				if accuracy_potion > 0 then total_points = total_points + (math.max(math.floor(1000^(total_score / songs_passed)-250), 0)) * accuracy_potion end
				if tpa_standard > 0 then total_points = total_points + (100 * total_over_95) * tpa_standard end
				if memepeace_beret > 0 then total_points = total_points + (100 * beret_tiers) * memepeace_beret end
				if cultist_robes > 0 then total_points = total_points + (75 * cultist_songs) * cultist_robes end

				self:settext(tostring(total_points))
			elseif ECS.Mode == "Marathon" then
				self:settext(tostring(ECS.Player.TotalMarathonPoints))
			end
		end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	}
end

for player in ivalues(Players) do

	local line_height = 30
	local x_offset = 60
	local y_offset = _screen.h-_screen.h/4
	local stat_zoom = 0.6
	local max_width = 200
	local x_col1 = _screen.cx
	local x_col2 = _screen.cx
	local PlayerStatsAF = Def.ActorFrame{ Name="PlayerStatsAF_"..ToEnumShortString(player) }
	local stats

	-- first, check if this player is using a profile (local or MemoryCard)
	if PROFILEMAN:IsPersistentProfile(player) then

	  -- Change layout to accommodate more stats into two columns
		x_col1 = _screen.cx - x_offset
		x_col2 = _screen.cx + x_offset

		-- if a profile is in use, grab gameplay stats for this session that are pertinent
		-- to this specific player's profile (highscore name, calories burned, total songs played)
		local profile_stats = LoadActor("PlayerStatsWithProfile.lua", player)

		-- loop through those stats, adding them to the ActorFrame for this player as BitmapText actors
		for i,stat in ipairs(profile_stats) do
			PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
				Text=stat,
				InitCommand=function(self)
					self:diffuse(PlayerColor(player))
						:xy(x_col1, (line_height*(i)) + y_offset)
						:maxwidth(max_width)
						:zoom(stat_zoom)
						DiffuseEmojis(self)
				end
			}
		end

	end

	-- retrieve general gameplay session stats for which a profile is not needed
	stats = LoadActor("PlayerStatsWithoutProfile.lua", player)

	-- loop through those stats, adding them to the ActorFrame for this player as BitmapText actors
	for i,stat in ipairs(stats) do
		PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
			Text=stat,
			InitCommand=function(self)
				self:diffuse(PlayerColor(player))
					:xy(x_col2, (line_height*i) + y_offset)
					:maxwidth(max_width)
					:zoom(stat_zoom)
			end
		}
	end

	t[#t+1] = PlayerStatsAF
end

return t
