local num_rows    = 5
local num_columns = 20
local GridZoomX = 0.39
local RowHeight = 14
local StepsToDisplay, SongOrCourse, StepsOrTrails
local quadHeight = 75
local quadWidth = 125

local GetStepsToDisplay = LoadActor("./StepsToDisplay.lua")

local t = Def.ActorFrame{
	Name="StepsDisplayList",
	InitCommand=function(self) self:vertalign(top):xy(quadWidth/2, _screen.cy) end,
	-- - - - - - - - - - - - - -

	OnCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,
	CurrentSongChangedMessageCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,
	CurrentCourseChangedMessageCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,
	StepsHaveChangedCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,

	-- - - - - - - - - - - - - -

	RedrawStepsDisplayCommand=function(self)

		SongOrCourse = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()

		if SongOrCourse then
			StepsOrTrails = (GAMESTATE:IsCourseMode() and SongOrCourse:GetAllTrails()) or SongUtil.GetPlayableSteps( SongOrCourse )

			if StepsOrTrails then

				StepsToDisplay = GetStepsToDisplay(StepsOrTrails)

				for RowNumber=1,num_rows do
					chart = StepsToDisplay[RowNumber]
					if chart then
						-- if this particular song has a stepchart for this row, update the Meter
						local meter = chart:GetMeter()
						local difficulty = chart:GetDifficulty()
						self:GetChild("Grid"):GetChild("Meter_"..RowNumber):playcommand("Set", {Meter=meter, Difficulty=difficulty})
						self:GetChild("Grid"):GetChild("StepArtist_"..RowNumber):playcommand("Set", {Chart=chart})
					else
						-- otherwise, set the meter to an empty string
						self:GetChild("Grid"):GetChild("Meter_"..RowNumber):playcommand("Unset")
						self:GetChild("Grid"):GetChild("StepArtist_"..RowNumber):playcommand("Unset")
					end
				end
			end
		else
			StepsOrTrails, StepsToDisplay = nil, nil
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
			-- Display stepartist name.
			-- TODO: Display other available chart data.
			stepartist = params.Chart:GetAuthorCredit()
			self:settext(stepartist)
			DiffuseEmojis(self, stepartist)
		end,
		UnsetCommand=function(self)
			self:settext("")
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
