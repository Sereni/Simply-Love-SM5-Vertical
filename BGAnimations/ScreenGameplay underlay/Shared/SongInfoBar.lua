local xOffset = _screen.cx-14.5
local yOffset = 20
local barLength = _screen.w-45

return Def.ActorFrame{
	-- Song Completion Meter
	Def.ActorFrame{
		Name="SongMeter",
		InitCommand=cmd(xy, xOffset, yOffset ),

		Def.SongMeterDisplay{
			StreamWidth=barLength,
			Stream=Def.Quad{
				InitCommand=cmd(zoomy,18; diffuse,DifficultyIndexColor(2))
			}
		},

		Border( barLength, 22, 2 ),
	},

	Border( _screen.w/2-10, 22, 2 ),

	-- Song Title
	LoadFont("Common Normal")..{
		Name="SongTitle",
		InitCommand=cmd(zoom,0.8; shadowlength,0.6; maxwidth, barLength; xy, xOffset, yOffset ),
		CurrentSongChangedMessageCommand=cmd(playcommand, "Update"),
		UpdateCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext( song and song:GetDisplayFullTitle() or "" )
		end
	}
}
