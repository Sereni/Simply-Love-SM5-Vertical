local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualTheme")
local banner_directory = FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")

local SongOrCourse, banner

local t = Def.ActorFrame{
	OnCommand=function(self)
			self:zoom(0.3)
			self:xy(62, 127)
	end
}

-- fallback banner
t[#t+1] = Def.Sprite{
	Name="FallbackBanner",
	Texture=banner_directory.."/banner"..SL.Global.ActiveColorIndex.." (doubleres).png",
	InitCommand=function(self) self:setsize(418,164) end,

	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end,

	SetCommand=function(self)
		-- if ShowBanners preference is false, always just show the fallback banner
		-- don't bother assessing whether to draw or not draw
		if PREFSMAN:GetPreference("ShowBanners") == false then return end

		SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
		if SongOrCourse and SongOrCourse:HasBanner() then
			self:visible(false)
		else
			self:visible(true)
		end
	end
}

if PREFSMAN:GetPreference("ShowBanners") then
	t[#t+1] = Def.ActorProxy{
		Name="BannerProxy",
		BeginCommand=function(self)
			banner = SCREENMAN:GetTopScreen():GetChild('Banner')
			self:SetTarget(banner)
		end
	}
end

-- the MusicRate Quad and text
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:visible( SL.Global.ActiveModifiers.MusicRate ~= 1 ):y(70)
	end,

	--quad behind the music rate text
	Def.Quad{
		InitCommand=function(self) self:diffuse( color("#1E282FCC") ):zoomto(418,25) end
	},

	--the music rate text
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:shadowlength(1):zoom(1.1) end,
		OnCommand=function(self)
			self:settext(("%g"):format(SL.Global.ActiveModifiers.MusicRate) .. "x " .. THEME:GetString("OptionTitles", "MusicRate"))
		end
	}
}

return t
