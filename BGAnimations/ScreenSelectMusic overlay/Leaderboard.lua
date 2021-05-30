local NumEntries = 13
local RowHeight = 18

local SetEntryText = function(rank, name, score, date, actor)
	if actor == nil then return end

	actor:GetChild("Rank"):settext(rank)
	actor:GetChild("Name"):settext(name)
	actor:GetChild("Score"):settext(score)
	actor:GetChild("Date"):settext(date)
end

local SetLeaderboardForPlayer = function(player_num, leaderboard, leaderboardData, isRanked)
	if leaderboard == nil or leaderboardData == nil then return end
	local playerStr = "player"..player_num
	local entryNum = 1
	local rivalNum = 1

	if leaderboardData then
		if leaderboardData["Name"] then
			leaderboard:GetChild("Header"):settext(leaderboardData["Name"])
		end

		if leaderboardData["Data"] then
			for gsEntry in ivalues(leaderboardData["Data"]) do
				local entry = leaderboard:GetChild("LeaderboardEntry"..entryNum)
				SetEntryText(
					gsEntry["rank"]..".",
					gsEntry["name"],
					string.format("%.2f%%", gsEntry["score"]/100),
					ParseGroovestatsDate(gsEntry["date"]),
					entry
				)
				if gsEntry["isRival"] then
					if gsEntry["isFail"] then
						entry:GetChild("Rank"):diffuse(Color.Black)
						entry:GetChild("Name"):diffuse(Color.Black)
						entry:GetChild("Score"):diffuse(Color.Red)
						entry:GetChild("Date"):diffuse(Color.Black)
					else
						entry:diffuse(Color.Black)
					end
					leaderboard:GetChild("Rival"..rivalNum):y(entry:GetY()):visible(true)
					rivalNum = rivalNum + 1
				elseif gsEntry["isSelf"] then
					if gsEntry["isFail"] then
						entry:GetChild("Rank"):diffuse(Color.Black)
						entry:GetChild("Name"):diffuse(Color.Black)
						entry:GetChild("Score"):diffuse(Color.Red)
						entry:GetChild("Date"):diffuse(Color.Black)
					else
						entry:diffuse(Color.Black)
					end
					leaderboard:GetChild("Self"):y(entry:GetY()):visible(true)
				else
					entry:diffuse(Color.White)
				end

				if gsEntry["isFail"] then
					entry:GetChild("Score"):diffuse(Color.Red)
				end
				entryNum = entryNum + 1
			end
		end
	end

	-- Empty out any remaining entries.
	-- This also handles the error case. If success is false, then the above if block will not run.
	-- and we will set the first entry to "Failed to Load 😞".
	for i=entryNum, NumEntries do
		local entry = leaderboard:GetChild("LeaderboardEntry"..i)
		-- We didn't get any scores if i is still == 1.
		if i == 1 then
			if isRanked then
				SetEntryText("", "No Scores", "", "", entry)
			else
				SetEntryText("", "Chart Not Ranked", "", "", entry)
			end
		else
			-- Empty out the remaining rows.
			SetEntryText("", "", "", "", entry)
		end
	end
end

local LeaderboardRequestProcessor = function(res, master)
	if master == nil then return end
	local data = res["status"] == "success" and res["data"] or nil

	local playerNum = PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()]+1
	local playerStr = "player"..playerNum
	local pn = "P"..playerNum
	local leaderboard = master:GetChild(pn.."Leaderboard")
	local leaderboardList = master[pn]["Leaderboards"]
	if res["status"] == "success" then
		if data[playerStr] then
			master[pn].isRanked = data[playerStr]["isRanked"]

			-- First add the main GrooveStats leaderboard.
			if data[playerStr]["gsLeaderboard"] then
				leaderboardList[#leaderboardList + 1] = {
					Name="GrooveStats",
					Data=DeepCopy(data[playerStr]["gsLeaderboard"])
				}
				master[pn]["LeaderboardIndex"] = 1
			end

			-- Then any additional leaderboards.
			if data[playerStr]["rpg"] and data[playerStr]["rpg"]["rpgLeaderboard"] then
				leaderboardList[#leaderboardList + 1] = {
					Name=data[playerStr]["rpg"]["name"],
					Data=DeepCopy(data[playerStr]["rpg"]["rpgLeaderboard"])
				}
				master[pn]["LeaderboardIndex"] = 1
			end

			if #leaderboardList > 1 then
				leaderboard:GetChild("PaneIcons"):visible(true)
			else
				leaderboard:GetChild("PaneIcons"):visible(false)
			end
		end

		-- We assume that at least one leaderboard has been added.
		-- If leaderboardData is nil as a result, the SetLeaderboardForPlayer
		-- function will handle it.
		local leaderboardData = leaderboardList[1]
		SetLeaderboardForPlayer(playerNum, leaderboard, leaderboardData, master[pn].isRanked)
	elseif res["status"] == "fail" then
		for i=1, NumEntries do
			local entry = leaderboard:GetChild("LeaderboardEntry"..i)
			if i == 1 then
				SetEntryText("", "Failed to Load 😞", "", "", entry)
			else
				-- Empty out the remaining rows.
				SetEntryText("", "", "", "", entry)
			end
		end
	elseif res["status"] == "disabled" then
		for i=1, NumEntries do
			local entry = leaderboard:GetChild("LeaderboardEntry"..i)
			if i == 1 then
				SetEntryText("", "Leaderboard Disabled", "", "", entry)
			else
				-- Empty out the remaining rows.
				SetEntryText("", "", "", "", entry)
			end
		end
	end
end

local af = Def.ActorFrame{
	Name="LeaderboardMaster",
	InitCommand=function(self) self:visible(false) end,
	ShowLeaderboardCommand=function(self)
		self:visible(true)
		local pn = "P"..(PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()]+1)
		self[pn] = {}
		self[pn].isRanked = false
		self[pn].Leaderboards = {}
		self[pn].LeaderboardIndex = 0
		MESSAGEMAN:Broadcast("ResetEntry")
		-- Only make the request when this actor gets actually displayed through the sort menu.
		self:queuecommand("SendLeaderboardRequest")
	end,
	HideLeaderboardCommand=function(self) self:visible(false) end,
	LeaderboardInputEventMessageCommand=function(self, event)
		local pn = ToEnumShortString(event.PlayerNumber)
		if #self[pn].Leaderboards == 0 then return end

		if event.type == "InputEventType_FirstPress" then
			-- We don't use modulus because #Leaderboards might be zero.
			if event.GameButton == "MenuLeft" then
				self[pn].LeaderboardIndex = self[pn].LeaderboardIndex - 1

				if self[pn].LeaderboardIndex == 0 then
					-- Wrap around if we decremented from 1 to 0.
					self[pn].LeaderboardIndex = #self[pn].Leaderboards
				end
			elseif event.GameButton == "MenuRight" then
				self[pn].LeaderboardIndex = self[pn].LeaderboardIndex + 1

				if self[pn].LeaderboardIndex > #self[pn].Leaderboards then
					-- Wrap around if we incremented past #Leaderboards
					self[pn].LeaderboardIndex = 1
				end
			end

			if event.GameButton == "MenuLeft" or event.GameButton == "MenuRight" then
				local leaderboard = self:GetChild(pn.."Leaderboard")
				local leaderboardList = self[pn]["Leaderboards"]
				local leaderboardData = leaderboardList[self[pn].LeaderboardIndex]
				SetLeaderboardForPlayer("P1" == pn and 1 or 2, leaderboard, leaderboardData, self[pn].isRanked)
			end
		end
	end,

	Def.Quad{ InitCommand=function(self) self:FullScreen():diffuse(0,0,0,0.875) end },
	LoadFont("Common Normal")..{
		Text=THEME:GetString("Common", "PopupDismissText"),
		InitCommand=function(self) self:xy(_screen.cx, _screen.h-80):zoom(0.7) end
	},
	RequestResponseActor("Leaderboard", 10)..{
		SendLeaderboardRequestCommand=function(self)
			local sendRequest = false
			local data = {
				action="groovestats/player-leaderboards",
				maxLeaderboardResults=NumEntries,
			}

			playerNumber = PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()]+1
			local pn = "P"..playerNumber
			if SL[pn].ApiKey ~= "" and SL[pn].Streams.Hash ~= "" then
				data["player"..playerNumber] = {
					chartHash=SL[pn].Streams.Hash,
					apiKey=SL[pn].ApiKey
				}
				sendRequest = true
			end

			-- Only send the request if it's applicable.
			-- Technically this should always be true since otherwise we wouldn't even get to this screen.
			if sendRequest then
				MESSAGEMAN:Broadcast("Leaderboard", {
					data=data,
					args=SCREENMAN:GetTopScreen():GetChild("Overlay"):GetChild("LeaderboardMaster"),
					callback=LeaderboardRequestProcessor
				})
			end
		end
	}
}

local paneWidth = 230
local paneHeight = 280
local borderWidth = 2

for player in ivalues( PlayerNumber ) do
	af[#af+1] = Def.ActorFrame{
		Name=ToEnumShortString(player).."Leaderboard",
		InitCommand=function(self)
			self:visible(GAMESTATE:IsSideJoined(player))
			self:xy(_screen.cx, _screen.cy - 15)
		end,
		PlayerJoinedMessageCommand=function(self)
			self:visible(GAMESTATE:IsSideJoined(player))
		end,

		-- White border
		Def.Quad {
			InitCommand=function(self)
				self:diffuse(Color.White):zoomto(paneWidth + borderWidth, paneHeight + borderWidth)
			end
		},

		-- Main black body
		Def.Quad {
			InitCommand=function(self)
				self:diffuse(Color.Black):zoomto(paneWidth, paneHeight)
			end
		},

		-- Header border
		Def.Quad {
			InitCommand=function(self)
				self:diffuse(Color.White):zoomto(paneWidth + borderWidth, RowHeight*2 + borderWidth):y(-paneHeight/2 + RowHeight/2)
			end
		},

		-- Blue Header
		Def.Quad {
			InitCommand=function(self)
				self:diffuse(Color.Blue):zoomto(paneWidth, RowHeight*2):y(-paneHeight/2 + RowHeight/2)
			end
		},

		-- Header Text
		LoadFont("Wendy/_wendy small").. {
			Name="Header",
			Text="GrooveStats",
			InitCommand=function(self)
				self:zoom(0.35)
				self:y(-paneHeight/2 + 9)
			end
		},

		-- Highlight backgrounds for the leaderboard. Initially hidden.
		Def.Quad {
			Name="Rival1",
			InitCommand=function(self)
				self:diffuse(color("#BD94FF")):zoomto(paneWidth, RowHeight):visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end
		},

		Def.Quad {
			Name="Rival2",
			InitCommand=function(self)
				self:diffuse(color("#BD94FF")):zoomto(paneWidth, RowHeight):visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end
		},

		Def.Quad {
			Name="Rival3",
			InitCommand=function(self)
				self:diffuse(color("#BD94FF")):zoomto(paneWidth, RowHeight):visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end
		},

		Def.Quad {
			Name="Self",
			InitCommand=function(self)
				self:diffuse(Color.Green):zoomto(paneWidth, RowHeight):visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end
		},

		-- Marker for the additional panes. Hidden by default.
		Def.ActorFrame{
			Name="PaneIcons",
			InitCommand=function(self)
				self:y(paneHeight/2 + 15)
				self:visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end,

			LoadFont("Miso/_miso").. {
				Name="LeftIcon",
				Text="&MENULEFT;",
				InitCommand=function(self)
					self:x(-paneWidth/2 + 40):zoom(0.7)
				end,
				OnCommand=function(self) self:queuecommand("Bounce") end,
				BounceCommand=function(self)
					self:decelerate(0.5):addx(3):accelerate(0.5):addx(-3)
					self:queuecommand("Bounce")
				end,
			},

			LoadFont("Miso/_miso").. {
				Name="Text",
				Text="More Leaderboards",
				InitCommand=function(self)
					self:diffuse(Color.White):zoom(0.7)
				end,
			},

			LoadFont("Miso/_miso").. {
				Name="RightIcon",
				Text="&MENURiGHT;",
				InitCommand=function(self)
					self:x(paneWidth/2 - 40):zoom(0.7)
				end,
				OnCommand=function(self) self:queuecommand("Bounce") end,
				BounceCommand=function(self)
					self:decelerate(0.5):addx(-3):accelerate(0.5):addx(3)
					self:queuecommand("Bounce")
				end,
			},
		}
	}

	local af2 = af[#af]
	local textZoom = 0.6
	for i=1, NumEntries do
		--- Each entry has a Rank, Name, and Score subactor.
		af2[#af2+1] = Def.ActorFrame{
			Name="LeaderboardEntry"..i,
			InitCommand=function(self)
				self:y(RowHeight*(i-6)-RowHeight/2)
			end,

			LoadFont("Miso/_miso").. {
				Name="Rank",
				Text="",
				InitCommand=function(self)
					self:horizalign(right)
					self:maxwidth(30)
					self:x(-paneWidth/2 + 20 + borderWidth)
					self:diffuse(Color.White)
					self:zoom(textZoom)
				end,
				ResetEntryMessageCommand=function(self)
					self:settext("")
					self:diffuse(Color.White)
				end
			},

			LoadFont("Miso/_miso").. {
				Name="Name",
				Text=(i==1 and "Loading" or ""),
				InitCommand=function(self)
					self:horizalign(center)
					self:maxwidth(130)
					self:x(-paneWidth/2 + 80)
					self:diffuse(Color.White)
					self:zoom(textZoom)
				end,
				ResetEntryMessageCommand=function(self)
					self:settext(i==1 and "Loading" or "")
					self:diffuse(Color.White)
				end
			},

			LoadFont("Miso/_miso").. {
				Name="Score",
				Text="",
				InitCommand=function(self)
					self:horizalign(right)
					self:x(paneWidth/2-borderWidth-70)
					self:diffuse(Color.White)
					self:zoom(textZoom)
				end,
				ResetEntryMessageCommand=function(self)
					self:settext("")
					self:diffuse(Color.White)
				end
			},
			LoadFont("Miso/_miso").. {
				Name="Date",
				Text="",
				InitCommand=function(self)
					self:horizalign(right)
					self:x(paneWidth/2 - borderWidth - 10)
					self:diffuse(Color.White)
					self:zoom(textZoom)
				end,
				ResetEntryMessageCommand=function(self)
					self:settext("")
					self:diffuse(Color.White)
				end
			},
		}
	end
end

return af
