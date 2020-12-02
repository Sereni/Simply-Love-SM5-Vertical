local player = ...
local pn = tonumber(player:sub(-1))

-- exit if disabled
--if SL["P"..pn].ActiveModifiers.EarlyLate == "Disabled" then return end

local style = "Enabled" --SL["P"..pn].ActiveModifiers.EarlyLate
local color = SL["P"..pn].ActiveModifiers.EarlyLateColor

local useitg = SL["P"..pn].ActiveModifiers.SimulateITGEnv
local env = (not useitg) and "Waterfall" or "ITG"

local elcolors = {{0,0.5,1,1},{1,0.5,1,1}} -- blue/pink

local threshold = 0
local thresholdmod = SL["P"..pn].ActiveModifiers.EarlyLateThreshold
local faplusmod = SL["P"..pn].ActiveModifiers.FAPlus
if thresholdmod == "FA+" then
    threshold = (faplusmod > 0) and faplusmod or 0
elseif thresholdmod == "None" then
    threshold = -1
end

local ypos = (SL["P"..pn].ActiveModifiers.MeasureCounterUp) and 12 or 48

if (useitg) and threshold == 0 then
    threshold = WF.ITGTimingWindows[WF.ITGJudgments.Fantastic]
elseif (not useitg) and threshold == 0.015 then
    -- this condition should not happen but might as well cover it here too
    threshold = 0
end

local text = LoadFont("wendy/_wendy small")..{
    Text = "",
    InitCommand = function(self)
        local reverse = GAMESTATE:GetPlayerState(player):GetPlayerOptions("ModsLevel_Preferred"):UsingReverse()
        self:zoom(0.25)
        self:y((reverse and 1 or -1) * ypos)
    end,
    JudgmentMessageCommand = function(self, params)
        if params.Player ~= player then return end
        if params.TapNoteScore and (not params.HoldNoteScore) and params.TapNoteScore ~= "TapNoteScore_AvoidMine" and
        params.TapNoteScore ~= "TapNoteScore_HitMine" and params.TapNoteScore ~= "TapNoteScore_Miss" then
            if (threshold == -1) or (threshold == 0 and params.TapNoteScore ~= "TapNoteScore_W1") or 
            (threshold > 0 and math.abs(params.TapNoteOffset) > threshold) then
                self:finishtweening()
                self:settext(params.Early and "EARLY" or "LATE")
                if color == "EarlyLate" then
                    self:diffuse(elcolors[params.Early and 1 or 2])
                elseif color == "Judgment" then
                    local w = tonumber(params.TapNoteScore:sub(-1))
                    if useitg then w = DetermineTimingWindow(params.TapNoteOffset, "ITG") end
                    self:diffuse(SL.JudgmentColors[env][w])
                end
                self:x((params.Early and -1 or 1) * 40)
                self:diffusealpha(1)
                self:sleep(0.5)
                self:diffusealpha(0)
            else
                self:finishtweening()
                self:diffusealpha(0)
            end
        end
    end
}

local quad = Def.Quad{
    InitCommand = function(self)
        local reverse = GAMESTATE:GetPlayerState(player):GetPlayerOptions("ModsLevel_Preferred"):UsingReverse()
        self:zoomto(20,4)
        self:y((reverse and 1 or -1) * ypos)
        self:diffusealpha(0)
    end,
    JudgmentMessageCommand = function(self, params)
        if params.Player ~= player then return end
        if params.TapNoteScore and (not params.HoldNoteScore) and params.TapNoteScore ~= "TapNoteScore_AvoidMine" and
        params.TapNoteScore ~= "TapNoteScore_HitMine" and params.TapNoteScore ~= "TapNoteScore_Miss" then
            if (threshold == -1) or (threshold == 0 and params.TapNoteScore ~= "TapNoteScore_W1") or 
            (threshold > 0 and math.abs(params.TapNoteOffset) > threshold) then
                self:finishtweening()
                if color == "EarlyLate" then
                    self:diffuse(elcolors[params.Early and 1 or 2])
                elseif color == "Judgment" then
                    local w = tonumber(params.TapNoteScore:sub(-1))
                    if useitg then w = DetermineTimingWindow(params.TapNoteOffset, "ITG") end
                    self:diffuse(SL.JudgmentColors[env][w])
                end
                self:x((params.Early and -1 or 1) * 40)
                self:diffusealpha(1)
                self:sleep(0.5)
                self:diffusealpha(0)
            else
                self:finishtweening()
                self:diffusealpha(0)
            end
        end
    end
}

-- 🛹
-- one way of drawing these quads would be to just draw them centered, back to front, with the full width of the
-- corresponding window. this would look bad if we want to alpha blend them though, so i'm drawing the segments
-- individually so that there is no overlap.
local tonyhawk = Def.ActorFrame{
    InitCommand = function(self)
        local reverse = GAMESTATE:GetPlayerState(player):GetPlayerOptions("ModsLevel_Preferred"):UsingReverse()
        self:y((reverse and 1 or -1) * ypos)
        self:zoom(0)
    end
}

local mwidth = 60 -- technically half width
local mheight = 6
local malpha = 0.7
local tickwidth = 2
local windowstouse = 3 -- decided that we don't care to show outside the first few windows

local function getWindow(n)
    -- just gonna make this a function because the logic for timing windows per env is so disjointed (TWA lol fuck you)
    if n == 0 then return faplusmod end
    local prefs = SL.Preferences
    local window = PREFSMAN:GetPreference("TimingWindowSecondsW"..n)
    if useitg then window = window + prefs["TimingWindowAdd"] end
    --window = math.min(window, wedge)
    return window
end
local wedge = math.min(
    math.max(PREFSMAN:GetPreference("TimingWindowSecondsW4"), PREFSMAN:GetPreference("TimingWindowSecondsW5")),
    getWindow(windowstouse)
)
local lastx1 = 0
for i = 1, windowstouse + 1 do
    -- create two quads for each window.
    if (not SL.Global.ActiveModifiers.TimingWindows[5]) and ((useitg and (i == 5 or i == 6)) or ((not useitg) and i == 6)) then
        break
    end

    if not (i == 2 and faplusmod == 0) then
        local ii = i
        if i > 1 then ii = i - 1 end
        local x1 = (getWindow(ii) / wedge) * mwidth
        local w = x1 - lastx1
        local c = Color.White
        tonyhawk[#tonyhawk+1] = Def.Quad{
            InitCommand = function(self)
                self:x(x1):horizalign("right"):zoomx(w):diffuse(c)
                :diffusealpha(malpha):zoomy(mheight)
            end
        }
        tonyhawk[#tonyhawk+1] = Def.Quad{
            InitCommand = function(self)
                self:x(-x1):horizalign("left"):zoomx(w):diffuse(c)
                :diffusealpha(malpha):zoomy(mheight)
            end
        }

        lastx1 = x1
    end
end
-- tick
tonyhawk[#tonyhawk+1] = Def.Quad{
    Name = "TonyHawkTick",
    InitCommand = function(self)
        local clr = (env == "ITG") and {0.7,0,0,1} or {0,0.5,0.8,1}
        self:zoomx(tickwidth):diffuse(clr):zoomy(mheight+2)
    end
}

tonyhawk.JudgmentMessageCommand = function(self, params)
    if params.Player ~= player then return end
    if params.TapNoteScore and (not params.HoldNoteScore) and params.TapNoteScore ~= "TapNoteScore_AvoidMine" and
    params.TapNoteScore ~= "TapNoteScore_HitMine" and params.TapNoteScore ~= "TapNoteScore_Miss" then
        if (threshold == -1) or (threshold == 0 and params.TapNoteScore ~= "TapNoteScore_W1") or 
        (threshold > 0 and math.abs(params.TapNoteOffset) > threshold) then
            self:finishtweening()
            self:GetChild("TonyHawkTick"):x(math.max(math.min((params.TapNoteOffset / wedge) * mwidth,
                mwidth + 4), -mwidth - 4))
            self:zoom(1)
            self:sleep(0.5)
            self:zoom(0)
        else
            self:finishtweening()
            self:zoom(0)
        end
    end
end

local af = Def.ActorFrame{
    OnCommand = function(self)
        self:xy(GetNotefieldX(player), _screen.cy)
    end
}

if style == "Enabled" then af[#af+1] = text
elseif style == "Simple" then af[#af+1] = quad
elseif style == "Advanced" then af[#af+1] = tonyhawk end

return af
