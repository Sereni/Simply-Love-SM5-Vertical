local player = ...
local pn = ToEnumShortString(player)
local track_missbcheld = SL[pn].ActiveModifiers.MissBecauseHeld

-- a string representing the NoteSkin the player was using
local noteskin = GAMESTATE:GetPlayerState(player):GetCurrentPlayerOptions():NoteSkin()
-- NOTESKIN:LoadActorForNoteSkin() expects the noteskin name to be all lowercase(?)
-- so transform the string to be lowercase
noteskin = noteskin:lower()


local gmods = SL.Global.ActiveModifiers

-- -----------------------------------------------------------------------
local game  = GAMESTATE:GetCurrentGame():GetName()
local style = GAMESTATE:GetCurrentStyle()
local style_name = style:GetName()
local num_columns = style:ColumnsPerPlayer()

local rows = { "W1", "W2", "W3", "W4", "W5", "Miss" }
local cols = {}

local function ShouldDisplayJudgmentNumber(judgment)
	if not SL[pn].ActiveModifiers.DoNotJudgeMe then return true end
	-- Show judgments worse than Great to help debug pad errors.
	-- Hide others to reduce pressure.
	if judgment > 3 then return true end
	return false
end

-- loop num_columns number of time to fill the cols table with
-- info about each column for this game
-- each game (dance, pump, techno, etc.) and each style (single, double, routine, etc.)
-- within each game will have its own unique columns
for i=1,num_columns do
	table.insert(cols, style:GetColumnInfo(player, i))
end

local box_width = 140
local box_height = 96
local col_width  = box_width/num_columns
local row_height = box_height/#rows

-- -----------------------------------------------------------------------

local af = Def.ActorFrame{
	InitCommand=function(self) self:xy(-box_width/2 + 15, _screen.cy-38) end
}


for i, column in ipairs( cols ) do

	local _x = col_width * i

	-- Calculating column positioning like this in techno game and dance solor results
	-- in each column being ~10px too far left; this does not happen in other games that
	-- I've tested.  There's probably a cleaner fix involving scaling column.XOffset to
	-- fit within the bounds of box_width but this is easer for now.
	if game == "techno" or (game == "dance" and style_name == "solo") then
		_x = _x + 10
	end

	-- GetNoteSkinActor() is defined in ./Scripts/SL-Helpers.lua, and performs some
	-- rudimentary error handling because NoteSkins From The Internet™ may contain Lua errors
	af[#af+1] = LoadActor(THEME:GetPathB("","_modules/NoteSkinPreview.lua"), {noteskin_name=noteskin, column=column.Name})..{
		OnCommand=function(self)
			self:x( _x ):zoom(0.4):visible(true)
		end
	}

	local miss_bmt = nil

	-- for each possible judgment
	for j, judgment in ipairs(rows) do
		-- don't add rows for TimingWindows that were turned off, but always add Miss
		if gmods.TimingWindows[j] or j==#rows then
			local judgmentText
			if ShouldDisplayJudgmentNumber(j) then
				judgmentText=SL[pn].Stages.Stats[SL.Global.Stages.PlayedThisGame + 1].column_judgments[i][judgment]
			else
				judgmentText = "*"
			end
			-- add a BitmapText actor to be the number for this column
			af[#af+1] = LoadFont("Common Normal")..{
				Text=judgmentText,
				InitCommand=function(self)
					self:xy(_x, j*row_height + 4)
						:zoom(0.8)
					if j == #rows then miss_bmt = self end
				end
			}
		end
	end

	if track_missbcheld then
		-- the number of MissBecauseHeld judgments for this column
		af[#af+1] = LoadFont("Common Normal")..{
			Text=SL[pn].Stages.Stats[SL.Global.Stages.PlayedThisGame + 1].column_judgments[i].MissBecauseHeld,
			InitCommand=function(self)
				self:xy(_x - 1, 95):zoom(0.65):halign(1)
			end,
			OnCommand=function(self)
				self:x( self:GetX() - miss_bmt:GetWidth()/2 )
			end
		}
	end
end

return af