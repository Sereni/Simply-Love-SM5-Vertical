local bmt_actor

local Update = function(af, dt)
	local seconds = GetTimeSinceStart() - SL.Global.TimeAtSessionStart

	-- if this game session is less than 1 hour in duration so far
	if seconds < 3600 then
		bmt_actor:settext( SecondsToMMSS(seconds) )
	else
		bmt_actor:settext( SecondsToHHMMSS(seconds) )
	end
end

local t = Def.ActorFrame{
	InitCommand=function(self)
		if PREFSMAN:GetPreference("EventMode") and SL.Global.GameMode ~= "Casual" then
			-- TimeAtSessionStart will be reset to nil between game sesssions
			-- thus, if it's currently nil, we're loading ScreenSelectMusic
			-- for the first time this particular game session
			if SL.Global.TimeAtSessionStart == nil then
				SL.Global.TimeAtSessionStart = GetTimeSinceStart()
			end

			self:SetUpdateFunction( Update )
		end
	end,
	OffCommand=function(self)
		local topscreen = SCREENMAN:GetTopScreen()
		if topscreen then
			if topscreen:GetName() == "ScreenEvaluationStage" or topscreen:GetName() == "ScreenEvaluationNonstop" then
				SL.Global.Stages.PlayedThisGame = SL.Global.Stages.PlayedThisGame + 1
			else
				self:linear(0.1)
				self:diffusealpha(0)
			end
		end
	end,

	LoadActor( THEME:GetPathG("", "_header.lua") ),

	Def.BitmapText{
		Font=PREFSMAN:GetPreference("EventMode") and "_wendy monospace numbers" or "_wendy small",
		Name="Stage Number",
		InitCommand=function(self)
			bmt_actor = self
			if PREFSMAN:GetPreference("EventMode") then
				self:diffusealpha(0):zoom( 0.2 ):horizalign(left):xy(10, 4.5)
			else
				self:diffusealpha(0):zoom( 0.2 ):xy(_screen.cx, 4.5)
			end
		end,
		OnCommand=function(self)
			if not PREFSMAN:GetPreference("EventMode") then
				self:settext( SSM_Header_StageText() )
			end

			self:sleep(0.1):decelerate(0.33):diffusealpha(1)
		end,
	},

	LoadFont("_wendy small")..{
		Name="GameModeText",
		InitCommand=function(self)
			self:diffusealpha(0):zoom( 0.3 ):xy(_screen.w-70, 7.5):halign(1)
			if not PREFSMAN:GetPreference("MenuTimer") then
				self:x(_screen.w-10)
			end
		end,
		OnCommand=function(self)
			self:settext(THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode))
				:sleep(0.1):decelerate(0.33):diffusealpha(1)
		end,
		UpdateHeaderTextCommand=function(self)
			self:settext(THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode))
		end
	}
}

t[#t+1] = LoadFont("_wendy small")..{
	Name="CustomGlobalOffset",
	InitCommand=function(self)
		self:diffusealpha(0):zoom( WideScale(0.5,0.6)):xy(_screen.w-170, 15):halign(1)
	end,
	OnCommand=function(self)
		self:settext(GetGlobalOffsetDiffString())
			:sleep(0.1):decelerate(0.33):diffusealpha(1)
	end,
	-- FIXME: Changing global offset via F11/12 will not trigger an update.
	GlobalOffsetChangedMessageCommand=function(self)
		self:settext(GetGlobalOffsetDiffString())
	end
}

return t
