-- Cancelling out of ScreenGameplay will run this so we need to check if the offset changed
-- during gameplay and update the default value. (See Scripts/SL-Helpers.lua)
UpdateDefaultGlobalOffset()

local t = Def.ActorFrame{
	-- GameplayReloadCheck is a kludgy global variable used in ScreenGameplay in.lua to check
	-- if ScreenGameplay is being entered "properly" or being reloaded by a scripted mod-chart.
	-- If we're here in SelectMusic, set GameplayReloadCheck to false, signifying that the next
	-- time ScreenGameplay loads, it should have a properly animated entrance.
	InitCommand=function(self) SL.Global.GameplayReloadCheck = false end,

	OnCommand=function(self)
		-- Protect ring functions differently for ECS, but no reason not to always set fail type appropriately.
		local player_state = GAMESTATE:GetPlayerState(GAMESTATE:GetMasterPlayerNumber())
		if player_state then
			local po = player_state:GetPlayerOptions("ModsLevel_Preferred")
			if po then
				if ECS.Mode == "ECS" or ECS.Mode == "Marathon" then
					po:FailSetting('FailType_Immediate')
				else
					po:FailSetting('FailType_ImmediateContinue')
				end
			end
		end
	end,
	ChangeStepsMessageCommand=function(self, params)
		self:playcommand("StepsHaveChanged", params)
	end,

	PlayerJoinedMessageCommand=function(self, params)
		UnjoinLateJoinedPlayer(params.Player)
	end,

	-- ---------------------------------------------------
	--  first, load files that contain no visual elements, just code that needs to run

	-- MenuButton code for backing out of SelectMusic when in EventMode
	LoadActor("./EscapeFromEventMode.lua"),
	-- MenuTimer code for preserving SSM's timer value
	LoadActor("./MenuTimer.lua"),
	-- Apply player modifiers from profile
	LoadActor("./PlayerModifiers.lua"),
	-- Song Search (activated with Up/MenuUp+start)
	LoadActor("./SongSearch.lua"),

	-- ---------------------------------------------------
	-- next, load visual elements; the order of the layers matters for most of these

	-- make the MusicWheel appear to cascade down; this should draw underneath P2's PaneDisplay
	LoadActor("./MusicWheelAnimation.lua"),

	-- elements we need two of (one for each player) that draw underneath the StepsDisplayList
	-- this includes the stepartist boxes and the PaneDisplays (number of steps, jumps, holds, etc.)
	LoadActor("./PerPlayer/Under.lua"),
	-- grid of Difficulty Blocks (normal) or CourseContentsList (CourseMode)
	LoadActor("./StepsDisplayList/default.lua"),

	-- Graphical Banner
	LoadActor("./Banner.lua"),
	-- Song Artist, BPM, Duration (Referred to in other themes as "PaneDisplay")
	LoadActor("./SongDescription.lua"),
	-- Density Graph
	LoadActor("./DensityGraph.lua"),

	-- ---------------------------------------------------
	-- finally, load the overlay used for sorting the MusicWheel (and more), hidden by default
	LoadActor("./SortMenu/default.lua"),
	-- a Test Input overlay can (maybe) be accessed from the SortMenu
	LoadActor("./TestInput.lua"),
	-- a yes/no prompt overlay for backing out of SelectMusic when in EventMode can be
	-- activated via "CodeEscapeFromEventMode" under [ScreenSelectMusic] in Metrics.ini
	LoadActor("./EscapeFromEventMode.lua"),
}

return t
