local player = ...
local pn = ToEnumShortString(player)
local p = PlayerNumber:Reverse()[player]

local rv
local zoom_factor = 0.5
local quadX = -25
local quadY = _screen.h/2 - 156.5
local labelSpacing = 5

local labelX_col1 = quadX - 25
local dataX_col1  = labelX_col1 - labelSpacing

local labelX_col2 = labelX_col1 + 50
local dataX_col2  = labelX_col2 - labelSpacing

local highscorenameX = labelX_col1
local highscoreX = highscorenameX - labelSpacing

local rowOneY = quadY - 16
local rowHeight = 10

local quadWidth = 125
local quadHeight = 49

local PaneItems = {}

PaneItems[THEME:GetString("RadarCategory","Taps")] = {
	-- "rc" is RadarCategory
	rc = 'RadarCategory_TapsAndHolds',
	label = {
		x = labelX_col1,
		y = rowOneY
	},
	data = {
		x = dataX_col1,
		y = rowOneY
	}
}

PaneItems[THEME:GetString("RadarCategory","Mines")] = {
	rc = 'RadarCategory_Mines',
	label = {
		x = labelX_col2,
		y = rowOneY
	},
	data = {
		x = dataX_col2,
		y = rowOneY
	}
}

PaneItems[THEME:GetString("RadarCategory","Jumps")] = {
	rc = 'RadarCategory_Jumps',
	label = {
		x = labelX_col1,
		y = rowOneY + rowHeight
	},
	data = {
		x = dataX_col1,
		y = rowOneY + rowHeight
	}
}

PaneItems[THEME:GetString("RadarCategory","Hands")] = {
	rc = 'RadarCategory_Hands',
	label = {
		x = labelX_col2,
		y = rowOneY + rowHeight
	},
	data = {
		x = dataX_col2,
		y = rowOneY + rowHeight
	}
}

PaneItems[THEME:GetString("RadarCategory","Holds")] = {
	rc = 'RadarCategory_Holds',
	label = {
		x = labelX_col1,
		y = rowOneY + rowHeight * 2
	},
	data = {
		x = dataX_col1,
		y = rowOneY + rowHeight * 2
	}
}

PaneItems[THEME:GetString("RadarCategory","Rolls")] = {
	rc = 'RadarCategory_Rolls',
	label = {
		x = labelX_col2,
		y = rowOneY + rowHeight * 2
	},
	data = {
		x = dataX_col2,
		y = rowOneY + rowHeight * 2
	}
}


local GetNameAndScore = function(profile)
	local song = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()
	local steps = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player)) or GAMESTATE:GetCurrentSteps(player)
	local score = ""
	local name = ""

	if profile and song and steps then
		local scorelist = profile:GetHighScoreList(song,steps)
		local scores = scorelist:GetHighScores()
		local topscore = scores[1]

		if topscore then
			score = string.format("%.2f", topscore:GetPercentDP()*100.0)
			if SL[pn].ActiveModifiers.DoNotJudgeMe then score = "??.??" end
			name = topscore:GetName()
		else
			score = string.format("%.2f", 0)
			name = "????"
		end
	end

	return score, name
end

local SetNameAndScore = function(name, score, nameActor, scoreActor)
	if not scoreActor or not nameActor then return end
	scoreActor:settext(score)
	nameActor:settext(name)
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

local GetScoresRequestProcessor = function(res, master)
	if master == nil then return end

	playerNumber = GAMESTATE:GetMasterPlayerNumber()
	local paneDisplay = master

	local machineScore = paneDisplay:GetChild("MachineHighScore")
	local machineName = paneDisplay:GetChild("MachineHighScoreName")

	local playerScore = paneDisplay:GetChild("PlayerHighScore")
	local playerName = paneDisplay:GetChild("PlayerHighScoreName")

	local playerStr = "player"..playerNumber
	local rivalNum = 1
	local worldRecordSet = false
	local personalRecordSet = false
	local data = res["success"] and res["data"] or false

	-- First check to see if the leaderboard even exists.
	if data and data[playerStr] and data[playerStr]["gsLeaderboard"] then
		-- And then also ensure that the chart hash matches the currently parsed one.
		-- It's better to just not display anything than display the wrong scores.
		if SL["P"..playerNumber].Streams.Hash == data[playerStr]["chartHash"] then
			for gsEntry in ivalues(data[playerStr]["gsLeaderboard"]) do
				if gsEntry["rank"] == 1 then
					SetNameAndScore(
						GetMachineTag(gsEntry),
						string.format("%.2f%%", gsEntry["score"]/100),
						machineName,
						machineScore
					)
					worldRecordSet = true
				end

				if gsEntry["isSelf"] then
					SetNameAndScore(
						GetMachineTag(gsEntry),
						string.format("%.2f%%", gsEntry["score"]/100),
						playerName,
						playerScore
					)
					personalRecordSet = true
				end

				if gsEntry["isRival"] then
					local rivalScore = paneDisplay:GetChild("Rival"..rivalNum.."Score")
					local rivalName = paneDisplay:GetChild("Rival"..rivalNum.."Name")
					SetNameAndScore(
						GetMachineTag(gsEntry),
						string.format("%.2f%%", gsEntry["score"]/100),
						rivalName,
						rivalScore
					)
					rivalNum = rivalNum + 1
				end
			end
		end
	end

	-- Fall back to to using the machine profile's record if we never set the world record.
	-- This chart may not have been ranked, or there is no WR, or the request failed.
	if not worldRecordSet then
		machineName:queuecommand("SetDefault")
		machineScore:queuecommand("SetDefault")
	end

	-- Fall back to to using the personal profile's record if we never set the record.
	-- This chart may not have been ranked, or we don't have a score for it, or the request failed.
	if not personalRecordSet then
		playerName:queuecommand("SetDefault")
		playerScore:queuecommand("SetDefault")
	end

	-- Iterate over any remaining rivals and hide them.
	-- This also handles the failure case as rivalNum will never have been incremented.
	for j=rivalNum,3 do
		local rivalScore = paneDisplay:GetChild("Rival"..j.."Score")
		local rivalName = paneDisplay:GetChild("Rival"..j.."Name")
		rivalScore:settext("??.??%")
		rivalName:settext("----")
	end
end

local af = Def.ActorFrame{
	Name="PaneDisplay",

	InitCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(player))
	  self:x(_screen.w * 0.25 + 20)
		self:y(_screen.cy + 5)
	end,

	-- These playcommand("Set") need to apply to the ENTIRE panedisplay
	-- (all its children) so declare each here
	OnCommand=function(self) self:queuecommand("Set") end,
	CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end,
	CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end,
	["CurrentSteps"..pn.."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end,
	SLGameModeChangedMessageCommand=function(self) self:queuecommand("Set") end,

	SetCommand=function(self)
		local machine_score, machine_name = GetNameAndScore( PROFILEMAN:GetMachineProfile() )

		self:GetChild("MachineHighScore"):settext(machine_score)
		self:GetChild("MachineHighScoreName"):settext(machine_name):diffuse({0,0,0,1})

		DiffuseEmojis(self, machine_name)

		if PROFILEMAN:IsPersistentProfile(player) then
			local player_score, player_name = GetNameAndScore( PROFILEMAN:GetProfile(player) )

			self:GetChild("PlayerHighScore"):settext(player_score)
			self:GetChild("PlayerHighScoreName"):settext(player_name):diffuse({0,0,0,1})

			DiffuseEmojis(self, player_name)
		end
	end
}

-- Only add the GrooveStats request actor if it's relevant.
if IsServiceAllowed(SL.GrooveStats.GetScores) then
	af[#af+1] = RequestResponseActor("GetScores", 10)..{
		OnCommand=function(self)
			self.IsParsing = false
		end,
		-- Broadcasted from DensityGraph.lua
		-- TODO(Vertical crew): it's not broadcast from DensityGraph.
		-- Parsing/hashing system has changed significantly, and needs to be updated.
		ChartParsingMessageCommand=function(self)	self.IsParsing = true end,
		ChartParsedMessageCommand=function(self)
			self.IsParsing = false
			self:queuecommand("ChartParsed")
		end,
		ChartParsedCommand=function(self)
			-- Make sure we're still not parsing the chart. This should not happen.
			if self.IsParsing then return end

			-- This makes sure that the Hash in the ChartInfo cache exists.
			local sendRequest = false
			local data = {
				action="groovestats/player-scores",
			}

			local pn = "P"..GAMESTATE:GetMasterPlayerNumber()
			if SL[pn].ApiKey ~= "" and SL[pn].Streams.Hash ~= "" then
				data["player"..i] = {
					chartHash=SL[pn].Streams.Hash,
					apiKey=SL[pn].ApiKey
				}
				sendRequest = true
			end

			-- Only send the request if it's applicable.
			if sendRequest then
				MESSAGEMAN:Broadcast("GetScores", {
					data=data,
					args=SCREENMAN:GetTopScreen():GetChild("Overlay"):GetChild("PaneDisplay"),
					callback=GetScoresRequestProcessor
				})
			end
		end
	}
end

-- colored background for chart statistics
af[#af+1] = Def.Quad{
	Name="BackgroundQuad",
	InitCommand=function(self) self:zoomto(quadWidth, quadHeight):xy(quadX,quadY) end,
	SetCommand=function(self, params)
		if GAMESTATE:IsHumanPlayer(player) then
			local StepsOrTrail = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)

			if StepsOrTrail then
				local difficulty = StepsOrTrail:GetDifficulty()
				self:diffuse( DifficultyColor(difficulty) )
			else
				self:diffuse( PlayerColor(player) )
			end
		end
	end
}

-- background for rival scores, if enabled
af[#af+1] = Def.Quad{
	Name="RivalBackgroundQuad",
	InitCommand=function(self, params)
		self:zoomto(quadWidth/2 + 20, quadHeight*3/4)
		self:xy(quadX+quadWidth/4-10 ,quadY+quadHeight*3/4+7)
		self:visible(IsServiceAllowed(SL.GrooveStats.GetScores))
		self:diffuse(color("#888888"))
		if ThemePrefs.Get("RainbowMode") then
			self:diffusealpha(0.75)
		end
	end
}

for key, item in pairs(PaneItems) do

	af[#af+1] = Def.ActorFrame{
		Name=key,
		-- label
		LoadFont("Common Normal")..{
			Text=key,
			InitCommand=function(self) self:zoom(zoom_factor):xy(item.label.x, item.label.y):diffuse(Color.Black):horizalign(left) end
		},
		--  numerical value
		LoadFont("Common Normal")..{
			InitCommand=function(self) self:zoom(zoom_factor):xy(item.data.x, item.data.y):diffuse(Color.Black):horizalign(right) end,
			OnCommand=function(self) self:playcommand("Set") end,
			SetCommand=function(self)
				local SongOrCourse = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()
				if not SongOrCourse then self:settext("?"); return end

				local steps = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player)) or GAMESTATE:GetCurrentSteps(player)
				if steps then
					rv = steps:GetRadarValues(player)
					local val = rv:GetValue( item.rc )

					-- the engine will return -1 as the value for autogenerated content; show a question mark instead if so
					self:settext( val >= 0 and val or "?" )
				else
					self:settext( "" )
				end
			end
		}
	}
end

-- Machine/World Record HighScore
af[#af+1] = LoadFont("Common Normal")..{
	Name="MachineHighScore",
	InitCommand=function(self) self:x(labelX_col1 - labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(right) end,
	SetCommand=function(self)
				-- We overload this actor to work both for GrooveStats and also offline.
				-- If we're connected, we let the ResponseProcessor set the text
				if IsServiceAllowed(SL.GrooveStats.GetScores) then
					self:settext("----")
				else
					self:queuecommand("SetDefault")
				end
			end,
		SetDefaultCommand=function(self)
			local SongOrCourse, StepsOrTrail = GetSongAndSteps(player)
			local machine_score, machine_name = GetNameAndScore(machine_profile, SongOrCourse, StepsOrTrail)
			self:settext(machine_name or ""):diffuse(Color.Black)
			DiffuseEmojis(self)
		end
}

-- Machine/World Record Machine Tag
af[#af+1] = LoadFont("Common Normal")..{
	Name="MachineHighScoreName",
	InitCommand=function(self) self:x(dataX_col1 + labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(left):maxwidth(80) end,
	SetCommand=function(self)
		-- We overload this actor to work both for GrooveStats and also offline.
		-- If we're connected, we let the ResponseProcessor set the text
		if IsServiceAllowed(SL.GrooveStats.GetScores) then
			self:settext("----")
		else
			self:queuecommand("SetDefault")
		end
	end,
	SetDefaultCommand=function(self)
		local SongOrCourse, StepsOrTrail = GetSongAndSteps(player)
		local machine_score, machine_name = GetNameAndScore(machine_profile, SongOrCourse, StepsOrTrail)
		self:settext(machine_name or ""):diffuse(Color.Black)
		DiffuseEmojis(self)
	end
}


-- Player Profile/GrooveStats HighScore
af[#af+1] = LoadFont("Common Normal")..{
	Name="PlayerHighScore",
	InitCommand=function(self) self:x(labelX_col2 - labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(right) end,
	SetCommand=function(self)
		-- We overload this actor to work both for GrooveStats and also offline.
		-- If we're connected, we let the ResponseProcessor set the text
		if IsServiceAllowed(SL.GrooveStats.GetScores) then
			self:settext("??.??%")
		else
			self:queuecommand("SetDefault")
		end
	end,
	SetDefaultCommand=function(self)
		local SongOrCourse, StepsOrTrail = GetSongAndSteps(player)
		local player_score, player_name
		if PROFILEMAN:IsPersistentProfile(player) then
			player_score, player_name = GetNameAndScore(PROFILEMAN:GetProfile(player), SongOrCourse, StepsOrTrail)
		end

		self:settext(player_score or "")
	end
}

-- Player Profile/GrooveStats Machine Tag
af[#af+1] = LoadFont("Common Normal")..{
	Name="PlayerHighScoreName",
	InitCommand=function(self) self:x(dataX_col2 + labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(left):maxwidth(80) end,
	SetCommand=function(self)
		-- We overload this actor to work both for GrooveStats and also offline.
		-- If we're connected, we let the ResponseProcessor set the text
		if IsServiceAllowed(SL.GrooveStats.GetScores) then
			self:settext("----")
		else
			self:queuecommand("SetDefault")
		end
	end,
	SetDefaultCommand=function(self)
		local SongOrCourse, StepsOrTrail = GetSongAndSteps(player)
		local player_score, player_name
		if PROFILEMAN:IsPersistentProfile(player) then
			player_score, player_name = GetNameAndScore(PROFILEMAN:GetProfile(player), SongOrCourse, StepsOrTrail)
		end
		self:settext(player_name or ""):diffuse(Color.Black)
		DiffuseEmojis(self)
	end
}

	-- Add actors for Rival score data. Hidden by default
	for i=1,3 do
		-- Rival Machine Tag
		af[#af+1] = LoadFont("Common Normal")..{
			Name="Rival"..i.."Name",
			InitCommand=function(self)
				self:zoom(zoom_factor):diffuse(Color.Black):maxwidth(30):horizalign(left)
				self:x(dataX_col2 + labelSpacing)
				self:y(rowOneY + rowHeight * (i+3) + 10)
				self:visible(IsServiceAllowed(SL.GrooveStats.GetScores))
			end,
			SetCommand=function(self)
				self:settext("----")
			end
		}

		-- Rival HighScore
		af[#af+1] = LoadFont("Common Normal")..{
			Name="Rival"..i.."Score",
			InitCommand=function(self)
				self:zoom(zoom_factor):diffuse(Color.Black):horizalign(right)
				self:x(labelX_col2 - labelSpacing)
				self:y(rowOneY + rowHeight * (i+3) + 10)
				self:visible(IsServiceAllowed(SL.GrooveStats.GetScores))
			end,
			SetCommand=function(self)
				self:settext("??.??%")
			end
		}
	end

return af
