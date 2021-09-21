-- assume that all human players failed
local img = "failed text.png"

local ApplyRelicActions = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		active_relic.action(ECS.Player.Relics)
	end
end

-- loop through all available human players
for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	-- if any of them passed, we want to display the "cleared" graphic
	if not STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetFailed() then
		img = "cleared text.png"
	end
end

return Def.ActorFrame {
	OnCommand=function(self) ApplyRelicActions() end,
	OffCommand=function(self)
		-- always undo the effects of Astral Ring/Astral Earring when leaving ScreenEval, even if they weren't active
		SL.Global.ActiveModifiers.TimingWindows = {true,true,true,true,true}
		PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW4)
		PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW5)

		-- always undo the effects of any relics that change LifeDifficulty when leaving ScreenEval, even if they weren't active
		PREFSMAN:SetPreference("LifeDifficultyScale", 1)
	end,
	Def.Quad{
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end,
		OnCommand=function(self) self:sleep(0.2):linear(0.5):diffusealpha(0) end,
	},

	LoadActor(img)..{
		InitCommand=function(self) self:Center():zoom(0.35):diffusealpha(0) end,
		OnCommand=function(self) self:accelerate(0.4):diffusealpha(1):sleep(0.6):decelerate(0.4):diffusealpha(0) end
	}
}
