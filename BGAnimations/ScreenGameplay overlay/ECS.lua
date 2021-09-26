local player = ...
local profile_name = PROFILEMAN:GetPlayerName(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local CreateScoreFile = function(day, month_string, year, seconds, hour, minute, second)
	local passed_song = pss:GetFailed() and "Failed" or "Passed"

	local dance_points = pss:GetPercentDancePoints()
	local percent_score = FormatPercentScore( dance_points ):sub(1,-2):gsub(" ", "")

	local song = GAMESTATE:GetCurrentSong()
	local group_name = song:GetGroupName()
	local song_name = song:GetMainTitle()

	if GetDivision() == nil then return end

	if GetDivision() == "upper" then
		if ECS.Mode == "ECS" and group_name ~= "ECS10 - Upper" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS10 - Upper Marathon" then return end
	elseif GetDivision() == "mid" then
		if ECS.Mode == "ECS" and group_name ~= "ECS10 - Mid" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS10 - Mid Marathon" then return end
	else
		if ECS.Mode == "ECS" and group_name ~= "ECS10 - Lower" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS10 - Lower Marathon" then return end
	end

	-- ----------------------------------------------------------
	local base_theme_path = THEME:GetCurrentThemeDirectory()
	local path = base_theme_path.."ECSData/"..day..month_string..year.."-"..seconds.."-"..ECS.Players[profile_name].id.."-".."SCORE"..".txt"

	local data = ""
	data = data..percent_score .."\n"
	data = data..passed_song.."\n"
	data = data..group_name.."\n"
	data = data..song_name.."\n"
	data = data..day.." "..month_string.." "..year.."\n"
	data = data..hour..":"..minute..":"..second

	local f = RageFileUtil.CreateRageFile()

	if f:Open(path, 2) then
		f:Write( data )
	else
		local fError = f:GetError()
		SM("There was some kind of error writing your score to disk.  You should let Ian know.")
		Trace( "[FileUtils] Error writing to ".. path ..": ".. fError )
		f:ClearError()
	end

	f:destroy()
end

local CreateRelicFile = function(day, month_string, year, seconds)
	local song = GAMESTATE:GetCurrentSong()
	local group_name = song:GetGroupName()

	if GetDivision() == nil then return end

	if GetDivision() == "upper" then
		if ECS.Mode == "ECS" and group_name ~= "ECS10 - Upper" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS10 - Upper Marathon" then return end
	elseif GetDivision() == "mid" then
		if ECS.Mode == "ECS" and group_name ~= "ECS10 - Mid" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS10 - Mid Marathon" then return end
	else
		if ECS.Mode == "ECS" and group_name ~= "ECS10 - Lower" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS10 - Lower Marathon" then return end
	end

	local base_theme_path = THEME:GetCurrentThemeDirectory()
	local path = base_theme_path.."ECSData/"..day..month_string..year.."-"..seconds.."-"..ECS.Players[profile_name].id.."-".."RELIC"..".txt"
	local data = ""

	for i=1, 5 do
		local relic = ECS.Player.Relics[i]
		local name =  relic and relic.name or "*"

		data = data .. name .. "\n"
	end

	local f = RageFileUtil.CreateRageFile()

	if f:Open(path, 2) then
		f:Write( data )
	else
		local fError = f:GetError()
		SM("There was some kind of error writing your score to disk.  You should let Ian know.")
		Trace( "[FileUtils] Error writing to ".. path ..": ".. fError )
		f:ClearError()
	end

	f:destroy()
end

-- ----------------------------------------------------------
local WriteRelicDataToDisk = function()

	local p = PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()] + 1
	local profile_dir = PROFILEMAN:GetProfileDir("ProfileSlot_Player"..p)

	if profile_dir then

		local s = "return {\n"
		for relic in ivalues(ECS.Players[profile_name].relics) do
			if relic.quantity then
				s = s .. "\t{name=\"" .. relic.name .. "\", quantity=" .. relic.quantity .."},\n"
			else
				s = s .. "\t{name=\"" .. relic.name .. "\"},\n"
			end
		end
		s = s .. "}"


		local f = RageFileUtil.CreateRageFile()
		local path = profile_dir.."Player_Relic_Data.lua"

		if f:Open(path, 2) then
			f:Write( s )
		else
			local fError = f:GetError()
			Trace( "[FileUtils] Error writing to ".. path ..": ".. fError )
			f:ClearError()
		end

		f:destroy()
	end
end

-- ----------------------------------------------------------
-- We need a way to check if the player gave up before the song properly ended.
-- It doesn't look like the engine broadcasts any messages that would be helpful here,
-- so we do the best we can by toggling a flag when the player presses START.
--
-- If the screen's OffCommand occurs while START is being held, we assume they gave up early.
-- It's certainly not foolproof, but I'm unsure how else to handle this.

local start_is_being_held = false

local InputHandler = function(event)
	if not event.PlayerNumber or not event.button then return false	end

	if event.GameButton == "Start" then
		start_is_being_held = (not (event.type == "InputEventType_Release"))
	end
end

-- ----------------------------------------------------------

local ExpendChargesOnActiveRelics = function()
	for relic in ivalues(ECS.Players[profile_name].relics) do
		for active_relic in ivalues(ECS.Player.Relics) do
			if active_relic.name == relic.name and relic.quantity ~= nil then
				relic.quantity = relic.quantity - 1
			end
		end
	end
end

-- ----------------------------------------------------------

local ApplyRelicActions = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		active_relic.action(ECS.Player.Relics)
	end
end

-- ----------------------------------------------------------
-- actually hook into the screen so that we can do thing at screen's OnCommand and OffCommand
local af = Def.ActorFrame{}
af[#af+1] = Def.Actor{
	OnCommand=function(self)
		if ECS.Mode == "ECS" or ECS.Mode == "Marathon" then
			-- relic actions depend on the current screen,
			-- so ApplyRelicActions() must be called from OnCommand
			ApplyRelicActions()

			ExpendChargesOnActiveRelics()
		end

		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
	end,
	OffCommand=function(self)
		if start_is_being_held then
			pss:FailPlayer()
			passed_song = "Failed"
		end

		if ECS.Mode == "ECS" or ECS.Mode == "Marathon" then
			local year, month, day = Year(), MonthOfYear() + 1, DayOfMonth()
			local hour, minute, second = Hour(), Minute(), Second()
			local seconds = (hour*60*60) + (minute*60) + second
			local month_string = THEME:GetString("Months", "Month"..month)

			CreateScoreFile(day, month_string, year, seconds, hour, minute, second)
			CreateRelicFile(day, month_string, year, seconds)
			WriteRelicDataToDisk()
		end
	end
}

-- -----------------------------------------------------------------------
-- prefer the engine's SecondsToHMMSS()
-- but define it ourselves if it isn't provided by this version of SM5
local mmss = "%02d:%02d"

local SecondsToMMSS = function(s)
	-- native floor division sounds nice but isn't available in Lua 5.1
	local mins  = math.floor((s % 3600) / 60)
	local secs  = s - (mins * 60)
	return mmss:format(mins, secs)
end

local FaustsScalpelIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Faust's Scalpel" then
			return true
		end
	end
	return false
end

local second_to_pause = {
	["lower"] = 1699.301270,
	["mid"] = 1223.617676,
	["upper"] = 1953.137939,
}

local pause_duration_seconds = 300
local elapsed_seconds = 0

local InputHandler = function(event)
	if not event.PlayerNumber or not event.button then return false end

	if event.type == "InputEventType_FirstPress" and event.GameButton == "Start" then
		MESSAGEMAN:Broadcast("UnpauseMarathon")
	end

	return false
end

local IsPlayingMarathon = function()
	local song = GAMESTATE:GetCurrentSong()
	local group_name = song:GetGroupName()
	local song_name = song:GetMainTitle()
	if GetDivision() == "upper" then
		return group_name == "ECS10 - Upper Marathon" and song_name == "In Memoriam"
	elseif GetDivision() == "mid" then
		return group_name == "ECS10 - Mid Marathon" and song_name == "ECS Classics (Side B-A)"
	else
		return group_name == "ECS10 - Lower Marathon" and song_name == "ECS Classics (Side A)"
	end
end

if ECS.Mode == "Marathon" and FaustsScalpelIsActive() and IsPlayingMarathon() then
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self) end,
		OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback( InputHandler ) self:queuecommand("Loop") end,
		LoopCommand=function(self)
			if GAMESTATE:GetNumPlayersEnabled() == 1 then
				-- We don't need to divide by rate since we always want the break to happen in the same spot regardless.
				local cur_second = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
				if cur_second >= second_to_pause[GetDivision()] then
					self:queuecommand("PauseMarathon")
				else
					self:sleep(0.1):queuecommand("Loop")
				end
			end
		end,
		PauseMarathonCommand=function(self)
			SCREENMAN:GetTopScreen():PauseGame(true)
			self:queuecommand("Wait")
		end,
		WaitCommand=function(self)
			if SCREENMAN:GetTopScreen():IsPaused() then
				elapsed_seconds = elapsed_seconds + 1
				if elapsed_seconds < pause_duration_seconds then
					self:sleep(1):queuecommand("Wait")
				else
					MESSAGEMAN:Broadcast("UnpauseMarathon")
				end
			end
		end,
		UnpauseMarathonMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():IsPaused() then
				SCREENMAN:GetTopScreen():PauseGame(false)
			end
		end,

		Def.ActorFrame {
			InitCommand=function(self) self:visible(false) end,
			WaitCommand=function(self)
				if SCREENMAN:GetTopScreen():IsPaused() then
					self:visible(true)
				end
			end,
			UnpauseCommand=function(self) self:visible(false) end,
			-- slightly darken the entire screen
			Def.Quad {
				InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0.4) end
			},
			Def.Quad {
				InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):diffuse(Color.White):zoomto(202, 202) end
			},
			Def.Quad {
				InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):diffuse(Color.Black):zoomto(200, 200) end
			},
			LoadFont("Common Normal")..{
				InitCommand=function(self)
					local text = "You may end your break time early by pressing the &START; button"
					self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+40):wrapwidthpixels(200):settext(text)
				end,
			}
		},

		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left):xy(_screen.cx-70, 57):zoom(0.8)
			end,
			LoopCommand=function(self)
				local cur_second = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
				if cur_second > 0 then
					if cur_second < second_to_pause then
						self:settext(SecondsToMMSS((second_to_pause - cur_second + 1)/SL.Global.ActiveModifiers.MusicRate))
					end
				end
			end,
			WaitCommand=function(self)
				local remaining_pause_duration = pause_duration_seconds - elapsed_seconds + 1
				self:horizalign(center):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-25):zoom(1)
				if remaining_pause_duration >= 0 then
					if remaining_pause_duration <= 5 then
						self:diffuse(color("#ff3030"))
					end
					self:settext(SecondsToMMSS(remaining_pause_duration))
				end
			end,
			UnpauseMarathonMessageCommand=function(self)
				self:visible(false)
			end,
		},
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right):xy(_screen.cx-77, 57):settext("Pausing in"):zoom(0.8):visible(true)
			end,
			WaitCommand=function(self)
				self:horizalign(center):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-50)
				self:settext("Unpausing in:")
			end,
			UnpauseMarathonMessageCommand=function(self)
				self:visible(false)
			end,
		}
	}
end

-- -----------------------------------------------------------------------
local IsPlayingECS = function()
	local song = GAMESTATE:GetCurrentSong()
	local group_name = song:GetGroupName()
	local song_name = song:GetMainTitle()
	if GetDivision() == "upper" then
		return group_name == "ECS10 - Upper"
	elseif GetDivision() == "mid" then
		return group_name == "ECS10 - Mid"
	else
		return group_name == "ECS10 - Lower"
	end
end

local ChickenKnifeIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Chicken Knife" then
			return true
		end
	end
	return false
end

if ECS.Mode == "ECS" and ChickenKnifeIsActive() and IsPlayingECS() then
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self) end,
		OnCommand=function(self)
			self.backout_time = -1
			if math.random(1, 100) <= 50 then
				local song_length = GAMESTATE:GetCurrentSong():MusicLengthSeconds()
				self.backout_time = math.random(0, song_length)
				self:queuecommand("Loop")
			end
		end,
		LoopCommand=function(self)
			if self.backout_time ~= -1 then
				-- We don't need to divide by rate since we always want the backout time to happen in the predetermined spot.
				local cur_second = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
				if cur_second >= self.backout_time then
					self:queuecommand("Backout")
				else
					self:sleep(0.1):queuecommand("Loop")
				end
			end
		end,
		BackoutCommand=function(self)
			-- There shouldn't be multiple players enabled but anyways we can fail them both.
			for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
				pss:FailPlayer()
			end

			SCREENMAN:GetTopScreen():SetNextScreenName("ScreenEvaluationStage"):StartTransitioningScreen("SM_DoNextScreen")
		end
	}

end


return af
