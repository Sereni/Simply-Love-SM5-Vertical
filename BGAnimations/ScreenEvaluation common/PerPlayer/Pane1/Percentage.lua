local player = ...

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")

return Def.ActorFrame{
	Name="PercentageContainer"..ToEnumShortString(player),
	OnCommand=function(self)
		self:y( 5 )
		self:x( -101 )
	end,

	-- dark background quad behind player percent score
	Def.Quad{
		InitCommand=cmd(diffuse, color("#101519"); zoomto, 102,40)
	},

	LoadFont("_wendy white")..{
		Name="Percent",
		Text = percent,
		InitCommand=cmd(vertalign, middle; horizalign, right; zoom, 0.38),
		OnCommand=cmd(x, 45)
	}
}
