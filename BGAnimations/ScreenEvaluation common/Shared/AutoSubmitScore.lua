if not IsServiceAllowed(SL.GrooveStats.AutoSubmit) then return end

local NumEntries = 10

local SetEntryText = function(rank, name, score, date, actor)
	if actor == nil then return end

	actor:GetChild("Rank"):settext(rank)
	actor:GetChild("Name"):settext(name)
	actor:GetChild("Score"):settext(score)
	actor:GetChild("Date"):settext(date)
end

local GetMachineTag = function(gsEntry)
	if not gsEntry then return end
	if gsEntry["machineTag"] then
		-- Make sure we only use up to 4 characters for space concerns.
		return gsEntry["machineTag"]:sub(1, 4):upper()
	end

	-- User doesn't have a machineTag set. We'll "make" one based off of
	-- their name.
	if gsEntry["name"] then
		-- 4 Characters is the "intended" length.
		return gsEntry["name"]:sub(1,4):upper()
	end

	return ""
end

local AutoSubmitRequestProcessor = function(res, overlay)
	local SubmitText = overlay:GetChild("AutoSubmitMaster"):GetChild("SubmitText")
	local panes = overlay:GetChild("Panes")
	local hasRpgData = false

	if res["status"] == "fail" then
		if SubmitText then SubmitText:queuecommand("SubmitFailed") end
		return
	elseif res["status"] == "disabled" then
		if SubmitText then SubmitText:queuecommand("ServiceDisabled") end
		return
	end

	if panes then
		playerNumber = PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()]+1
		local playerStr = "player"..playerNumber
		local entryNum = 1
		local rivalNum = 1
		local data = res["status"] == "success" and res["data"] or nil
		local QRPane = panes:GetChild("Pane6_SideP"..playerNumber):GetChild("QRPane")

		if data and data[playerStr] then
			-- And then also ensure that the chart hash matches the currently parsed one.
			-- It's better to just not display anything than display the wrong scores.
			if SL["P"..playerNumber].Streams.Hash == data[playerStr]["chartHash"] then
				if not data[playerStr]["isRanked"] then
					QRPane:GetChild("QRCode"):queuecommand("Hide")
					QRPane:GetChild("HelpText"):settext("This chart is not ranked on GrooveStats.")
					SubmitText:queuecommand("ChartNotRanked")
				elseif data[playerStr]["gsLeaderboard"] then
					QRPane:GetChild("QRCode"):queuecommand("Hide")
					QRPane:GetChild("HelpText"):settext("Score has been submitted")
					SubmitText:queuecommand("Submit")
				end

				-- Only display the RPG on the sides that are actually joined.
				if ToEnumShortString("PLAYER_P"..playerNumber) == "P"..playerNumber and data[playerStr]["rpg"] then
					local rpgAf = overlay:GetChild("AutoSubmitMaster"):GetChild("RpgOverlay"):GetChild("P"..playerNumber.."RpgAf")
					rpgAf:playcommand("Show", {data=data[playerStr]["rpg"]})
					hasRpgData = true
				end
			end
		end
	end

	if hasRpgData then
		overlay:GetChild("AutoSubmitMaster"):GetChild("RpgOverlay"):visible(true)
		overlay:queuecommand("DirectInputToRpgHandler")
	end
end

local af = Def.ActorFrame {
	Name="AutoSubmitMaster",
	RequestResponseActor("AutoSubmit", 10)..{
		OnCommand=function(self)
			local sendRequest = false
			local data = {
				action="groovestats/score-submit",
				maxLeaderboardResults=NumEntries,
			}

			local rate = SL.Global.ActiveModifiers.MusicRate * 100
			for i=1,2 do
				local player = "PlayerNumber_P"..i
				local pn = ToEnumShortString(player)

				local _, valid = ValidForGrooveStats(player)
				local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

				if GAMESTATE:IsHumanPlayer(player) and
						-- not stats:GetFailed() and
						valid and
						SL[pn].IsPadPlayer then
					local percentDP = stats:GetPercentDancePoints()
					local score = FormatPercentScore(percentDP)
					score = tonumber(score:gsub("%%", "") * 100)

					local profileName = ""
					if PROFILEMAN:IsPersistentProfile(player) and PROFILEMAN:GetProfile(player) then
						profileName = PROFILEMAN:GetProfile(player):GetDisplayName()
					end

					if SL[pn].ApiKey ~= "" and SL[pn].Streams.Hash ~= "" then
						data["player"..i] = {
							chartHash=SL[pn].Streams.Hash,
							apiKey=SL[pn].ApiKey,
							rate=rate,
							score=score,
							comment=CreateCommentString(player),
							profileName=profileName,
						}
						sendRequest = true
					end
				end
			end
			-- Only send the request if it's applicable.
			if sendRequest then
				-- Unjoined players won't have the text displayed.
				self:GetParent():GetChild("SubmitText"):settext("Submitting ...")
				MESSAGEMAN:Broadcast("AutoSubmit", {
					data=data,
					args=SCREENMAN:GetTopScreen():GetChild("Overlay"):GetChild("ScreenEval Common"),
					callback=AutoSubmitRequestProcessor
				})
			end
		end
	}
}

af[#af+1] = LoadActor("./RpgOverlay.lua")

af[#af+1] = LoadFont("Miso/_miso").. {
	Name="SubmitText",
	Text="",
	Condition=GAMESTATE:IsSideJoined(PLAYER_1),
	InitCommand=function(self)
		self:xy(_screen.cx, _screen.h - 10)
		self:diffuse(ThemePrefs.Get("RainbowMode") and Color.Black or Color.White)
		self:zoom(0.65)
		self:visible(GAMESTATE:IsSideJoined(PLAYER_1))
	end,
	ChartNotRankedCommand=function(self)
		self:settext("Chart Not Ranked")
	end,
	SubmitCommand=function(self)
		self:settext("Submitted!")
	end,
	SubmitFailedCommand=function(self)
		self:settext("Submit Failed 😞")
	end,
	ServiceDisabledCommand=function(self)
		self:settext("Submit Disabled")
	end,
}


return af
