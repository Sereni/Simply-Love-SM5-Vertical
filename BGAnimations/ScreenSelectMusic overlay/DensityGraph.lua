local show = true
local player = GAMESTATE:GetMasterPlayerNumber()

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
        if show and not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() then
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
                :diffuse(color("#4D6677"))
        end
    },

    histogram..{
        UpdateGraphStateCommand=function(self)
            self:y(histogramHeight)

            if show and not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() then
		    self:playcommand("Update")
            end
        end
    },

    -- background for the text
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(histogramWidth, 20)
                :diffuse(color("#000000"))
                :diffusealpha(0.8)
                :align(0, 0)
                :y(histogramHeight - 20)
        end,
    },

    Def.BitmapText{
        Font="_miso",
        InitCommand=function(self)
            self:diffuse(color("#ffffff"))
                :horizalign("left")
                :y(histogramHeight - 20 + 2)
                :x(5)
                :maxwidth(histogramWidth - 10)
                :align(0, 0)
                :Stroke(color("#000000"))
        end,

        CurrentStepsP1ChangedMessageCommand=function(self, params)
            self:queuecommand("UpdateGraphState")
        end,
        CurrentStepsP2ChangedMessageCommand=function(self, params)
            self:queuecommand("UpdateGraphState")
        end,

        UpdateGraphStateCommand=function(self)
            if show and not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() then
                local steps = GAMESTATE:GetCurrentSteps(player)
                local steps_type = ToEnumShortString( steps:GetStepsType() ):gsub("_", "-"):lower()
                local difficulty = ToEnumShortString( steps:GetDifficulty() )
                local breakdown = GetStreamBreakdown(steps, steps_type, difficulty)

                if breakdown == "" then
                    self:settext("No streams!")
                else
                    self:settext(breakdown)
                end

                return true
            end
        end
    }
}
