local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualTheme")
local banner_directory = FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")

local SongOrCourse, banner

local t = Def.ActorFrame{
	OnCommand=function(self)
			self:zoom(0.4)
			self:xy(83.5, 48)
	end,

	Def.ActorFrame{
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
		CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
			if SongOrCourse and SongOrCourse:HasBanner() then
				self:visible(false)
			else
				self:visible(true)
			end
		end,

		LoadActor(banner_directory.."/banner"..SL.Global.ActiveColorIndex.." (doubleres).png" )..{
			Name="FallbackBanner",
			OnCommand=function(self) self:rotationy(180):setsize(418,164):diffuseshift():effectoffset(3):effectperiod(6):effectcolor1(1,1,1,0):effectcolor2(1,1,1,1) end
		},

		LoadActor(banner_directory.."/banner"..SL.Global.ActiveColorIndex.." (doubleres).png" )..{
			Name="FallbackBanner",
			OnCommand=function(self) self:diffuseshift():effectperiod(6):effectcolor1(1,1,1,0):effectcolor2(1,1,1,1):setsize(418,164) end
		},
	},

	Def.ActorProxy{
		Name="BannerProxy",
		BeginCommand=function(self)
			banner = SCREENMAN:GetTopScreen():GetChild('Banner')
			self:SetTarget(banner)
		end
	},

	-- the MusicRate Quad and text
	Def.ActorFrame{
		InitCommand=function(self)
			self:visible( SL.Global.ActiveModifiers.MusicRate ~= 1 ):y(75)
		end,

		--quad behind the music rate text
		Def.Quad{
			InitCommand=function(self) self:diffuse( color("#1E282FCC") ):zoomto(418,14) end
		},

		--the music rate text
		LoadFont("Common Normal")..{
			InitCommand=function(self) self:shadowlength(1):zoom(0.85) end,
			OnCommand=function(self)
				self:settext(("%g"):format(SL.Global.ActiveModifiers.MusicRate) .. "x " .. THEME:GetString("OptionTitles", "MusicRate"))
			end
		}
	}
}

return t
