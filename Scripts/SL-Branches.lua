------------------------------------------------------------
-- Helper Functions for Branches
------------------------------------------------------------

local EnoughCreditsToContinue = function()
	local credits = GetCredits().Credits

	local premium = ToEnumShortString(GAMESTATE:GetPremium())
	local styletype = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())

	if premium == "2PlayersFor1Credit" then
		return (credits > 0) -- any value greater than 0 is good enough

	elseif premium == "DoubleFor1Credit" then
		-- versus, routine, couple
		if styletype == "TwoPlayersTwoSides" or styletype == "TwoPlayersSharedSides" then
			return (credits > 1)

		-- single, double, solo
		else
			return (credits > 0)
		end

	elseif premium == "Off" then
		-- single, solo
		if styletype == "OnePlayerOneSide" then
			return (credits > 0)

		-- versus, double, routine, couple
		else
			return (credits > 1)
		end
	end

	return false
end

------------------------------------------------------------

if not Branch then Branch = {} end

Branch.AfterScreenRankingDouble = function()
	return PREFSMAN:GetPreference("MemoryCards") and "ScreenMemoryCard" or "ScreenRainbow"
end

SelectMusicOrCourse = function()
	if GAMESTATE:IsCourseMode() then
		return "ScreenSelectCourse"
	else
		return "ScreenSelectMusic"
	end
end

Branch.AllowScreenSelectProfile = function()
	if ThemePrefs.Get("AllowScreenSelectProfile") then
		return "ScreenSelectProfile"
	else
		return Branch.AllowScreenSelectColor()
	end
end

Branch.AllowScreenSelectColor = function()
	if ThemePrefs.Get("AllowScreenSelectColor") and not ThemePrefs.Get("RainbowMode") then
		return "ScreenSelectColor"
	else
		return Branch.AfterScreenSelectColor()
	end
end

Branch.AfterScreenSelectColor = function()
	-- Single is the only supported style in Vertical
	local preferred_style = "single"
	-- if AutoStyle was "single" but both players are already joined
	-- (for whatever reason), we're in a bit of a pickle, as there is
	-- no way to read the player's mind and know which side they really
	-- want to play on. Unjoin PLAYER_2 for lack of a better solution.
	if GAMESTATE:GetNumSidesJoined() == 2 then
		GAMESTATE:UnjoinPlayer(PLAYER_2)
	end

	-- FIXME: there's probably a more sensible place to set the current style for
	-- the engine, but I guess we're doing it here, in SL-Branches.lua, for now.
	GAMESTATE:SetCurrentStyle( preferred_style )
	return "ScreenSelectPlayMode"
end

Branch.ScreenLimitRelics = function()
	local mpn = GAMESTATE:GetMasterPlayerNumber()
	local profile_name = PROFILEMAN:GetPlayerName(mpn)
	local total_ro_relics = 0
	if profile_name and ECS.Players[profile_name] and ECS.Players[profile_name].relics then
		-- First count how many selectable relics there are for RO.
		for player_relic in ivalues(ECS.Players[profile_name].relics) do
			for master_relic in ivalues(ECS.Relics) do
				if master_relic.name == player_relic.name then
					if not master_relic.is_marathon and (not master_relic.is_consumable or player_relic.quantity > 0) then
						total_ro_relics = total_ro_relics + 1
					end
				end
			end
		end
		if total_ro_relics > 10 then
			return "ScreenLimitRelics"
		else
			return "ScreenProfileLoad"
		end
	end
	-- No valid profile loaded to participate in ECS. Go back to the title menu.
	return Branch.TitleMenu()
end

Branch.AfterEvaluationStage = function()
	return "ScreenProfileSave"
end

Branch.AfterSelectPlayMode = function()
	return SelectMusicOrCourse()
end


Branch.AfterGameplay = function()
	-- We need to check if the offset changed during gameplay after each song and if it did
	-- update the default value. (See Scripts/SL-Helpers.lua)
	UpdateDefaultGlobalOffset()
	if THEME:GetMetric("ScreenHeartEntry", "HeartEntryEnabled") then
		local go_to_heart= false
		for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
			local profile= PROFILEMAN:GetProfile(pn)
			if profile and profile:GetIgnoreStepCountCalories() then
				go_to_heart= true
			end
		end

		if go_to_heart then
			return "ScreenHeartEntry"
		end
	end

	return Branch.AfterHeartEntry()
end

Branch.AfterHeartEntry = function()
	local pm = ToEnumShortString(GAMESTATE:GetPlayMode())
	if( pm == "Regular" ) then return "ScreenEvaluationStage" end
	if( pm == "Nonstop" ) then return "ScreenEvaluationNonstop" end
end

Branch.AfterSelectMusic = function()
	if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen().GetGoToOptions ~= nil and SCREENMAN:GetTopScreen():GetGoToOptions() then
		return "ScreenPlayerOptions"
	else
		-- routine mode specifically uses ScreenGameplayShared
		local style = GAMESTATE:GetCurrentStyle():GetName()
		if style == "routine" then
			return "ScreenGameplayShared"
		end

		-- while everything else (single, versus, double, etc.) uses ScreenGameplay
		if ECS.Mode == "ECS" or ECS.Mode == "Marathon" then
			local song = GAMESTATE:GetCurrentSong()
			if song then
				local group_name = song:GetGroupName()

				-- Using an unknown profile, just go straight to ScreenGameplay.
				if GetDivision() == nil then
					return "ScreenGameplay"
				end

				if (
					(GetDivision() == "upper" and
						((ECS.Mode == "ECS" and group_name == "ECS10 - Upper") or
						(ECS.Mode == "Marathon" and group_name == "ECS10 - Upper Marathon"))) or
					(GetDivision() == "mid" and
						((ECS.Mode == "ECS" and group_name == "ECS10 - Mid") or
						(ECS.Mode == "Marathon" and group_name == "ECS10 - Mid Marathon"))) or
					(GetDivision() == "lower" and
						((ECS.Mode == "ECS" and group_name == "ECS10 - Lower") or
						(ECS.Mode == "Marathon" and group_name == "ECS10 - Lower Marathon")))
					) then
					-- Only go to ScreenEquipRelics if it's a valid song for the player.
					return "ScreenEquipRelics"
				else
					-- Otherwise go directly to gameplay.
					return "ScreenGameplay"
				end
			else
				-- If for some reason we can't determine the song, then try to equip relics just in case.
				return "ScreenEquipRelics"
			end
		else
			-- No need to select relics in warmup or freeplay.
			return "ScreenGameplay"
		end
	end
end

Branch.SSMCancel = function()

	if GAMESTATE:GetCurrentStageIndex() > 0 then
		return Branch.AllowScreenEvalSummary()
	end

	return Branch.TitleMenu()
end

Branch.AllowScreenNameEntry = function()

	if ThemePrefs.Get("AllowScreenNameEntry") then
		return "ScreenNameEntryTraditional"

	else
		return "ScreenProfileSaveSummary"
	end
end

Branch.AllowScreenEvalSummary = function()
	if ThemePrefs.Get("AllowScreenEvalSummary") then
		return "ScreenEvaluationSummary"
	else
		return Branch.AllowScreenNameEntry()
	end
end

Branch.AfterProfileSave = function()

	if PREFSMAN:GetPreference("EventMode") then
		if ECS.Mode == "Marathon" then
			for active_relic in ivalues(ECS.Player.Relics) do
				if active_relic.name == "Arvin's Gambit" then
					return SelectMusicOrCourse()
				end
			end
			return Branch.AllowScreenEvalSummary()
		end
		return SelectMusicOrCourse()

	elseif GAMESTATE:IsCourseMode() then
		return Branch.AllowScreenNameEntry()

	else

		-- deduct the number of stages that stock StepMania says the song is
		local song = GAMESTATE:GetCurrentSong()
		local SMSongCost = (song:IsMarathon() and 3) or (song:IsLong() and 2) or 1
		SL.Global.Stages.Remaining = SL.Global.Stages.Remaining - SMSongCost

		-- check if stages should be "added back" to SL.Global.Stages.Remaining because of an active rate mod
		if SL.Global.ActiveModifiers.MusicRate ~= 1 then
			local ActualSongCost = 1
			local StagesToAddBack = 0

			local Duration = song:GetLastSecond()
			local DurationWithRate = Duration / SL.Global.ActiveModifiers.MusicRate

			local LongCutoff = PREFSMAN:GetPreference("LongVerSongSeconds")
			local MarathonCutoff = PREFSMAN:GetPreference("MarathonVerSongSeconds")

			local IsMarathon = (DurationWithRate/MarathonCutoff > 1)
			local IsLong     = (DurationWithRate/LongCutoff > 1)

			ActualSongCost = (IsMarathon and 3) or (IsLong and 2) or 1
			StagesToAddBack = SMSongCost - ActualSongCost

			SL.Global.Stages.Remaining = SL.Global.Stages.Remaining + StagesToAddBack
		end

		-- Now, check if StepMania and SL disagree on the stage count. If necessary, add stages back.
		-- This might be necessary because:
		-- a) a Lua chart reloaded ScreenGameplay, or
		-- b) everyone failed, and StepmMania zeroed out the stage numbers
		if GAMESTATE:GetNumStagesLeft(GAMESTATE:GetMasterPlayerNumber()) < SL.Global.Stages.Remaining then
			local StagesToAddBack = math.abs(SL.Global.Stages.Remaining - GAMESTATE:GetNumStagesLeft(GAMESTATE:GetMasterPlayerNumber()))
			local Players = GAMESTATE:GetHumanPlayers()
			for pn in ivalues(Players) do
				for i=1, StagesToAddBack do
					GAMESTATE:AddStageToPlayer(pn)
				end
			end
		end

		-- now, check if this set is over.
		local setOver
		-- This is only true if the set would have been over naturally,
		setOver = (SL.Global.Stages.Remaining <= 0)
		-- OR if we allow players to fail a set early and the players actually failed.
		if ThemePrefs.Get("AllowFailingOutOfSet") == true then
			setOver = setOver or STATSMAN:GetCurStageStats():AllFailed()
		end
		-- this style is more verbose but avoids obnoxious if statements

		if setOver then
			-- continues are only allowed in Pay mode
			if PREFSMAN:GetPreference("CoinMode") == "CoinMode_Pay" then
				if SL.Global.ContinuesRemaining > 0 and EnoughCreditsToContinue() then
					return "ScreenPlayAgain"
				end
			end

			return Branch.AllowScreenEvalSummary()
		else
			return SelectMusicOrCourse()
		end
	end

	-- just in case?
	return SelectMusicOrCourse()
end

Branch.AfterProfileSaveSummary = function()
	if ThemePrefs.Get("AllowScreenGameOver") then
		return "ScreenGameOver"
	else
		return Branch.AfterInit()
	end
end
