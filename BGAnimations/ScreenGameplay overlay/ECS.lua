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

	if PlayerIsUpper() == nil then return end

	if PlayerIsUpper() then
		if ECS.Mode == "ECS" and group_name ~= "ECS9 - Upper" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS9 - Upper Marathon" then return end
	else
		if group_name ~= "ECS9 - Lower" then return end
	end

	-- ----------------------------------------------------------

	local path = "Themes/ECS9/ECSData/"..day..month_string..year.."-"..seconds.."-"..profile_name.."-".."SCORE"..".txt"

	local data = ""
	data = data..GetECSID()
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

	if PlayerIsUpper() == nil then return end

	if PlayerIsUpper() then
		if ECS.Mode == "ECS" and group_name ~= "ECS9 - Upper" then return end
		if ECS.Mode == "Marathon" and group_name ~= "ECS9 - Upper Marathon" then return end
	else
		if group_name ~= "ECS9 - Lower" then return end
	end

	local path = "Themes/ECS9/ECSData/"..day..month_string..year.."-"..seconds.."-"..profile_name.."-".."RELIC"..".txt"
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
		active_relic.action()
	end
end

-- ----------------------------------------------------------
-- actually hook into the screen so that we can do thing at screen's OnCommand and OffCommand

return Def.Actor{
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