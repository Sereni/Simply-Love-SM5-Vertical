local player, side = unpack(...)

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")

-- ecfa 2021 stuff
local ecfa2021score, ecfa2021max, rawdp = ECFA2021ScoreSL(player)

return Def.ActorFrame{
	Name="PercentageContainer"..ToEnumShortString(player),
	OnCommand=function(self)
		self:y( 5 )
		self:x( -101 )
	end,

	-- dark background quad behind player percent score
	Def.Quad{
		InitCommand=function(self)
			self:diffuse(color("#101519")):zoomto(102, 40)
		end
	},

	LoadFont("Wendy/_wendy white")..{
		Name="Percent",
		Text=percent,
		InitCommand=function(self)
                        if ecfa2021score then self:visible(false) return end
			self:vertalign(middle):horizalign(right):zoom(0.38)
			self:x(45)
		end
	},
	
	-- ECFA 2021 score
        LoadFont("Wendy/_wendy white")..{
                Name="ECFA2021",
                Text="",
                InitCommand = function(self)
                        if not ecfa2021score then return end
                        self:vertalign(middle):horizalign(right):zoom(0.38):x(40)
                        self:settext(ECFAPointString(ecfa2021score))
                end
        },
        -- "Insufficient FA" message
        LoadFont("Common Normal")..{
                Text="",
                InitCommand = function(self)
                        if not ecfa2021score then self:visible(false) return end
                        if ecfa2021score == 0 then
                                local ptext = self:GetParent():GetChild("Percent")
                                local diff = GAMESTATE:GetCurrentSteps(player):GetMeter()
                                local dpscore = math.floor(10000*rawdp)/100
                                local fapass = math.round(100*ECFA_FAPass[diff])
                                self:xy(ptext:GetX() + 80, -30):zoom(0.8):diffuseshift():effectcolor1(Color.Red)
                                        :effectcolor2(Color.White):settext(string.format("%.2f/%d%% FA Pass", dpscore, fapass))
                        end
                end
        }
}
