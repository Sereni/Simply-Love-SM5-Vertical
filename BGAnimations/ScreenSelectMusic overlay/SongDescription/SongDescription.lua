local MusicWheel, SelectedType
local group_durations = LoadActor("./GroupDurations.lua")
local labelZoom = 0.4
local labelYOffset = 5
local labelsXOffset = -40

local af = Def.ActorFrame{
	OnCommand=function(self)
		self:xy(62.25, 164)
	end,

	CurrentSongChangedMessageCommand=function(self)    self:playcommand("Set") end,
	CurrentCourseChangedMessageCommand=function(self)  self:playcommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end,
}

-- background for Artist, BPM, and Song Length
af[#af+1] =	Def.Quad{
			InitCommand=function(self)
				self:diffuse(color("#1e282f"))
					:zoomto( 125, 25 )

		if ThemePrefs.Get("RainbowMode") then self:diffusealpha(0.9) end
	end
}

-- ActorFrame for Artist, BPM, and Song length
af[#af+1] = Def.ActorFrame{
	InitCommand=function(self) self:x(labelsXOffset) end,

	-- ----------------------------------------
	-- Artist Label
	LoadFont("Common Normal")..{
		Text=THEME:GetString("SongDescription", GAMESTATE:IsCourseMode() and "NumSongs" or "Artist"),
		InitCommand=function(self)
					self:horizalign(right):y(-labelYOffset)
						:maxwidth(44)
						:zoom(labelZoom)
					    :diffuse(0.5,0.5,0.5,1)
				end,
	},

	-- Song Artist (or number of Songs in this Course, if CourseMode)
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:horizalign(left):xy(5,-labelYOffset):maxwidth(225):zoom(labelZoom) end,
		SetCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				local course = GAMESTATE:GetCurrentCourse()
				self:settext( course and #course:GetCourseEntries() or "" )
			else
				local song = GAMESTATE:GetCurrentSong()
				self:settext( song and song:GetDisplayArtist() or "" )
			end
		end
	},

	-- ----------------------------------------
	-- BPM Label
	LoadFont("Common Normal")..{
		Text=THEME:GetString("SongDescription", "BPM"):upper(),
		InitCommand=function(self)
			self:horizalign(right):y(labelYOffset):zoom(labelZoom)
						:diffuse(0.5,0.5,0.5,1)
		end
	},

	-- BPM value
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			-- vertical align has to be middle for BPM value in case of split BPMs having a line break
			self:align(0, 0.5)
			self:horizalign(left):xy(5,labelYOffset):diffuse(1,1,1,1):zoom(labelZoom):vertspacing(-8)
		end,
		SetCommand=function(self)

			if MusicWheel then SelectedType = MusicWheel:GetSelectedType() end

			-- we only want to try to show BPM values for Songs and Courses
			-- not Section, Roulette, Random, Portal, Sort, or Custom
			-- (aside: what is "WheelItemDataType_Custom"?  I need to look into that.)
			if not (SelectedType=="WheelItemDataType_Song" or SelectedType=="WheelItemDataType_Course") then
				self:settext("")
				return
			end

			-- StringifyDisplayBPMs() is defined in ./Scipts/SL-BPMDisplayHelpers.lua
			self:settext(StringifyDisplayBPMs() or ""):zoom(labelZoom)
	},

	-- Song Duration Label
	LoadFont("Common Normal")..{
		Text=THEME:GetString("SongDescription", "Length"),
		InitCommand=function(self)
			self:horizalign(right)
				:x(labelsXOffset+110):y(labelYOffset):zoom(labelZoom)
				:diffuse(0.5,0.5,0.5,1)
		end
	},

	-- Song Duration Value
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:horizalign(left):xy(labelsXOffset + 110 + 5, labelYOffset):zoom(labelZoom) end,
		SetCommand=function(self)
			if MusicWheel == nil then MusicWheel = SCREENMAN:GetTopScreen():GetMusicWheel() end

			SelectedType = MusicWheel:GetSelectedType()
			local seconds

			if SelectedType == "WheelItemDataType_Song" then
				-- GAMESTATE:GetCurrentSong() can return nil here if we're in pay mode on round 2 (or later)
				-- and we're returning to SSM to find that the song we'd just played is no longer available
				-- because it exceeds the 2-round or 3-round time limit cutoff.
				local song = GAMESTATE:GetCurrentSong()
				if song then
					seconds = song:MusicLengthSeconds()
				end

			elseif SelectedType == "WheelItemDataType_Section" then
				-- MusicWheel:GetSelectedSection() will return a string for the text of the currently active WheelItem
				-- use it here to look up the overall duration of this group from our precalculated table of group durations
				seconds = group_durations[MusicWheel:GetSelectedSection()]

			elseif SelectedType == "WheelItemDataType_Course" then
				-- is it possible for 2 Trails within the same Course to have differing durations?
				-- I can't think of a scenario where that would happen, but hey, this is StepMania.
				-- In any case, I'm opting to display the duration of the MPN's current trail.
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
				if trail then
					seconds = TrailUtil.GetTotalSeconds(trail)
				end
			end

			-- r21 lol
			if seconds == 105.0 then self:settext(THEME:GetString("SongDescription", "r21")); return end

			if seconds then
				seconds = seconds / SL.Global.ActiveModifiers.MusicRate

				-- longer than 1 hour in length
				if seconds > 3600 then
					-- format to display as H:MM:SS
					self:settext(math.floor(seconds/3600) .. ":" .. SecondsToMMSS(seconds%3600))
				else
					-- format to display as M:SS
					self:settext(SecondsToMSS(seconds))
				end
			else
				self:settext("")
			end
		end
	}
}

if not GAMESTATE:IsEventMode() then

	-- long/marathon version bubble graphic and text
	af[#af+1] = Def.ActorFrame{
		OnCommand=function(self)
			self:x( 15 ):y(-4)
			end,
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				self:visible( song and (song:IsLong() or song:IsMarathon()) or false )
			end,


		Def.ActorMultiVertex{
			InitCommand=function(self)
				-- these coordinates aren't neat and tidy, but they do create three triangles
				-- that fit together to approximate hurtpiggypig's original png asset
				local verts = {
				 	--   x   y  z    r,g,b,a
				 	{{-50, 40, 0}, {1,1,1,1}},
				 	{{ 50, 40, 0}, {1,1,1,1}},
				 	{{ 50, 25, 0}, {1,1,1,1}},

				 	{{ 50, 25, 0}, {1,1,1,1}},
				 	{{-50, 25, 0}, {1,1,1,1}},
				 	{{-50, 40, 0}, {1,1,1,1}},

				 	{{ 45, 26, 0}, {1,1,1,1}},
				 	{{ 35, 26, 0}, {1,1,1,1}},
				 	{{ 40, 19, 0}, {1,1,1,1}},
					}

				self:SetDrawState({Mode="DrawMode_Triangles"}):SetVertices(verts)
				self:diffuse(GetCurrentColor())
				self:xy(0,4):zoom(0.6)
			end
		},

		LoadFont("Common Normal")..{
			InitCommand=function(self) self:diffuse(Color.Black):zoom(0.4):y(21+2.5) end,
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if not song then self:settext(""); return end

				if song:IsMarathon() then
					self:settext(THEME:GetString("SongDescription", "IsMarathon"))
				elseif song:IsLong() then
					self:settext(THEME:GetString("SongDescription", "IsLong"))
				else
					self:settext("")
				end
			end
		}
	}
end

return af
