local choices, choice_actors, choice_positions, choice_widths = {}, {}, {}, {}
local TopScreen = nil
-- give this a value now, before the TopScreen has been prepared and we can fetch its name
-- we'll reassign it appropriately below, once the TopScreen is available
local ScreenName = "ScreenSelectPlayMode"

local cursor = {
	h = 30,
	index = 0,
}

-- the width of the choice_actors multiplied by 0.386 gives us aproximately the width of the text icons
-- we add 30 to have a pretty margin around it
local iconWidthScale = 0.386
local cursorMargin = 30

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
			-- changing the position of this actorframe moves everything on this screen except for the
			-- option icons. The position for those is in metrics.ini
			:xy(_screen.cx, _screen.cy - 14)
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
			choice_positions[#choice_positions+1] = THEME:GetMetric(ScreenName, "IconChoice"..choice.."X") - _screen.w/2
			choice_widths[#choice_widths+1] = choice_actors[#choice_actors]:GetWidth()
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
	PlayerJoinedMessageCommand=function(self, params)
		UnjoinLateJoinedPlayer(params.Player)
	end,

	-- lower mask
	Def.Quad{
		InitCommand=function(self) self:zoomto(338, 338):diffuse(1,1,1,1):xy(74,229):MaskSource() end
	},

	-- gray backgrounds
	Def.ActorFrame{
		InitCommand=function(self) self:y(75) end,
		-- ScreenSelectPlayMode
		Def.Quad{
			OnCommand=function(self)
				self:x(choice_positions[1]):zoomtowidth(choice_widths[1] * iconWidthScale + cursorMargin)
				if ScreenName ~= "ScreenSelectPlayMode" then self:visible(false) end
			end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomtoheight(cursor.h) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.1):diffusealpha(0) end
		},
		Def.Quad{
			OnCommand=function(self)
				self:x(choice_positions[2]):zoomtowidth(choice_widths[2] * iconWidthScale + cursorMargin)
				if ScreenName ~= "ScreenSelectPlayMode" then self:visible(false) end
			end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomtoheight(cursor.h) end,
			OffCommand=function(self) self:sleep(0.3):linear(0.1):diffusealpha(0) end
		},
		-- ScreenSelectPlayMode2
		Def.Quad{
			OnCommand=function(self)
				self:x(choice_positions[1]):zoomtowidth(choice_widths[1] * iconWidthScale + cursorMargin)
				if ScreenName ~= "ScreenSelectPlayMode2" then self:visible(false) end
			end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomtoheight(cursor.h) end,
			OffCommand=function(self) self:sleep(0.3):linear(0.1):diffusealpha(0) end
		},
		Def.Quad{
			OnCommand=function(self)
				self:x(choice_positions[2]):zoomtowidth(choice_widths[2] * iconWidthScale + cursorMargin)
				if ScreenName ~= "ScreenSelectPlayMode2" then self:visible(false) end
			end,
			InitCommand=function(self) self:diffuse(0.2,0.2,0.2,1):zoomtoheight(cursor.h) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.1):diffusealpha(0) end
		},
	},

	-- border
	Def.Quad{
		InitCommand=function(self) self:zoomto(227, 122):diffuse(1,1,1,1) end,
		OffCommand=function(self) self:sleep(0.6):linear(0.2):cropleft(1) end
	},
	-- background
	Def.Quad{
		InitCommand=function(self) self:zoomto(225, 120):diffuse(0,0,0,1) end,
		OffCommand=function(self) self:sleep(0.6):linear(0.2):cropleft(1) end
	},


	-- description
	Def.BitmapText{
		Font="Common Normal",
		InitCommand=function(self)
			self:zoom(0.5):halign(0):valign(0):xy(-95,-40)
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
			self:x( choice_positions[cursor.index+1] ):y(75)
		end,
		UpdateCommand=function(self)
			cursor.w = choice_widths[cursor.index+1] * iconWidthScale + cursorMargin
			self:stoptweening():linear(0.1)
				:x( choice_positions[cursor.index+1] )
		end,

		Def.Quad{
			InitCommand=function(self) self:zoomtoheight(cursor.h):diffuse(1,1,1,1):y(1) end,
			UpdateCommand=function(self) self:zoomtowidth( cursor.w +2 ) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.2):cropleft(1) end
		},
		Def.Quad{
			InitCommand=function(self) self:zoomtoheight(cursor.h):diffuse(0,0,0,1) end,
			UpdateCommand=function(self) self:zoomtowidth( cursor.w ) end,
			OffCommand=function(self) self:sleep(0.4):linear(0.2):cropleft(1) end
		}
	},

	-- Score
	Def.BitmapText{
		Font="_wendy monospace numbers",
		InitCommand=function(self)
			self:zoom(0.17):xy(93,-51):diffusealpha(0)
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
		InitCommand=function(self) self:diffusealpha(0):xy(51,-48):zoom(0.75) end,
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
			InitCommand=function(self) self:zoomto(60,16) end
		},
		-- lifemeter black bg
		Def.Quad{
			InitCommand=function(self) self:zoomto(58,14):diffuse(0,0,0,1) end
		},
		-- lifemeter colored quad
		Def.Quad{
			InitCommand=function(self) self:zoomto(40,14):x(-9):diffuse( GetCurrentColor() ) end
		},
		-- life meter animated swoosh
		LoadActor(THEME:GetPathB("ScreenGameplay", "underlay/PerPlayer/LifeMeter/swoosh.png"))..{
			InitCommand=function(self) self:zoomto(40,14):diffusealpha(0.45):x(-9) end,
			OnCommand=function(self)
				self:customtexturerect(0,0,1,1):texcoordvelocity(-2,0)
			end,
		},
	},
}

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self) self:zoom(0.75) end,
	LoadActor("./GameplayDemo.lua"),
}

return t
