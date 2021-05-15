if GAMESTATE:IsCourseMode() then return end
local player = GAMESTATE:GetMasterPlayerNumber()
local pn = ToEnumShortString(player)

local histogramWidth = 417
local histogramHeight = 86

local af = Def.ActorFrame {
    InitCommand=function(self)
        local zoom = 0.3
        local xPos = 0
        local yPos = 278

        self:zoom(zoom)
        self:xy(xPos, yPos)

        self:diffusealpha(0)
    end,

    CurrentSongChangedMessageCommand=function(self, params)
        self:queuecommand("HideUnhide")
    end,
    ["CurrentSteps"..pn.."ChangedMessageCommand"]=function(self)
        self:queuecommand("HideUnhide")
    end,

    HideUnhideCommand=function(self, params)
        if GAMESTATE:GetCurrentSong() then
            self:stoptweening()
            self:linear(0.1):diffusealpha(0.9)
        else
            self:stoptweening()
            self:linear(0.1):diffusealpha(0)
        end
    end,

    -- background for whole thing
    Def.Quad{
        InitCommand=function(self)
            self:zoomto(histogramWidth,histogramHeight)
                :align(0, 0)
                :diffuse(color("#0a141b"))
        end
    },
}

af[#af+1] = Def.ActorFrame{
	Name="ChartParser",
	["CurrentSteps"..pn.."ChangedMessageCommand"]=function(self)
    if IsServiceAllowed(SL.GrooveStats.GetScores) then
      -- Stall not to spam GS with requests while scrolling through the wheel.
      self:sleep(0.4)
    end
		self:queuecommand("ParseChart")
	end,
	ParseChartCommand=function(self)
		local steps = GAMESTATE:GetCurrentSteps(player)
		if steps then
			MESSAGEMAN:Broadcast(pn.."ChartParsing")
			ParseChartInfo(steps, pn)
			self:queuecommand("Unhide")
		end
	end,
	UnhideCommand=function(self)
		if GAMESTATE:GetCurrentSteps(player) then
			MESSAGEMAN:Broadcast(pn.."ChartParsed")
			self:queuecommand("Redraw")
		end
	end
}

local af2 = af[#af]

af2[#af2+1] = NPS_Histogram(player, histogramWidth, histogramHeight)..{
  OnCommand=function(self)
        self:y(histogramHeight)
    end
}
-- don't do anything when song changes
af2[#af2].CurrentSongChangedMessageCommand=nil
-- Don't let the density graph parse the chart.
-- We do this in ChartParser actor because we want to "stall" before we parse.
af2[#af2].CurrentStepsP1ChangedMessageCommand = nil
af2[#af2].CurrentStepsP2ChangedMessageCommand = nil

-- Breakdown background
af2[#af2+1] = Def.Quad {
      InitCommand=function(self)
          self:zoomto(histogramWidth, 20)
              :diffuse(color("#000000"))
              :diffusealpha(0.4)
              :align(0, 0)
              :y(histogramHeight - 20)
      end,
  }

-- Breakdown text
af2[#af2+1] = Def.BitmapText{
    Font="Miso/_miso",
    InitCommand=function(self)
        self:diffuse(color("#ffffff"))
            :horizalign("left")
            :y(histogramHeight - 20 + 2)
            :x(5)
            :maxwidth(histogramWidth - 10)
            :align(0, 0)
            :Stroke(color("#000000"))
    end,

    RedrawCommand=function(self)
          self:settext(GenerateBreakdownText(pn, 0))
          local minimization_level = 1
          while self:GetWidth() > (histogramWidth - 10) and minimization_level < 4 do
            self:settext(GenerateBreakdownText(pn, minimization_level))
            minimization_level = minimization_level + 1
          end
        end,
}

return af
