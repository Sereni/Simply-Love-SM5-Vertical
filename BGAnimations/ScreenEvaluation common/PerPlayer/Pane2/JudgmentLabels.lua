local player = ...
local pn = ToEnumShortString(player)
local track_missbcheld = SL[pn].ActiveModifiers.MissBecauseHeld

local TapNoteScores = { Types={'W1', 'W2', 'W3', 'W4', 'W5', 'Miss'}, Names={} }
local tns_string = "TapNoteScore" .. (SL.Global.GameMode=="ITG" and "" or SL.Global.GameMode)
-- get TNS names appropriate for the current GameMode, localized to the current language
for i, judgment in ipairs(TapNoteScores.Types) do
	TapNoteScores.Names[#TapNoteScores.Names+1] = THEME:GetString(tns_string, judgment)
end

local box_height = 96
local row_height = box_height/#TapNoteScores.Types

local t = Def.ActorFrame{
	InitCommand=function(self) self:xy(85, _screen.cy-34) end
}

local miss_bmt

local worst = SL.Global.ActiveModifiers.WorstTimingWindow

--  labels: W1 ---> Miss
for i=1, #TapNoteScores.Types do
	-- no need to add BitmapText actors for TimingWindows that were turned off
	if i <= worst or i==#TapNoteScores.Types then

		local window = TapNoteScores.Types[i]
		local label = TapNoteScores.Names[i]

		t[#t+1] = LoadFont("Common Normal")..{
			Text=label:upper(),
			InitCommand=function(self)
				self:zoom(0.6):horizalign(right):maxwidth(65/self:GetZoom())
					:x( -120 )
					:y( i * row_height )
					:diffuse( SL.JudgmentColors[SL.Global.GameMode][i] )

				if i == #TapNoteScores.Types then miss_bmt = self end
			end
		}
	end
end

if track_missbcheld then
	t[#t+1] = LoadFont("Common Normal")..{
		Text=ScreenString("Held"),
		InitCommand=function(self)
			self:y(92):zoom(0.45):halign(1)
				:diffuse( SL.JudgmentColors[SL.Global.GameMode][6] )
		end,
		OnCommand=function(self)
			self:x( miss_bmt:GetX() - miss_bmt:GetWidth()/1.5 )
		end
	}
end

return t
