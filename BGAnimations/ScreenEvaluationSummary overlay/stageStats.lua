local position_on_screen = ...

local Players = GAMESTATE:GetHumanPlayers()
local song, StageNum, LetterGradesAF
local bannerZoom = 0.27
local quadWidth = _screen.w-40
local quadHeight = 75
local bannerXOffset = -quadWidth/4+10

local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualTheme")
local banner_directory = FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")

local t = Def.ActorFrame{
	OnCommand=function(self)
		LetterGradesAF = self:GetParent():GetChild("LetterGradesAF")
	end,
	DrawPageCommand=function(self, params)
		self:sleep(position_on_screen*0.05):linear(0.15):diffusealpha(0)

		StageNum = ((params.Page-1)*params.SongsPerPage) + position_on_screen
		local stage = SL.Global.Stages.Stats[StageNum]
		song = stage ~= nil and stage.song or nil

		self:queuecommand("DrawStage")
	end,
	DrawStageCommand=function(self)
		if song == nil then
			self:visible(false)
		else
			self:queuecommand("Show"):visible(true)
		end
	end,

	-- black quad
	Def.Quad{
		InitCommand=function(self) self:zoomto( quadWidth, quadHeight ):diffuse(0,0,0,0.5):y(-6) end
	},

	--fallback banner
	LoadActor(banner_directory.."/banner"..SL.Global.ActiveColorIndex.." (doubleres).png")..{
		InitCommand=function(self) self:xy(bannerXOffset, -4):zoom(bannerZoom) end,
		DrawStageCommand=function(self) self:visible(song ~= nil and not song:HasBanner()) end
	},

	-- the banner, if there is one
	Def.Banner{
		Name="Banner",
		InitCommand=function(self) self:xy(bannerXOffset, -4) end,
		DrawStageCommand=function(self)
			if song then
				if GAMESTATE:IsCourseMode() then
					self:LoadFromCourse(song)
				else
					self:LoadFromSong(song)
				end
				self:setsize(418,164):zoom(bannerZoom)
			end
		end
	},

	-- the title of the song
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:zoom(0.58):xy(bannerXOffset, -quadHeight/2 + 3):maxwidth(200) end,
		DrawStageCommand=function(self)
			if song then self:settext(song:GetDisplayFullTitle()) end
		end
	},

	-- the BPM(s) of the song
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:zoom(0.45):xy(bannerXOffset, quadHeight/3):maxwidth(200) end,
		DrawStageCommand=function(self)
			if song then
				local text = ""
				local BPMs

				if GAMESTATE:IsCourseMode() then
					-- I'm unable to find a way to figure out which songs were played in a randomly
					-- generated course (for example, the "Most Played" courses that ship with SM5),
					-- so GetCourseModeBPMs() will return nil in those cases.
					BPMs = GetCourseModeBPMs(song)
				else
					BPMs = song:GetDisplayBpms()
				end

				local MusicRate = SL.Global.Stages.Stats[StageNum].MusicRate

				if BPMs then
					if BPMs[1] == BPMs[2] then
						text = text .. round(BPMs[1] * MusicRate) .. " bpm"
					else
						text = text .. round(BPMs[1] * MusicRate) .. " - " .. round(BPMs[2] * MusicRate) .. " bpm"
					end
				end

				if MusicRate ~= 1 then
					text = text .. " (" .. tostring(MusicRate).."x Music Rate)"
				end

				self:settext(text)
			end
		end
	}
}

for player in ivalues(Players) do

	local playerStats, difficultyMeter, difficulty, stepartist, grade, score
	local TNSTypes = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' }

	-- variables for positioning and horizalign
	local col1x, col2x, align1, align2
		col1x =  quadWidth/2 - 10
		col2x =  20
		align1 = right
		align2 = left


	local PlayerStatsAF = Def.ActorFrame{
		DrawStageCommand=function(self)
			playerStats = SL[ToEnumShortString(player)].Stages.Stats[StageNum]

			if playerStats then
		 		difficultyMeter = playerStats.difficultyMeter
		 		difficulty = playerStats.difficulty
		 		stepartist = playerStats.stepartist
		 		grade = playerStats.grade
		 		score = playerStats.score
			end
		end
	}

	--percent score
	PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("_wendy small")..{
		InitCommand=function(self) self:zoom(0.4):horizalign(align1):x(col1x):y(-quadHeight/2+19) end,
		DrawStageCommand=function(self)
			if playerStats and score then

				-- trim off the % symbol
				local score = string.sub(FormatPercentScore(score),1,-2)

				-- If the score is < 10.00% there will be leading whitespace, like " 9.45"
				-- trim that too, so PLAYER_2's scores align properly.
				score = score:gsub(" ", "")
				self:settext(score):diffuse(Color.White)

				if grade and grade == "Grade_Failed" then
					self:diffuse(Color.Red)
				end
			else
				self:settext("")
			end
		end
	}

	-- difficulty meter
	PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("_wendy small")..{
		InitCommand=function(self) self:zoom(0.3):horizalign(align1):x(col1x):y(quadHeight/2-35) end,
		DrawStageCommand=function(self)
			if playerStats and difficultyMeter then
				self:diffuse(DifficultyColor(difficulty)):settext(difficultyMeter)
			else
				self:settext("")
			end
		end
	}

	-- stepartist
	PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
		InitCommand=function(self) self:zoom(0.55):horizalign(align1):x(col1x):y(quadHeight/2-20):maxwidth(130) end,
		DrawStageCommand=function(self)
			if playerStats and stepartist then
				self:settext(stepartist)
			else
				self:settext("")
			end
		end
	}

	-- numbers
	for i=1,#TNSTypes do

		PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("_wendy small")..{
			InitCommand=function(self)
				self:zoom(0.2):horizalign(align2):x(col2x):y(i*11-45)
					:diffuse( SL.JudgmentColors[SL.Global.GameMode][i] )
			end,
			DrawStageCommand=function(self)
				if playerStats and playerStats.judgments then
					local val = playerStats.judgments[TNSTypes[i]]
					if val then self:settext(val) end

					local worst = SL.Global.Stages.Stats[StageNum].WorstTimingWindow
					self:visible( i <= worst or i==#TNSTypes )
				else
					self:settext("")
				end
			end
		}
	end

	t[#t+1] = PlayerStatsAF
end

return t
