-- per-player upper half of ScreenEvaluation

local player = ...

return Def.ActorFrame{
	Name=ToEnumShortString(player).."_AF_Upper",
	OnCommand=function(self)
			self:x(_screen.cx)
	end,

	-- nice
	LoadActor("./nice.lua", player),

	-- difficulty text and meter
	LoadActor("./Difficulty.lua", player),

	-- Record Texts (Machine and/or Personal)
	LoadActor("./RecordTexts.lua", player)
}
