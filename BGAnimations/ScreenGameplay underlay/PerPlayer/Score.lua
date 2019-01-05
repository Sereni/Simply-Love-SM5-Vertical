local player = ...

if SL[ ToEnumShortString(player) ].ActiveModifiers.HideScore then return end

local dance_points, percent
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

return Def.BitmapText{
	Font="_wendy monospace numbers",
	Text="0.00",

	Name=ToEnumShortString(player).."Score",
	InitCommand=function(self)
		self:valign(1):halign(1)
                self:zoom(Positions.ScreenGameplay.ScoreZoom())
                self:x(Positions.ScreenGameplay.ScoreX(player))
                self:y(Positions.ScreenGameplay.ScoreY())
	end,
	JudgmentMessageCommand=function(self) self:queuecommand("RedrawScore") end,
	RedrawScoreCommand=function(self)
		dance_points = pss:GetPercentDancePoints()
		percent = FormatPercentScore( dance_points ):sub(1,-2)
		self:settext(percent)
	end
}