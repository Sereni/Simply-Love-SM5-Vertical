if not IsServiceAllowed(SL.GrooveStats.Leaderboard) then return end

local NumEntries = 13
local RowHeight = 18

local SetEntryText = function(rank, name, score, actor)
	if actor == nil then return end

	actor:GetChild("Rank"):settext(rank)
	actor:GetChild("Name"):settext(name)
	actor:GetChild("Score"):settext(score)
end

local LeaderboardRequestProcessor = function(res, master)
	if master == nil then return end

	playerNumber = PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()]+1
	local leaderboard = master:GetChild("P"..playerNumber.."Leaderboard")

	local playerStr = "player"..playerNumber
	local entryNum = 1
	local rivalNum = 1
	local data = res["status"] == "success" and res["data"] or nil

	-- First check to see if the leaderboard even exists.
	if data and data[playerStr] and data[playerStr]["gsLeaderboard"] then
		for gsEntry in ivalues(data[playerStr]["gsLeaderboard"]) do
			local entry = leaderboard:GetChild("LeaderboardEntry"..entryNum)
			entry:diffuse(Color.White)
			SetEntryText(
				gsEntry["rank"]..".",
				gsEntry["name"],
				string.format("%.2f%%", gsEntry["score"]/100),
				entry
			)
			if gsEntry["isRival"] then
				entry:diffuse(Color.Black)
				leaderboard:GetChild("Rival"..rivalNum):y(entry:GetY()):visible(true)
				rivalNum = rivalNum + 1
			elseif gsEntry["isSelf"] then
				entry:diffuse(Color.Black)
				leaderboard:GetChild("Self"):y(entry:GetY()):visible(true)
			end
			entryNum = entryNum + 1
		end
	end

	-- Empty out any remaining entries.
	-- This also handles the error case. If success is false, then the above if block will not run.
	-- and we will set the first entry to "Failed to Load 😞".
	for i=entryNum, NumEntries do
		local entry = leaderboard:GetChild("LeaderboardEntry"..i)
		-- We didn't get any scores if i is still == 1.
		if i == 1 then
			if res["status"] == "success" then
				SetEntryText("", "No Scores Available", "", entry)
			elseif res["status"] == "fail" then
				SetEntryText("", "Failed to Load 😞", "", entry)
			elseif res["status"] == "disabled" then
				SetEntryText("", "Leaderboard Disabled", "", entry)
			end
		else
			-- Empty out the remaining rows.
			SetEntryText("", "", "", entry)
		end
	end
end

local af = Def.ActorFrame{
	Name="LeaderboardMaster",
	InitCommand=function(self) self:visible(false) end,
	ShowLeaderboardCommand=function(self)
		self:visible(true)
		MESSAGEMAN:Broadcast("ResetEntry")
		-- Only make the request when this actor gets actually displayed through the sort menu.
		self:queuecommand("SendLeaderboardRequest")
	end,
	HideLeaderboardCommand=function(self) self:visible(false) end,

	Def.Quad{ InitCommand=function(self) self:FullScreen():diffuse(0,0,0,0.875) end },
	LoadFont("Common Normal")..{
		Text=THEME:GetString("ScreenSelectMusic", "LeaderboardHelpText"),
		InitCommand=function(self) self:xy(_screen.cx, _screen.h-80):zoom(0.8) end
	},
	RequestResponseActor("Leaderboard", 10)..{
		SendLeaderboardRequestCommand=function(self)
			local sendRequest = false
			local data = {
				action="groovestats/player-leaderboards",
				maxLeaderboardResults=13,  -- We have 13 rows of space, but in the worst case we can have 9 scores and 4 "..."s
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

-- TODO(teejusb): Handle the LeaderboardInputEventMessage to go through the different leaderboards.
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
		LeaderboardInputEvent=function(self, event)

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
				self:diffuse(Color.Red):zoomto(paneWidth, RowHeight):visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end
		},

		Def.Quad {
			Name="Rival2",
			InitCommand=function(self)
				self:diffuse(Color.Red):zoomto(paneWidth, RowHeight):visible(false)
			end,
			ResetEntryMessageCommand=function(self)
				self:visible(false)
			end
		},

		Def.Quad {
			Name="Rival3",
			InitCommand=function(self)
				self:diffuse(Color.Red):zoomto(paneWidth, RowHeight):visible(false)
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
	}

	local af2 = af[#af]
	local textZoom = 0.7
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
					self:x(-paneWidth/2 + 30 + borderWidth)
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
					self:x(-paneWidth/2 + 100)
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
					self:x(paneWidth/2-borderWidth-10)
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
