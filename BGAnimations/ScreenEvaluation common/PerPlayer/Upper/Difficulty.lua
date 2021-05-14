local player = ...
local text_table = GetStepsCredit(player)
local marquee_index = 0

local y_offset_name = -65
local x_offset_name = -79.5
local y_offset_stepartist = y_offset_name - 12
local y_offset_number = y_offset_name - 6
local x_offset_number = x_offset_name - 15
local text_size = 0.55

return Def.ActorFrame{

	-- difficulty text ("beginner" or "expert" or etc.)
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:y(_screen.cy + y_offset_name)
			self:x(x_offset_name)
			self:horizalign(left):zoom(text_size)
			-- darken the text for RainbowMode to make it more legible
			local textColor = Color.White
			local shadowLength = 0
			if ThemePrefs.Get("RainbowMode") and not HolidayCheer() then
				textColor = Color.Black
			end
			if ThemePrefs.Get("VisualStyle") == "SRPG5" then
				textColor = color(SL.SRPG5.TextColor)
				shadowLength = 0.4
			end

			self:diffuse(textColor)
			self:shadowlength(shadowLength)

			local style = GAMESTATE:GetCurrentStyle():GetName()
			if style == "versus" then style = "single" end
			style =  THEME:GetString("ScreenSelectMusic", style:gsub("^%l", string.upper))

			local steps = GAMESTATE:GetCurrentSteps(player)
			-- GetDifficulty() returns a value from the Difficulty Enum such as "Difficulty_Hard"
			-- ToEnumShortString() removes the characters up to and including the
			-- underscore, transforming a string like "Difficulty_Hard" into "Hard"
			local difficulty = ToEnumShortString( steps:GetDifficulty() )
			difficulty = THEME:GetString("Difficulty", difficulty)

			self:settext( style .. " / " .. difficulty )
		end
	},

	-- Stepartist name
  LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:x(x_offset_name)
			self:y(_screen.cy + y_offset_stepartist)
			self:horizalign(left)
			self:zoom(text_size)
		end,
		OnCommand=function(self)
			-- darken the text for RainbowMode to make it more legible
			if (ThemePrefs.Get("RainbowMode") and not HolidayCheer()) then self:diffuse(Color.Black) end
			if #text_table > 0 then self:playcommand("Marquee") end
		end,
		MarqueeCommand=function(self)
			-- increment the marquee_index, and keep it in bounds
			marquee_index = (marquee_index % #text_table) + 1
			-- retrieve the text we want to display
			local text = text_table[marquee_index]

			-- set this BitmapText actor to display that text
			self:settext( text )
			DiffuseEmojis(self, text)

			-- sleep 2 seconds before queueing the next Marquee command to do this again
			if #text_table > 1 then
				self:sleep(2):queuecommand("Marquee")
			end
		end,
		OffCommand=function(self) self:stoptweening() end
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
				self:diffuse( DifficultyColor(currentDifficulty), true )
			end
		end
	},

	-- numerical difficulty meter
	LoadFont("Common Bold")..{
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
