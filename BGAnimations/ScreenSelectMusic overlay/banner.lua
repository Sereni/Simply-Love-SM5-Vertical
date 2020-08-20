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

-- TODO(Sereni): layout and maybe move away from the banner, we got space
local SetSongPointText = function(self)
	local song = GAMESTATE:GetCurrentSong()
	if song == nil then
		self:settext("Min Song Points:")
		return
	end
	local group_name = song:GetGroupName()
	if (group_name ~= "ECS9 - Upper" and
		group_name ~= "ECS9 - Lower" and
		group_name ~= "ECS9 - Upper Marathon") then
		self:settext("Min Song Points:")
		return
	end
	local song_info = PlayerIsUpper() and ECS.SongInfo.Upper or ECS.SongInfo.Lower
	local song_name = song:GetDisplayFullTitle()
	local song_data = FindEcsSong(song_name, song_info)
	if song_data == nil then
		self:settext("Min Song Points:")
		return
	end
	self:settext("Min Song Points: " .. tostring(song_data.dp + song_data.ep + song_data.rp))
end

-- ECS Information
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:addx(-170):addy(-60)
		if ECS.Mode ~= "ECS" and ECS.Mode ~= "Marathon" then
			self:visible(false)
		end
	end,
	Def.Quad{
		InitCommand=function(self) self:diffuse(color("#000000AA")):zoomto(300, 80):addx(140):addy(20) end
	},
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:shadowlength(1):zoom(2):horizalign(left) end,
		OnCommand=function(self)
			local total_points = 0
			for i=1,7 do
				if ECS.Player.SongsPlayed[i] == nil then
					break
				end
				total_points = total_points + ECS.Player.SongsPlayed[i].points
			end
			self:settext("Total Set Points: " .. tostring(total_points))
		end
	},
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:shadowlength(1):zoom(2):addy(30):horizalign(left) end,
		OnCommand=SetSongPointText,
		CurrentSongChangedMessageCommand=SetSongPointText,
	}
}

return t
