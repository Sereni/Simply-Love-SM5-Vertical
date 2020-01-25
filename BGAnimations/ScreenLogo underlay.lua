local image = ThemePrefs.Get("VisualTheme")
local game = GAMESTATE:GetCurrentGame():GetName()
if game ~= "dance" and game ~= "pump" then
	game = "techno"
end

-- - - - - - - - - - - - - - - - - - - - -
-- Constants defining UI element positions depending on horizontal or vertical mode.
local logos_x			= (IsVerticalScreen() and 2 or 0)
local logos_y			= (IsVerticalScreen() and -10 or -16)
local logos_zoom_itg		= (IsVerticalScreen() and 0.114 or 0.2)
local logos_zoom_pump		= (IsVerticalScreen() and 0.125 or 0.205)
local title_zoom		= (IsVerticalScreen() and 0.4 or 0.7)

local t = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(_screen.cx, _screen.cy-16):zoom( game=="pump" and 0.2 or 0.205 ):cropright(1)
	end,

	LoadActor(THEME:GetPathG("", "_logos/" .. game))..{
		InitCommand=function(self)
			self:xy(_screen.cx+logos_x, logos_y):zoom( game=="pump" and logos_zoom_itg or logos_zoom_pump ):cropright(1)
		end,
		OnCommand=function(self)
			self:linear(0.33):cropright(0)
		end
	},

	LoadActor(THEME:GetPathG("", "_VisualStyles/".. image .."/TitleMenu (doubleres).png"))..{
		InitCommand=function(self)
			self:x(_screen.cx+2):diffusealpha(0):zoom(title_zoom)
				:shadowlength(1)
		end,
		OnCommand=cmd(linear,0.5; diffusealpha, 1)
	}
}

t[#t+1] = LoadActor(THEME:GetPathG("", "_VisualStyles/".. image .."/TitleMenu (doubleres).png"))..{
	InitCommand=function(self)
		self:xy(_screen.cx+2, _screen.cy):diffusealpha(0):zoom(0.7)
			:shadowlength(1)
	end,
	OffCommand=cmd(visible,false),

	LoadFont("_wendy small")..{
		Text=THEME:GetString("ScreenLogo", "EnterCreditsToPlay"),
		InitCommand=cmd(xy,_screen.cx,SCREEN_BOTTOM-100; zoom,0.525; visible,false),
		RefreshCommand=function(self)
			local credits = GetCredits()
			self:visible( GAMESTATE:GetCoinMode() == "CoinMode_Pay" and credits.Credits <= 0 )
		end
	},

	LoadFont("_wendy small")..{
		Text=THEME:GetString("ScreenTitleJoin", "Press Start"),
		InitCommand=cmd(xy,_screen.cx, _screen.h-80; zoom,0.715; visible,false),
		RefreshCommand=function(self)
			local credits = GetCredits()
			self:visible( (GAMESTATE:GetCoinMode() == "CoinMode_Pay" and credits.Credits > 0) or GAMESTATE:GetCoinMode() == "CoinMode_Free")
		end
	},

	LoadFont("_wendy small")..{
		Text=THEME:GetString("ScreenSelectMusic","Start Button"),
		InitCommand=cmd(x,_screen.cx - 12; y,_screen.h - 125; zoom,1.1; visible,false),
		RefreshCommand=function(self)
			local credits = GetCredits()
			self:visible( (GAMESTATE:GetCoinMode() == "CoinMode_Pay" and credits.Credits > 0) or GAMESTATE:GetCoinMode() == "CoinMode_Free")
		end
	}
}

return t
