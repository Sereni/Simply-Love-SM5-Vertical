local player, controller = unpack(...)

local pn = ToEnumShortString(player)
local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

local tns_string = "TapNoteScore" .. (SL.Global.GameMode=="ITG" and "" or SL.Global.GameMode)

local firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

local GetTNSStringFromTheme = function( arg )
	return THEME:GetString(tns_string, arg)
end

--Values above 0 means the user wants to be shown or told they are nice.
local nice = ThemePrefs.Get("nice") > 0

-- iterating through the TapNoteScore enum directly isn't helpful because the
-- sequencing is strange, so make our own data structures for this purpose
local TapNoteScores = {}
TapNoteScores.Types = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' }
TapNoteScores.Names = map(GetTNSStringFromTheme, TapNoteScores.Types)

local RadarCategories = {
	THEME:GetString("ScreenEvaluation", 'Holds'),
	THEME:GetString("ScreenEvaluation", 'Mines'),
	THEME:GetString("ScreenEvaluation", 'Hands'),
	THEME:GetString("ScreenEvaluation", 'Rolls')
}

local EnglishRadarCategories = {
	[THEME:GetString("ScreenEvaluation", 'Holds')] = "Holds",
	[THEME:GetString("ScreenEvaluation", 'Mines')] = "Mines",
	[THEME:GetString("ScreenEvaluation", 'Hands')] = "Hands",
	[THEME:GetString("ScreenEvaluation", 'Rolls')] = "Rolls",
}

local scores_table = {}
for index, window in ipairs(TapNoteScores.Types) do
	local number = stats:GetTapNoteScores( "TapNoteScore_"..window )
	scores_table[window] = number
end

local t = Def.ActorFrame{
	InitCommand=cmd(zoom, 0.7),
	OnCommand=function(self)
	end
}

local windows = SL.Global.ActiveModifiers.TimingWindows

--  labels: W1, W2, W3, W4, W5, Miss
for i=1, #TapNoteScores.Types do
	-- no need to add BitmapText actors for TimingWindows that were turned off
	if windows[i] or i==#TapNoteScores.Types then

		t[#t+1] = LoadFont("Common Normal")..{
			Text=TapNoteScores.Names[i]:upper(),
			InitCommand=function(self) self:zoom(0.833):horizalign(right):maxwidth(76) end,
			BeginCommand=function(self)
				self:y((i-1)*28)

				-- diffuse the JudgmentLabels the appropriate colors for the current GameMode
				self:diffuse( SL.JudgmentColors[SL.Global.GameMode][i] )
			end
		}
	end
end

-- labels: holds, mines, hands, rolls
for index, label in ipairs(RadarCategories) do

	local performance = stats:GetRadarActual():GetValue( "RadarCategory_"..firstToUpper(EnglishRadarCategories[label]) )
	local possible = stats:GetRadarPossible():GetValue( "RadarCategory_"..firstToUpper(EnglishRadarCategories[label]) )

	t[#t+1] = LoadFont("Common Normal")..{
		Text=label,
		InitCommand=function(self) self:zoom(0.833):horizalign(right) end,
		BeginCommand=function(self)
			self:x( -172 )
			self:y((index-1)*28 + 54)
		end
	}
end

return t
