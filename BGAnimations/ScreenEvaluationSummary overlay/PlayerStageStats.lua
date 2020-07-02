local player = ...

local LetterGradesAF
local playerStats
local steps, meter, difficulty, stepartist, grade, score
local TNSTypes = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' }
local quadWidth = _screen.w-40
local quadHeight = 75

-- variables for positioning and horizalign, dependent on playernumber
local col1x, col2x, align1, align2
col1x =  quadWidth/2 - 10
col2x =  20
align1 = right
align2 = left


local af = Def.ActorFrame{
	OnCommand=function(self)
		LetterGradesAF = self:GetParent():GetParent():GetChild("LetterGradesAF")
	end,
	DrawStageCommand=function(self, params)
		playerStats = SL[ToEnumShortString(player)].Stages.Stats[params.StageNum]

		if playerStats then
			steps = playerStats.steps
	 		meter = playerStats.meter
	 		difficulty = playerStats.difficulty
	 		stepartist = playerStats.stepartist
	 		grade = playerStats.grade
	 		score = playerStats.score
		end
	end
}

--percent score
af[#af+1] = LoadFont("_wendy small")..{
	InitCommand=function(self) self:zoom(0.4):horizalign(align1):x(col1x):y(-quadHeight/2+19) end,
	DrawStageCommand=function(self)
		if playerStats and score then

			-- trim off the % symbol
			local score = string.sub(FormatPercentScore(score),1,-2)

			-- If the score is < 10.00% there will be leading whitespace, like " 9.45"
			-- trim that too, so PLAYER_2's scores align properly.
			score = score:gsub(" ", "")
			self:settext(score):diffuse(Color.White)

			if grade and grade == "Grade_Failed" then
				self:diffuse(Color.Red)
			end
		else
			self:settext("")
		end
	end
}

-- difficulty meter
af[#af+1] = LoadFont("_wendy small")..{
	InitCommand=function(self) self:zoom(0.3):horizalign(align1):x(col1x):y(quadHeight/2-35) end,
	DrawStageCommand=function(self)
		if playerStats and meter then
			self:diffuse(DifficultyColor(difficulty)):settext(meter)
		else
			self:settext("")
		end
	end
}

-- stepartist
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self) self:zoom(0.5):horizalign(align1):x(col1x):y(quadHeight/2-20):maxwidth(130) end,
	DrawStageCommand=function(self)
		if playerStats and stepartist then
			self:settext(stepartist)
		else
			self:settext("")
		end
	end
}

-- numbers
for i=1,#TNSTypes do

	af[#af+1] = LoadFont("_wendy small")..{
		InitCommand=function(self)
			self:zoom(0.2):horizalign(align2):x(col2x):y(i*11-45)
				:diffuse( SL.JudgmentColors[SL.Global.GameMode][i] )
		end,
		DrawStageCommand=function(self, params)
			if playerStats and playerStats.judgments then
				local val = playerStats.judgments[TNSTypes[i]]
				if val then self:settext(val) end

				self:visible( SL.Global.Stages.Stats[params.StageNum].TimingWindows[i] or i==#TNSTypes )
			else
				self:settext("")
			end
		end
	}
end

return af
