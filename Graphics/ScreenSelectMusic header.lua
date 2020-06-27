local bmt_actor
local DrawNinePanelPad = LoadActor( THEME:GetPathB("ScreenSelectStyle", "underlay/pad.lua") )

local Update = function(af, dt)
	local seconds = GetTimeSinceStart() - SL.Global.TimeAtSessionStart

	-- if this game session is less than 1 hour in duration so far
	if seconds < 3600 then
		bmt_actor:settext( SecondsToMMSS(seconds) )
	else
		bmt_actor:settext( SecondsToHHMMSS(seconds) )
	end
end

local GetDeltaString = function()
	delta = SL.Global.ActiveModifiers.GlobalOffsetDelta * 1000
	form = delta > 0 and "+%d ms" or "%d ms"
	str = string.format(form, delta):gsub("^0.*", "")
	return str
end

local af = Def.ActorFrame{ OffCommand=function(self) self:linear(0.1):diffusealpha(0) end }

-- only add this InitCommand to the main ActorFrame in EventMode
if PREFSMAN:GetPreference("EventMode") then
	af.InitCommand=function(self)
		-- TimeAtSessionStart will be reset to nil between game sessions
		-- thus, if it's currently nil, we're loading ScreenSelectMusic
		-- for the first time this particular game session
		if SL.Global.TimeAtSessionStart == nil then
			SL.Global.TimeAtSessionStart = GetTimeSinceStart()
		end

		self:SetUpdateFunction( Update )
	end
end


-- generic header elements (background Def.Quad, left-aligned screen name)
af[#af+1] = LoadActor( THEME:GetPathG("", "_header.lua") )

-- centered text
-- session timer in EventMode
if PREFSMAN:GetPreference("EventMode") then

	af[#af+1] = LoadFont("_wendy monospace numbers")..{
		Name="Session Timer",
		InitCommand=function(self)
			bmt_actor = self
			self:diffusealpha(0):zoom(0.2):horizalign(left):xy(10, 4.5)
		end,
		OnCommand=function(self)
			self:sleep(0.1):decelerate(0.33):diffusealpha(1)
		end,
	}

-- stage number when not EventMode
else

	af[#af+1] = LoadFont("_wendy small")..{
		Name="Stage Number",
		Text=SSM_Header_StageText(),
		InitCommand=function(self)
			self:diffusealpha(0):zoom( 0.2 ):xy(_screen.cx, 4.5)
		end,
		OnCommand=function(self)
			self:sleep(0.1):decelerate(0.33):diffusealpha(1)
		end,
	}
end

-- "ITG" or "FA+"; aligned to right of screen
af[#af+1] = LoadFont("_wendy small")..{
	Name="GameModeText",
	Text=THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode),
	InitCommand=function(self)
		local x = _screen.w - 20

		-- move the GameMode text further left if MenuTimer is enabled
		if PREFSMAN:GetPreference("MenuTimer") then
			x = x - 60
		end

		self:diffusealpha(0):zoom(0.3):xy(x, 7.5):halign(1)
	end,
	OnCommand=function(self)
		self:settext(THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode))
			:sleep(0.1):decelerate(0.33):diffusealpha(1)
	end,
	SLGameModeChangedMessageCommand=function(self)
		self:settext(THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode))
	end
}

-- Pad image
af[#af+1] = DrawNinePanelPad()..{
	InitCommand=function(self)
		local x = _screen.w - 10

		-- move the GameMode text further left if MenuTimer is enabled
		if PREFSMAN:GetPreference("MenuTimer") then
			x = x - 60
		end

		self:zoom(0.24):xy(x, 12):halign(1)

		self:playcommand("Set", {Player=GAMESTATE:GetMasterPlayerNumber()})
	end,
	PlayerJoinedMessageCommand=function(self, params)
		self:playcommand("Set", {Player=params.Player})
	end
}

af[#af+1] = LoadFont("_wendy small")..{
	Name="CustomGlobalOffset",
	InitCommand=function(self)
		self:diffusealpha(0):zoom(0.3):xy(_screen.cx+10, 8)
	end,
	OnCommand=function(self)
		self:settext(GetDeltaString())
			:sleep(0.1):decelerate(0.33):diffusealpha(1)
	end,
	GlobalOffsetChangedMessageCommand=function(self)
		self:settext(GetDeltaString())
	end
}

return af
