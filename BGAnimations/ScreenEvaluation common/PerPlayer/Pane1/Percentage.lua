local pn = ...

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")

return Def.ActorFrame{
	Name="PercentageContainer"..ToEnumShortString(pn),
	OnCommand=function(self)
		self:y( _screen.cy - 45 )
		self:x( -55 )
	end,

	-- dark background quad behind player percent score
	Def.Quad{
		InitCommand=cmd(diffuse, color("#101519"); zoomto, 100,40 )
	},

	LoadFont("_wendy white")..{
		-- Text=percent,
		Text="77.41",
		Name="Percent",
		InitCommand=cmd(vertalign, middle; horizalign, right; zoom,0.38 ),
		OnCommand=cmd(x, 45)
	}
}
