local player = ...
local pn = ToEnumShortString(player)
local mods = SL[pn].ActiveModifiers
local center1p = PREFSMAN:GetPreference("Center1Player")

if mods.HideScore then return end
if mods.DoNotJudgeMe then return end

if #GAMESTATE:GetHumanPlayers() > 1
and mods.NPSGraphAtTop
and SL.Global.GameMode ~= "StomperZ"
then return end

if #GAMESTATE:GetHumanPlayers() == 1
and SL.Global.GameMode ~= "StomperZ"
and mods.NPSGraphAtTop
and mods.DataVisualizations ~= "Step Statistics"
and not center1p
then return end

local dance_points, percent
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

return LoadFont("_wendy monospace numbers")..{
	Text="0.00",

	Name=pn.."Score",
	InitCommand=function(self)
		self:valign(1):halign(1)
                self:zoom(0.3)
                self:x(_screen.w-6)
                self:y(40)
	end,
	JudgmentMessageCommand=function(self) self:queuecommand("RedrawScore") end,
	RedrawScoreCommand=function(self)
		dance_points = pss:GetPercentDancePoints()
		percent = FormatPercentScore( dance_points ):sub(1,-2)
		self:settext(percent)
	end
}
