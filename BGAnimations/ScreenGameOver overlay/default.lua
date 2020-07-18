local Players = GAMESTATE:GetHumanPlayers();

local t = Def.ActorFrame{
	LoadFont("Wendy/_wendy white")..{
		Text="GAME",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-85):croptop(1):fadetop(1):zoom(1):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},
	LoadFont("Wendy/_wendy white")..{
		Text="OVER",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-15):croptop(1):fadetop(1):zoom(1):shadowlength(1) end,
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
