local player = GAMESTATE:GetMasterPlayerNumber()
local pn = ToEnumShortString(player)

local histogramWidth = 417
local histogramHeight = 86
local histogram = NPS_Histogram(player, histogramWidth, histogramHeight)

-- don't do anything when song changes
histogram.CurrentSongChangedMessageCommand=nil

return Def.ActorFrame {
    InitCommand=function(self)
        local zoom = 0.3
        local xPos = 0
        local yPos = 278

        self:zoom(zoom)
        self:xy(xPos, yPos)

        self:diffusealpha(0)
    end,

    CurrentSongChangedMessageCommand=function(self, params)
        self:queuecommand("UpdateGraphState")
    end,
    CurrentStepsP1ChangedMessageCommand=function(self, params)
        self:queuecommand("UpdateGraphState")
    end,
    CurrentStepsP2ChangedMessageCommand=function(self, params)
        self:queuecommand("UpdateGraphState")
    end,

    UpdateGraphStateCommand=function(self, params)
        if not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() then
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

    histogram..{
        UpdateGraphStateCommand=function(self)
            self:y(histogramHeight)
            if not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() then
		            self:playcommand("Update")
            end
        end
    },

    -- background for the text
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(histogramWidth, 20)
                :diffuse(color("#000000"))
                :diffusealpha(0.4)
                :align(0, 0)
                :y(histogramHeight - 20)
        end,
    },

    Def.BitmapText{
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

        ["CurrentSteps"..pn.."ChangedMessageCommand"]=function(self)
			       self:queuecommand("UpdateBreakdown")
        end,

        UpdateBreakdownCommand=function(self)
        			self:settext(GenerateBreakdownText(pn, 0))
        			local minimization_level = 1
        			while self:GetWidth() > (histogramWidth - 10) and minimization_level < 4 do
        				self:settext(GenerateBreakdownText(pn, minimization_level))
        				minimization_level = minimization_level + 1
        			end
        		end,
    }
}
