-- this difficulty grid doesn't support CourseMode
-- CourseContentsList.lua should be used instead
if GAMESTATE:IsCourseMode() then return end
-- ----------------------------------------------

local num_rows    = 5
local GridZoomX = 0.39
local RowHeight = 14
local StepsToDisplay, song, steps
local quadHeight = 75
local quadWidth = 125

local GetStepsToDisplay = LoadActor("./StepsToDisplay.lua")

local t = Def.ActorFrame{
	Name="StepsDisplayList",
	InitCommand=function(self) self:vertalign(top):xy(quadWidth/2, _screen.cy) end,

	OnCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,
	CurrentSongChangedMessageCommand=function(self)    self:queuecommand("RedrawStepsDisplay") end,
	CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,
	CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,

	RedrawStepsDisplayCommand=function(self)

		song = GAMESTATE:GetCurrentSong()

		if song then
			steps = SongUtil.GetPlayableSteps( song )

			if steps then
				StepsToDisplay = GetStepsToDisplay(steps)

				for i=1,num_rows do
					chart = StepsToDisplay[i]
					if chart then
						-- if this particular song has a stepchart for this row, update the Meter
						local meter = chart:GetMeter()
						local difficulty = chart:GetDifficulty()
						self:GetChild("Grid"):GetChild("Meter_"..i):playcommand("Set", {Meter=meter, Difficulty=difficulty})
						self:GetChild("Grid"):GetChild("StepArtist_"..i):playcommand("Set", {Chart=chart})
					else
						-- otherwise, set the meter to an empty string
						self:GetChild("Grid"):GetChild("Meter_"..i):playcommand("Unset")
						self:GetChild("Grid"):GetChild("StepArtist_"..i):playcommand("Unset")

					end
				end
			end
		else
			steps, StepsToDisplay = nil, nil
			self:playcommand("Unset")
		end
	end,

	-- - - - - - - - - - - - - -

	-- background
	Def.Quad{
		Name="Background",
		InitCommand=function(self)
			self:diffuse(color("#1e282f")):zoomto(quadWidth, quadHeight)
			if ThemePrefs.Get("RainbowMode") then
				self:diffusealpha(0.75)
			end
		end
	},

	Def.Quad{
		Name="Cursor",
		InitCommand=function(self)
			self:x(0)
			self:diffuse(color("#ffffff")):diffusealpha(0.3):zoomto(quadWidth, RowHeight)
		end,
		OnCommand=function(self) self:queuecommand("Set") end,
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end,
		CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Set") end,
		CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Set") end,

		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()

			if song then
				local player = GAMESTATE:GetMasterPlayerNumber()
				local allSteps = SongUtil.GetPlayableSteps(song)
				local stepsToDisplay = GetStepsToDisplay(allSteps)
				local currentSteps = GAMESTATE:GetCurrentSteps(player)

				for i,chart in pairs(stepsToDisplay) do
					if chart == currentSteps then
						RowIndex = i
						break
					end
				end
			end

			-- keep within reasonable limits because Edit charts are a thing
			RowIndex = clamp(RowIndex, 1, 5)

			-- update cursor y position
			local animationSpeed = self:GetVisible() and 0.1 or 0
			self:stoptweening():linear(animationSpeed):y(RowHeight * (RowIndex - 3))
			if song then self:visible(true) else self:visible(false) end
		end
	}
}


local Grid = Def.ActorFrame{
	Name="Grid",
	InitCommand=function(self) self:horizalign(left):vertalign(top):xy(8, -quadHeight/2-5) end,
}

for RowNumber=1,num_rows do

	Grid[#Grid+1] =	LoadFont("Common Normal")..{
		Name="StepArtist_"..RowNumber,

		OnCommand=function(self)
			self:y(RowNumber * RowHeight)
			self:x(-quadWidth/2+13)
			self:horizalign(left)
			self:maxwidth(195)
			self:zoom(0.5)
		end,
		SetCommand=function(self, params)
			player = GAMESTATE:GetMasterPlayerNumber()
			chart = params.Chart
			self:stoptweening()

			-- Display all available data for the selected chart
			if chart == GAMESTATE:GetCurrentSteps(player) then
				text_table = GetStepsCredit(player)
					marquee_index = 0
					-- only queue a marquee if there are things in the text_table to display
					if #text_table > 0 then
						self:queuecommand("Marquee")
					else
						self:settext("")
					end
				-- Only display stepartist for all other charts
				else
					stepartist = chart:GetAuthorCredit()
					self:settext(stepartist)
					DiffuseEmojis(self, stepartist)
				end
		end,
		UnsetCommand=function(self)
			self:stoptweening()
			self:settext("")
		end,
		MarqueeCommand=function(self)
			marquee_index = (marquee_index % #text_table) + 1
			-- retrieve the text we want to display
			local text = text_table[marquee_index]
			self:settext( text )
			DiffuseEmojis(self, text)

			-- sleep 2 seconds before queueing the next Marquee command to do this again
			if #text_table > 1 then
				self:sleep(2):queuecommand("Marquee")
			end
		end,
		OffCommand=function(self) self:stoptweening() end
	}

	Grid[#Grid+1] = LoadFont("_wendy small")..{
		Name="Meter_"..RowNumber,
		InitCommand=function(self)
			self:horizalign(right)
			self:y(RowNumber * RowHeight)
			self:x(-quadWidth/2+7)
			self:zoom(0.2)
		end,
		SetCommand=function(self, params)
			-- diffuse and set each chart's difficulty meter
			self:diffuse( DifficultyColor(params.Difficulty) )
			self:settext(params.Meter)
		end,
		UnsetCommand=function(self) self:settext(""):diffuse(color("#182025")) end,
	}
end

t[#t+1] = Grid

return t
