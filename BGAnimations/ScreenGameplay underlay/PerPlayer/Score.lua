local player = ...
local pn = ToEnumShortString(player)

local mods = SL[pn].ActiveModifiers
local IsUltraWide = (GetScreenAspectRatio() > 21/9)
local NumPlayers = #GAMESTATE:GetHumanPlayers()
-- -----------------------------------------------------------------------
-- first, check for conditions where we might not draw the score actor at all

if mods.HideScore then return end
if mods.DoNotJudgeMe then return end
if mods.NPSGraphAtTop then return end

if NumPlayers > 1
and mods.NPSGraphAtTop
and not IsUltraWide
then
	return
end

-- -----------------------------------------------------------------------
-- set up some preliminary variables and calculations for positioning and zooming

local styletype = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())

-- scores are not aligned symmetrically around screen.cx for aesthetic reasons
-- and this is the cause of many code-induced headaches
local pos = {
	[PLAYER_1] = { x=(_screen.cx - clamp(_screen.w, 640, 854)/4.3),  y=56 },
	[PLAYER_2] = { x=(_screen.cx + clamp(_screen.w, 640, 854)/2.75), y=56 },
}

local dance_points, percent
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local StepsOrTrail = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player)) or GAMESTATE:GetCurrentSteps(player)
local total_tapnotes = StepsOrTrail:GetRadarValues(player):GetValue( "RadarCategory_Notes" )

-- determine how many digits are needed to express the number of notes in base-10
local digits = (math.floor(math.log10(total_tapnotes)) + 1)
-- subtract 4 from the digit count; we're only really interested in how many digits past 4
-- this stepcount is so we can use it to align the score actor in the StepStats pane if needed
-- aligned-with-4-digits is the default
digits = clamp(math.max(4, digits) - 4, 0, 3)

local NoteFieldIsCentered = (GetNotefieldX(player) == _screen.cx)

local ar_scale = {
	sixteen_ten  = 0.825,
	sixteen_nine = 1
}
local zoom_factor = clamp(scale(GetScreenAspectRatio(), 16/10, 16/9, ar_scale.sixteen_ten, ar_scale.sixteen_nine), 0, 1.125)

-- -----------------------------------------------------------------------

return LoadFont("Wendy/_wendy monospace numbers")..{
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
