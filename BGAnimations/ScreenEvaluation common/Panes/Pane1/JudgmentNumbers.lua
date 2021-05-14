local player, controller = unpack(...)

local pn = ToEnumShortString(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local TapNoteScores = {
	Types = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' },
	-- x values for P1 and P2
	x = { P1=0, P2=0 }
}

local RadarCategories = {
	Types = { 'Holds', 'Mines', 'Hands', 'Rolls' },
	-- x values for P1 and P2, offset relatively to TapNoteScores to fit judgment labels.
	x = { P1=-242, P2=-242 }
}


local t = Def.ActorFrame{
	InitCommand=function(self)self:zoom(0.56):x(50) end,
}

-- do "regular" TapNotes first
for i=1,#TapNoteScores.Types do
	local window = TapNoteScores.Types[i]
	local number = pss:GetTapNoteScores( "TapNoteScore_"..window )

	-- actual numbers
	t[#t+1] = Def.RollingNumbers{
		Font="Wendy/_ScreenEvaluation numbers",
		InitCommand=function(self)
			self:zoom(0.5):horizalign(right)

			if SL.Global.GameMode ~= "ITG" then
				self:diffuse( SL.JudgmentColors[SL.Global.GameMode][i] )
			end

			-- if some TimingWindows were turned off, the leading 0s should not
			-- be colored any differently than the (lack of) JudgmentNumber,
			-- so load a unique Metric group.
			local gmods = SL.Global.ActiveModifiers
			if gmods.TimingWindows[i]==false and i ~= #TapNoteScores.Types then
				self:Load("RollingNumbersEvaluationNoDecentsWayOffs")
				self:diffuse(color("#444444"))

			-- Otherwise, We want leading 0s to be dimmed, so load the Metrics
			-- group "RollingNumberEvaluationA"	which does that for us.
			else
				self:Load("RollingNumbersEvaluationA")
			end
		end,
		BeginCommand=function(self)
			self:x( TapNoteScores.x[ToEnumShortString(side)] )
			self:y((i-1)*35)
			self:targetnumber(number)
		end
	}

end

-- then handle holds, mines, hands, rolls
for index, RCType in ipairs(RadarCategories.Types) do

	local y_position = (index-1)*35 + 70
	local x_position = RadarCategories.x[pn]

	local performance = pss:GetRadarActual():GetValue( "RadarCategory_"..RCType )
	local possible = pss:GetRadarPossible():GetValue( "RadarCategory_"..RCType )
	possible = clamp(possible, 0, 999)

	-- player performance value
	-- use a RollingNumber to animate the count tallying up for visual effect
	t[#t+1] = Def.RollingNumbers{
		Font="Wendy/_ScreenEvaluation numbers",
		InitCommand=function(self) self:zoom(0.5):horizalign(right):Load("RollingNumbersEvaluationB") end,
		BeginCommand=function(self)
			self:y(y_position)
			self:x(x_position)
			self:targetnumber(performance)
		end
	}

	--  slash
	t[#t+1] = LoadFont("Common Normal")..{
		Text="/",
		InitCommand=function(self) self:diffuse(color("#5A6166")):zoom(1.25):horizalign(right) end,
		BeginCommand=function(self)
			self:y(y_position)
			self:x(x_position + 12)
		end
	}

	-- possible value
	t[#t+1] = LoadFont("Wendy/_ScreenEvaluation numbers")..{
		InitCommand=function(self) self:zoom(0.5):horizalign(right) end,
		BeginCommand=function(self)
			self:y(y_position)
			self:x(x_position + 65)
			self:settext(("%03.0f"):format(possible))
			local leadingZeroAttr = { Length=3-tonumber(tostring(possible):len()), Diffuse=color("#5A6166") }
			self:AddAttribute(0, leadingZeroAttr )
		end
	}
end

return t
