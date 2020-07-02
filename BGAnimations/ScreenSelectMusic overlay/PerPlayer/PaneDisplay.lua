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

--MACHINE high score
af[#af+1] = LoadFont("Common Normal")..{
	Name="MachineHighScore",
	InitCommand=function(self) self:x(labelX_col1 - labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(right) end
}

--MACHINE highscore name
af[#af+1] = LoadFont("Common Normal")..{
	Name="MachineHighScoreName",
	InitCommand=function(self) self:x(dataX_col1 + labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(left):maxwidth(80) end
}


--PLAYER PROFILE high score
af[#af+1] = LoadFont("Common Normal")..{
	Name="PlayerHighScore",
	InitCommand=function(self) self:x(labelX_col2 - labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(right) end
}

--PLAYER PROFILE highscore name
af[#af+1] = LoadFont("Common Normal")..{
	Name="PlayerHighScoreName",
	InitCommand=function(self) self:x(dataX_col2 + labelSpacing):y(rowOneY + rowHeight * 3 + 2):zoom(zoom_factor):diffuse(Color.Black):horizalign(left):maxwidth(80) end
}

return af
