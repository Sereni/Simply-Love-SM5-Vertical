local choices, choice_actors = {}, {}
local TopScreen = nil
-- give this a value now, before the TopScreen has been prepared and we can fetch its name
-- we'll reassign it appropriately below, once the TopScreen is available
local ScreenName = "ScreenSelectPlayMode"

-- we use this to determine where the cursor should move when selecting an option
-- it's a hackish way of making the localized strings for "regular" and "marathon" fill
-- the horizontal space under the big square in every language
-- we'll asign it a value below, once the TopScreen is available
local separation

local cursor = {
	h = 40,
	index = 0,
	-- the width of the cursor will be clamped to exist between these two values
	min_w = 80, max_w = 270,
}

-- the options in ScreenSelectPlayMode can have different sizes and the cursor should adapt
-- to them but in ScreenSelectPlayMode2 they just need to fill the horizontal space
local getCursorWidth = function(sn)
	if sn == "ScreenSelectPlayMode" then
		return clamp( choice_actors[cursor.index+1]:GetWidth()/1.4, cursor.min_w, cursor.max_w) +2 
	else
		return 160
	end
end

local Update = function(af, delta)
	local index = TopScreen:GetSelectionIndex( GAMESTATE:GetMasterPlayerNumber() )
	if index ~= cursor.index then
		cursor.index = index

		-- queue the appropiate command to the faux playfield, if needed
		if choices[cursor.index+1] == "Marathon" or choices[cursor.index+1] == "Regular" then
			af:queuecommand("FirstLoop"..choices[cursor.index+1])
		end

		-- queue an "Update" to the AF containing the cursor, description text, score, and lifemeter actors
		-- since they are children of that AF, they will also listen for that command
		af:queuecommand("Update")
	end
end

local t = Def.ActorFrame{
	InitCommand=function(self)
		self:SetUpdateFunction( Update )
			:xy(_screen.cx, _screen.cy)
			:zoom(0.75)
	end,
	OnCommand=function(self)
		-- Get the Topscreen and its name, now that that TopScreen itself actually exists
		TopScreen = SCREENMAN:GetTopScreen()
		ScreenName = TopScreen:GetName()

		-- now that we have the TopScreen's name, get the single string containing this
		-- screen's choices from Metrics.ini, and split it on commas; store those choices
		-- in the choices table, and do similarly with actors associated with those choices
		for choice in THEME:GetMetric(ScreenName, "ChoiceNames"):gmatch('([^,]+)') do
			choices[#choices+1] = choice
			choice_actors[#choice_actors+1] = TopScreen:GetChild("IconChoice"..choice)
		end

		-- also get the separation between the different options
		if ScreenName == "ScreenSelectPlayMode" then
			separation = 78
		else
			separation = 140
		end

		self:queuecommand("Update")
	end,
	OffCommand=function(self)
		if ScreenName=="ScreenSelectPlayMode" or ScreenName=="ScreenSelectPlayModeThonk" then
			-- set the GameMode now; we'll use it throughout the theme
			-- to set certain Gameplay settings and determine which screen comes next
			SL.Global.GameMode = choices[cursor.index+1]
			-- now that a GameMode has been selected, set related preferences
			SetGameModePreferences()
			-- and reload the theme's Metrics
			THEME:ReloadMetrics()
		end
	end,

	-- side mask
	Def.Quad{
		InitCommand=function(self) self:zoomto(450, 450):diffuse(1,1,1,1):x(375):MaskSource() end
	},
	-- lower mask
	Def.Quad{
		InitCommand=function(self) self:zoomto(450, 450):diffuse(1,1,1,1):xy(74,305):MaskSource() end
	},

	-- gray backgrounds
	Def.ActorFrame{
		InitCommand=function(self) self:y(80) end,
		-- ScreenSelectPlayMode
		Def.Quad{
			OnCommand=function(self) if ScreenName == "ScreenSelectPlayMode2" then self:visible(false) end end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomto(76,80):x(-111) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.1):diffusealpha(0) end
		},
		Def.Quad{
			OnCommand=function(self) if ScreenName == "ScreenSelectPlayMode2" then self:visible(false) end end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomto(77,80):x(-32) end,
			OffCommand=function(self) self:sleep(0.3):linear(0.1):diffusealpha(0) end
		},
		-- ScreenSelectPlayMode2
		Def.Quad{
			OnCommand=function(self) if ScreenName ~= "ScreenSelectPlayMode2" then self:visible(false) end end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomto(137,80):x(-80) end,
			OffCommand=function(self) self:sleep(0.3):linear(0.1):diffusealpha(0) end
		},
		Def.Quad{
			OnCommand=function(self) if ScreenName ~= "ScreenSelectPlayMode2" then self:visible(false) end end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomto(168,80):x(66) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.1):diffusealpha(0) end
		},
	},

	-- border
	Def.Quad{
		InitCommand=function(self) self:zoomto(302, 162):diffuse(1,1,1,1) end,
		OffCommand=function(self) self:sleep(0.6):linear(0.2):cropleft(1) end
	},
	-- background
	Def.Quad{
		InitCommand=function(self) self:zoomto(300, 160):diffuse(0,0,0,1) end,
		OffCommand=function(self) self:sleep(0.6):linear(0.2):cropleft(1) end
	},


	-- description
	Def.BitmapText{
		Font="Common Normal",
		InitCommand=function(self)
			self:zoom(0.625):halign(0):valign(0):xy(-130,-60)
		end,
		UpdateCommand=function(self)
			self:settext( THEME:GetString("ScreenSelectPlayMode", choices[cursor.index+1] .. "Description") )
		end,
		OffCommand=function(self) self:sleep(0.4):linear(0.2):diffusealpha(0) end
	},

	-- cursor to highlight the current choice
	Def.ActorFrame{
		Name="Cursor",
		OnCommand=function(self)
			-- it is possible for players to have something other than "Casual" as the default choice
			-- for ScreenSelectPlayMode (see: Simply Love Options in the Operator Menu)
			-- account for that here, in the OnCommand of the cursor ActorFrame, by updating cursor.index
			-- to match the value of ThemePrefs.Get("DefaultGameMode") in the choices table
			if ScreenName == "ScreenSelectPlayMode" then
				cursor.index = (FindInTable(ThemePrefs.Get("DefaultGameMode"), choices) or 1) - 1
			end
			self:x( -150 + (cursor.max_w * cursor.index) ):y(100)
		end,
		UpdateCommand=function(self)
			self:stoptweening():linear(0.1)
				:x( -150 + ( separation * cursor.index ))
		end,

		Def.Quad{
			InitCommand=function(self) self:zoomtoheight(cursor.h):diffuse(1,1,1,1):x(-1):y(1):halign(0) end,
			UpdateCommand=function(self) self:zoomtowidth( getCursorWidth(ScreenName) +2 ) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.2):cropleft(1) end
		},
		Def.Quad{
			InitCommand=function(self) self:zoomtoheight(cursor.h):diffuse(0,0,0,1):halign(0) end,
			UpdateCommand=function(self) self:zoomtowidth( getCursorWidth(ScreenName) ) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.2):cropleft(1) end
		}
	},

	-- Score
	Def.BitmapText{
		Font="_wendy monospace numbers",
		InitCommand=function(self)
			self:zoom(0.225):xy(124,-68):diffusealpha(0)
		end,
		OffCommand=function(self) self:sleep(0.4):linear(0.2):diffusealpha(0) end,
		UpdateCommand=function(self)
			if ScreenName == "ScreenSelectPlayMode" then
				if choices[cursor.index+1] == "Casual" then
					self:stoptweening():linear(0.25):diffusealpha(0)
				else
					if choices[cursor.index+1] == "FA+" then
						self:settext("99.50")
					else
						self:settext("77.41")
					end
					self:stoptweening():linear(0.25):diffusealpha(1)
				end
			else
				self:diffusealpha(1)
				if SL.Global.GameMode == "FA+" then
					self:settext("99.50")
				else
					self:settext("77.41")
				end
			end
		end,

	},
	-- LifeMeter
	Def.ActorFrame{
		Name="LifeMeter",
		InitCommand=function(self) self:diffusealpha(0) end,
		OffCommand=function(self) self:sleep(0.4):linear(0.2):diffusealpha(0) end,
		UpdateCommand=function(self)
			if ScreenName == "ScreenSelectPlayMode" then
				if choices[cursor.index+1] == "ITG" or choices[cursor.index+1] == "FA+" then
					self:stoptweening():linear(0.25):diffusealpha(1)
				else
					self:stoptweening():linear(0.25):diffusealpha(0)
				end
			else
				if SL.Global.GameMode == "StomperZ" then
					self:diffusealpha(0)
				else
					self:diffusealpha(1)
				end
			end
		end,
		-- lifemeter white border
		Def.Quad{
			InitCommand=function(self) self:zoomto(60,16):xy(68,-64) end
		},
		-- lifemeter black bg
		Def.Quad{
			InitCommand=function(self) self:zoomto(58,14):xy(68,-64):diffuse(0,0,0,1) end
		},
		-- lifemeter colored quad
		Def.Quad{
			InitCommand=function(self) self:zoomto(40,14):xy(59,-64):diffuse( GetCurrentColor() ) end
		},
		-- life meter animated swoosh
		LoadActor(THEME:GetPathB("ScreenGameplay", "underlay/PerPlayer/LifeMeter/swoosh.png"))..{
			InitCommand=function(self) self:zoomto(40,14):diffusealpha(0.45):xy(59,-64) end,
			OnCommand=function(self)
				self:customtexturerect(0,0,1,1):texcoordvelocity(-2,0)
			end,
		},
	},
	--StomperZLifeMeter
	Def.ActorFrame{
		Name="StomperZLifeMeter",
		InitCommand=function(self) self:diffusealpha(0) end,
		OffCommand=function(self) self:sleep(0.4):linear(0.2):diffusealpha(0) end,
		UpdateCommand=function(self)
			if ScreenName == "ScreenSelectPlayMode" then
				if choices[cursor.index+1] == "StomperZ" then
					self:stoptweening():linear(0.25):diffusealpha(1)
				else
					self:stoptweening():linear(0.25):diffusealpha(0)
				end
			else
				if SL.Global.GameMode == "StomperZ" then
					self:diffusealpha(1)
				end
			end
		end,
		LoadActor(THEME:GetPathG("", "Triangles.png"))..{
			InitCommand=function(self) self:zoom(0.25):xy(200,10) end,
			OnCommand=function(self)
				self:MaskDest()
			end,
		},
		-- StomperZLifeMeter left
		Def.Quad{
			InitCommand=function(self) self:zoomto(24,160):xy(50,28):diffuse(1,0,1,0.75):MaskDest():faderight(1) end,
			OnCommand=function(self) self:diffuseshift():effectcolor1(1,0,1,0.75):effectcolor2(1,0,1,0.45) end
		},
		-- StomperZLifeMeter right
		Def.Quad{
			InitCommand=function(self) self:zoomto(24,160):xy(140,28):diffuse(1,0,1,0.75):MaskDest():fadeleft(1) end,
			OnCommand=function(self) self:diffuseshift():effectcolor1(1,0,1,0.75):effectcolor2(1,0,1,0.45) end
		},
	}
}

t[#t+1] = LoadActor("./GameplayDemo.lua" )

return t
