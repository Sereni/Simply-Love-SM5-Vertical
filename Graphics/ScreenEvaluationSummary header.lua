local af = Def.ActorFrame{}

af[#af+1] = LoadActor( THEME:GetPathG("", "_header.lua") )

af[#af+1] = LoadFont("Common Header")..{
	Name="GameModeText",
	Text=THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode),
	InitCommand=function(self)
		self:diffusealpha(0):zoom( 0.3 ):xy(_screen.w-70, 7.5):halign(1)
		-- move the GameMode text further left if MenuTimer is enabled
		if not PREFSMAN:GetPreference("MenuTimer") then
			self:x(_screen.w - 10)
		end
	end,
	OnCommand=function(self)
		self:sleep(0.1):decelerate(0.33):diffusealpha(1)
	end
}

return af