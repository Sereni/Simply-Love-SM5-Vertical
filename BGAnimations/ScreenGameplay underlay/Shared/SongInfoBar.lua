local xOffset = _screen.cx-12.5
local yOffset = 16
local barLength = _screen.w-45
local barHeight = 18
local borderWidth = 4

-- Song Completion Meter
return Def.ActorFrame{
	Name="SongMeter",
	InitCommand=function(self) self:xy(xOffset, yOffset) end,

	-- border
	Def.Quad{ InitCommand=function(self) self:zoomto(barLength, barHeight) end },
	Def.Quad{ InitCommand=function(self) self:zoomto(barLength-borderWidth, barHeight-borderWidth):diffuse(0,0,0,1) end },

	Def.SongMeterDisplay{
		StreamWidth=(barLength-borderWidth),
		Stream=Def.Quad{ InitCommand=function(self) self:zoomy(14):diffuse(GetCurrentColor(true)) end }
	},

	-- Song Title
	LoadFont("Common Normal")..{
		Name="SongTitle",
		InitCommand=function(self) self:zoom(0.6):shadowlength(0.6):maxwidth(barLength) end,
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext( song and song:GetDisplayFullTitle() or "" )
		end

	}
}
