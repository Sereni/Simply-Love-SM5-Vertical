local TextColor = (ThemePrefs.Get("RainbowMode") and (not HolidayCheer()) and Color.Black) or Color.White

-- generate a string like "7741 songs in 69 groups, 10 courses"
local SongStats = ("%i %s %i %s, %i %s"):format(
	SONGMAN:GetNumSongs(),
	THEME:GetString("ScreenTitleMenu", "songs in"),
	SONGMAN:GetNumSongGroups(),
	THEME:GetString("ScreenTitleMenu", "groups"),
	#SONGMAN:GetAllCourses(PREFSMAN:GetPreference("AutogenGroupCourses")),
	THEME:GetString("ScreenTitleMenu", "courses")
)

-- - - - - - - - - - - - - - - - - - - - -
local game = GAMESTATE:GetCurrentGame():GetName();
if game ~= "dance" and game ~= "pump" then
	game = "techno"
end

-- - - - - - - - - - - - - - - - - - - - -
-- People commonly have multiple copies of SL installed – sometimes different forks with unique features
-- sometimes due to concern that an update will cause them to lose data, sometimes accidentally, etc.

-- It is important to display the current theme's name to help users quickly assess what version of SL
-- they are using right now.  THEME:GetCurThemeName() provides the name of the theme folder from the
-- filesystem, so we'll show that.  It is guaranteed to be unique and users are likely to recognize it.
local sl_name = THEME:GetCurThemeName()

-- - - - - - - - - - - - - - - - - - - - -
-- ProductFamily() returns "StepMania"
-- ProductVersion() returns the (stringified) version number (like "5.0.12" or "5.1.0")
-- so, start with a string like "StepMania 5.0.12" or "StepMania 5.1.0"
local sm_version = ("%s %s"):format(ProductFamily(), ProductVersion())

-- GetThemeVersion() is defined in ./Scripts/SL-Helpers.lua and returns the SL version from ThemeInfo.ini
local sl_version = GetThemeVersion()

-- "git" appears in ProductVersion() for non-release builds of StepMania.
-- If a non-release executable is being used, append date information about when it
-- was built to potentially help non-technical cabinet owners submit bug reports.
if ProductVersion():find("git") then
	local date = VersionDate()
	local year = date:sub(1,4)
	local month = date:sub(5,6)
	if month:sub(1,1) == "0" then month = month:gsub("0", "") end
	month = THEME:GetString("Months", "Month"..month)
	local day = date:sub(7,8)

	sm_version = ("%s, Built %s %s %s"):format(sm_version, day, month, year)
end
-- - - - - - - - - - - - - - - - - - - - -
-- Constants defining UI element positions depending on horizontal or vertical mode.
local song_stats_zoom		= (IsVerticalScreen() and 0.6 or 0.8)
local song_stats_y		= (IsVerticalScreen() and -70 or -120)
local logos_x			= (IsVerticalScreen() and 2 or 0)
local logos_y			= (IsVerticalScreen() and -10 or -16)
local logos_zoom_itg		= (IsVerticalScreen() and 0.114 or 0.2)
local logos_zoom_pump		= (IsVerticalScreen() and 0.125 or 0.205)
local title_zoom		= (IsVerticalScreen() and 0.4 or 0.7)
local hat_x			= (IsVerticalScreen() and 74 or 130)
local hat_decelerate_rate	= (IsVerticalScreen() and 1.1 or 1.333)
local hat_decelerate_y		= (IsVerticalScreen() and -65 or -110)
-- - - - - - - - - - - - - - - - - - - - -

local style = ThemePrefs.Get("VisualTheme")
local image = "TitleMenu"

-- see: watch?v=wxBO6KX9qTA etc.
if FILEMAN:DoesFileExist("/Themes/"..sl_name.."/Graphics/_VisualStyles/"..ThemePrefs.Get("VisualTheme").."/TitleMenuAlt (doubleres).png") then
	if math.random(1,100) <= 10 then image="TitleMenuAlt" end
end

local af = Def.ActorFrame{
	InitCommand=function(self)
		--see: ./Scripts/SL_Init.lua
		InitializeSimplyLove()

		-- FIXME: Calling self:Center() after InitializeECS() moves the title off screen
		self:Center()

		-- see: ./Scripts/ECS.lua
		InitializeECS()

	end,
	OffCommand=cmd(linear,0.5; diffusealpha, 0),

	-- Program version and song stats
	Def.ActorFrame{
		InitCommand=function(self) self:zoom(song_stats_zoom):y(song_stats_y):diffusealpha(0) end,
		OnCommand=function(self) self:sleep(0.2):linear(0.4):diffusealpha(1) end,

		LoadFont("Miso/_miso")..{
			Text=sm_version .. "       " .. sl_name .. (sl_version and (" v" .. sl_version) or ""),
			InitCommand=function(self) self:y(-20):diffuse(TextColor) end,
		},
		LoadFont("Miso/_miso")..{
			Text=SongStats,
			InitCommand=function(self) self:diffuse(TextColor) end,
		}
	},

	-- East Coast Stamina logo
	LoadActor(THEME:GetPathG("", "_ECSX/logo (doubleres).png"))..{
		InitCommand=function(self) self:xy(0,15):zoom(0.08):shadowlength(0.75) end,
		OffCommand=function(self) self:linear(0.5):shadowlength(0) end
	}
}

-- the best way to spread holiday cheer is singing loud for all to hear
if HolidayCheer() then
	af[#af+1] = Def.Sprite{
		Texture=THEME:GetPathB("ScreenTitleMenu", "underlay/hat.png"),
		InitCommand=function(self) self:zoom(0.1):xy( hat_x-15, -self:GetHeight()/2 ):rotationz(15):queuecommand("Drop") end,
		DropCommand=function(self) self:decelerate(hat_decelerate_rate):y(hat_decelerate_y+48) end,
	}
end

return af
