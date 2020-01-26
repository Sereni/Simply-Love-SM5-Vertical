local player = ...

local y_offset_name = -65
local x_offset_name = -79

local y_offset_number = y_offset_name - 5
local x_offset_number = x_offset_name - 15

return Def.ActorFrame{

	-- difficulty text ("beginner" or "expert" or etc.)
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:y(_screen.cy + y_offset_name)
			self:x(x_offset_name)
			self:horizalign(left):zoom(0.6)
			-- darken the text for RainbowMode to make it more legible
			if (ThemePrefs.Get("RainbowMode") and not HolidayCheer()) then self:diffuse(Color.Black) end

			local currentSteps = GAMESTATE:GetCurrentSteps(player)

			if currentSteps then
				local difficulty = currentSteps:GetDifficulty()
				-- GetDifficulty() returns a value from the Difficulty Enum
				-- "Difficulty_Hard" for example.
				-- Strip the characters up to and including the underscore.
				difficulty = ToEnumShortString(difficulty)
				self:settext( THEME:GetString("Difficulty", difficulty) )
			end
		end
	},

	-- colored square as the background for the difficulty meter
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(20,20)
			self:y( _screen.cy + y_offset_number)
			self:x(x_offset_number)

			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				local currentDifficulty = currentSteps:GetDifficulty()
				self:diffuse( DifficultyColor(currentDifficulty) )
			end
		end
	},

	-- numerical difficulty meter
	LoadFont("_wendy small")..{  -- TODO this should be offset together with the square that it's on ffs
		InitCommand=function(self)
			self:diffuse(Color.Black):zoom( 0.3 )
			self:y( _screen.cy + y_offset_number)
			self:x(x_offset_number)

			local meter
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(player)
				if trail then meter = trail:GetMeter() end
			else
				local steps = GAMESTATE:GetCurrentSteps(player)
				if steps then meter = steps:GetMeter() end
			end

			if meter then self:settext(meter) end
		end
	}
}
