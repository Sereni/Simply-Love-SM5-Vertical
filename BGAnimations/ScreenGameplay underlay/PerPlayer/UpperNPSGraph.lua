local player = ...
local pn = ToEnumShortString(player)

if not SL[pn].ActiveModifiers.NPSGraphAtTop
or SL.Global.GameMode == "Casual"
or SL.Global.GameMode == "StomperZ"
then
	return
end

local styletype = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
local width = 109
local height = 18

-- support double, double8, and routine by making as wide as single
if styletype == "OnePlayerTwoSides" or styletype == "TwoPlayersSharedSides" then
	width = width/2
end

local song_percent, first_second, last_second

return Def.ActorFrame{
	InitCommand=function(self)
		self:y(49)
		self:x(_screen.cx + 18)
	end,
	-- called at the start of each new song in CourseMode, and once at the start of regular gameplay
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		first_second = math.min(song:GetTimingData():GetElapsedTimeFromBeat(0), 0)
		last_second = song:GetLastSecond()

		self:queuecommand("Size")
	end,

	Def.Quad{ InitCommand=function(self) self:setsize(width, height):diffuse(0.3,0.3,0.3,1):align(0,1) end },

	NPS_Histogram(player, width, height)..{
		SizeCommand=function(self)
			self:zoomtoheight(1)

			if #GAMESTATE:GetHumanPlayers()==2 and SL.P1.ActiveModifiers.NPSGraphAtTop and SL.P2.ActiveModifiers.NPSGraphAtTop then
				local my_peak = SL[pn].NoteDensity.Peak
				local their_peak = SL[ToEnumShortString(OtherPlayer[player])].NoteDensity.Peak

				if my_peak < their_peak then
					self:zoomtoheight(my_peak/their_peak)
				end
			end
		end
	},

	Def.Quad{
		Name="ProgressQuad",
		InitCommand=function(self)
			self:setsize(width, height)
				:align(0,1)
				:diffuse(0,0,0,0.80)
				:queuecommand("Update")
		end,
		UpdateCommand=function(self)
			song_percent = scale( GAMESTATE:GetCurMusicSeconds(), first_second, last_second, 0, width )
			self:zoomtowidth(clamp(song_percent, 0, width)):sleep(0.25):queuecommand("Update")
		end,
		CurrentSongChangedMessageCommand=function(self) self:zoomto(0, height) end
	}
}
