local banner_directory = { Hearts="Hearts", Arrows="Arrows" }
local set_banner_position = cmd(xy, _screen.cx, 105.5; setsize,418,164; zoom, 0.5 )

local af = Def.ActorFrame{

	-- quad behind the song/course title text
	Def.Quad{
		InitCommand=cmd(diffuse,color("#1E282F"); xy,_screen.cx, 54.5; zoomto, 209.5,20),
	},

	-- song/course title text
	LoadFont("_miso")..{
		InitCommand=cmd(xy,_screen.cx,54; maxwidth, 209; zoom, 0.8 ),
		OnCommand=function(self)
			local songtitle = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle()) or GAMESTATE:GetCurrentSong():GetDisplayFullTitle()

			if songtitle then
				self:settext(songtitle)
			end
		end
	}
}

local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()

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
		end,
		OnCommand=set_banner_position
	}
else
	--fallback banner
	af[#af+1] = LoadActor( THEME:GetPathB("ScreenSelectMusic", "overlay/colored_banners/" .. (banner_directory[ThemePrefs.Get("VisualTheme")] or "Hearts") .. "/banner" .. SL.Global.ActiveColorIndex .. " (doubleres).png"))..{
		InitCommand=set_banner_position
	}
end

return af