local TextColor = ThemePrefs.Get("RainbowMode") and Color.Black or Color.White

local SongStats = SONGMAN:GetNumSongs() .. " songs in "
SongStats = SongStats .. SONGMAN:GetNumSongGroups() .. " groups, "
SongStats = SongStats .. #SONGMAN:GetAllCourses(PREFSMAN:GetPreference("AutogenGroupCourses")) .. " courses"

-- - - - - - - - - - - - - - - - - - - - -

local game = GAMESTATE:GetCurrentGame():GetName();
if game ~= "dance" and game ~= "pump" then
	game = "techno"
end

-- - - - - - - - - - - - - - - - - - - - -
local sm_version = ""
local sl_version = GetThemeVersion()

if ProductVersion():find("git") then
	local date = VersionDate()
	local year = date:sub(1,4)
	local month = date:sub(5,6)
	if month:sub(1,1) == "0" then month = month:gsub("0", "") end
	month = THEME:GetString("Months", "Month"..month)
	local day = date:sub(7,8)

	sm_version = ProductID() .. ", Built " .. month .. " " .. day .. ", " .. year
else
	sm_version = ProductID() .. sm_version
end
-- - - - - - - - - - - - - - - - - - - - -
-- Constants defining UI element positions depending on horizontal or vertical mode.
local is_horizontal = GetScreenAspectRatio() > 1
local song_stats_zoom		= (is_horizontal and 0.8 or 0.67)
local song_stats_y		= (is_horizontal and -120 or -75)
local logos_x			= (is_horizontal and 0 or 2)
local logos_y			= (is_horizontal and -16 or -10)
local logos_zoom_itg		= (is_horizontal and 0.2 or 0.114)
local logos_zoom_pump		= (is_horizontal and 0.205 or 0.125)
local title_zoom		= (is_horizontal and 0.7 or 0.4)
local hat_x			= (is_horizontal and 130 or 74)
local hat_decelerate_rate	= (is_horizontal and 1.333 or 1.1)
local hat_decelerate_y		= (is_horizontal and -110 or -65)

-- - - - - - - - - - - - - - - - - - - - -
local image = ThemePrefs.Get("VisualTheme")

if image == "Spooky" then  --SSHHHH dont tell anyone ;)
	image = (math.random(1,100) > 11 and "Spooky" or "Spoopy")
end

local af = Def.ActorFrame{
	InitCommand=function(self)
		--see: ./Scripts/SL_Initialize.lua
		InitializeSimplyLove()

		self:Center()
	end,
	OffCommand=cmd(linear,0.5; diffusealpha, 0),

	-- Program version and song stats
	Def.ActorFrame{
		InitCommand=function(self) self:zoom(song_stats_zoom):y(song_stats_y):diffusealpha(0) end,
		OnCommand=function(self) self:sleep(0.2):linear(0.4):diffusealpha(1) end,

		Def.BitmapText{
			Font="_miso",
			Text=sm_version .. (sl_version and ("       Simply Love v"..sl_version) or ""),
			InitCommand=function(self) self:y(-20):diffuse(TextColor) end,
		},
		Def.BitmapText{
			Font="_miso",
			Text=SongStats,
			InitCommand=function(self) self:diffuse(TextColor) end,
		}
	},

	-- Arrows between SIMPLY and LOVE
	LoadActor(THEME:GetPathG("", "_logos/" .. game))..{
		InitCommand=function(self)
			self:xy(logos_x,logos_y):zoom( game=="pump" and logos_zoom_itg or logos_zoom_pump )
		end
	},

	-- Large SIMPLY LOVE title
	LoadActor("Simply".. image .." (doubleres).png") .. {
		InitCommand=function(self) self:x(2):zoom(title_zoom):shadowlength(0.75) end,
		OffCommand=function(self) self:linear(0.5):shadowlength(0) end
	}
}

-- the best way to spread holiday cheer is singing loud for all to hear
if PREFSMAN:GetPreference("EasterEggs") and MonthOfYear()==11 then
	af[#af+1] = Def.Sprite{
		Texture=THEME:GetPathB("ScreenTitleMenu", "underlay/hat.png"),
		InitCommand=function(self) self:zoom(0.15):xy( hat_x, -self:GetHeight()/2 ):rotationz(15):queuecommand("Drop") end,
		DropCommand=function(self) self:decelerate(hat_decelerate_rate):y(hat_decelerate_y) end,
	}
end

return af