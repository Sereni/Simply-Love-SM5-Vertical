local Player = ...
local pn = ToEnumShortString(Player)
local CanEnterName = SL[pn].HighScores.EnteringName

local paneWidth = 200

if CanEnterName then
	SL[pn].HighScores.Name = ""
end

if PROFILEMAN:IsPersistentProfile(Player) then
	SL[pn].HighScores.Name = PROFILEMAN:GetProfile(Player):GetLastUsedHighScoreName()
end

local yOffset = _screen.cy - 40
local cursorYOffset = 44

local t = Def.ActorFrame{
	Name="PlayerNameAndDecorations_"..pn,
	InitCommand=function(self)
	  self:x(_screen.cx)
		self:y(yOffset)
	end,


	-- the quad behind the playerName
	Def.Quad{
		InitCommand=function(self) self:diffuse(0,0,0,0.75):zoomto(paneWidth, 48) end,
	},

	-- the quad behind the scrolling alphabet
	Def.Quad{
		InitCommand=function(self) self:diffuse(0,0,0,0.5):zoomto(paneWidth, 40) end,
		OnCommand=function(self) self:y(cursorYOffset) end
	},

	-- the quad behind the highscore list
	Def.Quad{
		InitCommand=function(self) self:diffuse(0,0,0,0.25):zoomto(paneWidth, 160) end,
		OnCommand=function(self) self:y(cursorYOffset + 100) end
	}
}


t[#t+1] = LoadActor("Cursor.png")..{
	Name="Cursor",
	InitCommand=function(self) self:diffuse(PlayerColor(Player)):zoom(0.35) end,
	OnCommand=function(self) self:visible( CanEnterName ):y(cursorYOffset) end,
	HideCommand=function(self) self:linear(0.25):diffusealpha(0) end
}

t[#t+1] = LoadFont("_wendy white")..{
	Name="PlayerName",
	InitCommand=function(self) self:zoom(0.5) end,
	OnCommand=function(self)
		self:visible( CanEnterName )
		self:settext( SL[pn].HighScores.Name or "" )
	end,
	SetCommand=function(self)
		self:settext( SL[pn].HighScores.Name or "" )
	end
}

t[#t+1] = LoadFont("_wendy small")..{
	Text=ScreenString("OutOfRanking"),
	OnCommand=function(self) self:zoom(0.5):diffuse(PlayerColor(Player)):y(cursorYOffset):visible(not CanEnterName) end
}

return t
