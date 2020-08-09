if not GAMESTATE:IsEventMode() then return end

local game = GAMESTATE:GetCurrentGame():GetName()
if not (game=="dance" or game=="pump" or game=="techno") then return end

local af = Def.ActorFrame{
	InitCommand=function(self) self:visible(false) end,
	ShowTestInputCommand=function(self) self:visible(true) end,
	HideTestInputCommand=function(self) self:visible(false) end,

	Def.Quad{ InitCommand=function(self) self:FullScreen():diffuse(0,0,0,0.875) end },
	LoadFont("Common Normal")..{
		Text=THEME:GetString("ScreenSelectMusic", "TestInputHelpText"),
		InitCommand=function(self) self:xy(_screen.cx, _screen.cy+90):zoom(0.8) end
	}
}

-- add TestInput pads for both players to the AF by default
-- if the style is single, just hide the unused pad, and start drawing it if latejoin occurs

for player in ivalues( PlayerNumber ) do
	af[#af+1] = LoadActor( THEME:GetPathB("", "_modules/TestInput Pad/default.lua"), {Player=player, ShowMenuButtons=false, ShowPlayerLabel=false})..{
		InitCommand=function(self)
			local styletype = GAMESTATE:GetCurrentStyle():GetStyleType()
			if styletype == "StyleType_OnePlayerTwoSides" or styletype == "StyleType_TwoPlayersSharedSides" then
				self:xy(_screen.cx, _screen.cy+50)
			else
				self:xy(_screen.cx, _screen.cy+50)
				self:visible(GAMESTATE:IsSideJoined(player))
			end
			self:zoom(0.7)
		end,
		PlayerJoinedMessageCommand=function(self) self:visible(GAMESTATE:IsSideJoined(player)) end
	}
end

return af
