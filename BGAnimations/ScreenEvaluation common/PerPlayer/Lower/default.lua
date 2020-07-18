-- per-player lower half of ScreenEvaluation

local player = ...
local NumPlayers = #GAMESTATE:GetHumanPlayers()
local pane_width = 210
local pane_height  = 130

local af = Def.ActorFrame{
	Name=ToEnumShortString(player).."_AF_Lower",
	InitCommand=function(self)
	self:x(_screen.cx)
	end
}

-- -----------------------------------------------------------------------
-- background quad for player stats

af[#af+1] = Def.Quad{
	Name="LowerQuad",
	InitCommand=function(self)
		self:diffuse(color("#1E282F")):horizalign(left)
		self:xy(-pane_width * 0.5, _screen.cy+10)
		self:zoomto( pane_width, pane_height )

		if ThemePrefs.Get("RainbowMode") then
			self:diffusealpha(0.9)
		end
	end
}

-- "Look at this graph."  –Some sort of meme on The Internet
af[#af+1] = LoadActor("./Graphs.lua", player)

-- list of modifiers used by this player for this song
af[#af+1] = LoadActor("./PlayerModifiers.lua", player)

-- was this player disqualified from ranking?
af[#af+1] = LoadActor("./Disqualified.lua", player)

-- -----------------------------------------------------------------------

return af
