local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualTheme")
local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()

local banner = {
	directory = (FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")),
	width = 418,
	zoom = 0.5,
}

local title = {
	height = 30,
	zoom = 0.65
}

local y_offset = 46
local banner_y_offset = y_offset + 2.5

local af = Def.ActorFrame{InitCommand=function(self) self:xy(_screen.cx, y_offset) end}

if SongOrCourse and SongOrCourse:HasBanner() then
	--song or course banner, if there is one
	af[#af+1] = Def.Banner{
		Name="Banner",
		InitCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:LoadFromCourse( GAMESTATE:GetCurrentCourse() )
			else
				self:LoadFromSong( GAMESTATE:GetCurrentSong() )
			end
			self:y(banner_y_offset):setsize(banner.width, 164):zoom(banner.zoom)
		end
	}
else
	--fallback banner
	af[#af+1] = LoadActor(banner.directory .. "/banner" .. SL.Global.ActiveColorIndex .. " (doubleres).png")..{
		InitCommand=function(self) self:y(banner_y_offset):zoom(banner.zoom) end
	}
end

-- quad behind the song/course title text
af[#af+1] = Def.Quad{
	InitCommand=function(self) self:diffuse(color("#1E282F")):setsize(banner.width,title.height):zoom(banner.zoom) end,
}

-- song/course title text
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		local songtitle = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle()) or GAMESTATE:GetCurrentSong():GetDisplayFullTitle()
		if songtitle then self:settext(songtitle):maxwidth(banner.width*banner.zoom):zoom(title.zoom) end
	end
}

return af
