-- - - - - - - - - - - - - - - - - - - - -
-- first, reset the global SL table to default values
-- this is defined in:  ./Scripts/SL_Init.lua
InitializeSimplyLove()

if ThemePrefs.Get("VisualStyle") == "SRPG5" then
	SL.SRPG5:MaybeRandomizeColor()
end

-- -----------------------------------------------------------------------
-- preliminary Lua setup is done
-- now define actors to be passed back to the SM engine

-- TODO: This screen will need to be realigned, it's been refactored pretty heavily. See git history for previous alignment values ~Roujo

local af = Def.ActorFrame{}
af.InitCommand=function(self) self:Center() end


-- IsSpooky() will be true during October if EasterEggs are enabled
-- this is the content found in ./Graphics/_VisualStyles/Spooky/ExtraSpooky
-- it needs to be layered appropriately, some assets behind, some in front
-- Spooky.lua includes a quad that fades the screen to black and the glowing pumpkin that remains
-- SpookyButFadeOut.lua includes cobwebs in the upper-right and upper-left
if IsSpooky() then
	af[#af+1] = LoadActor("./Spooky.lua")
end

-- -----------------------------------------------------------------------
-- af2 contains things that should fade out during the OffCommand
local af2 = Def.ActorFrame{}
af2.OffCommand=function(self) self:smooth(0.65):diffusealpha(0) end
af2.Name="SLInfo"


-- the big blocky Wendy text that says SIMPLY LOVE (or SIMPLY THONK, or SIMPLY DUCKS, etc.)
-- and the arrows graphic that appears between the two words
af2[#af2+1] = LoadActor("./Logo.lua")

-- 3 lines of text:
--    theme_name   theme_version
--    stepmania_version
--    num_songs in num_groups, num_courses
af2[#af2+1] = LoadActor("./UserContentText.lua")

-- "The chills, I have them down my spine."
if IsSpooky() then
	af2[#af2+1] = LoadActor("./SpookyButFadeOut.lua")
end

-- the best way to spread holiday cheer is singing loud for all to hear
if HolidayCheer() then
	af2[#af2+1] = Def.Sprite{
		Texture=THEME:GetPathB("ScreenTitleMenu", "underlay/hat.png"),
		InitCommand=function(self) self:zoom(0.15):xy( hat_x, -self:GetHeight()/2 ):rotationz(15):queuecommand("Drop") end,
		DropCommand=function(self) self:decelerate(hat_decelerate_rate):y(hat_decelerate_y) end,
	}
end

-- -----------------------------------------------------------------------
-- grooveStatsAf contains all of the things related to displaying the GrooveStats connection
-- Only added if we were able to successfully identify the launcher.

local NewSessionRequestProcessor = function(res, grooveStatsAf)
	if grooveStatsAf == nil then return end

	local get_scores = grooveStatsAf:GetChild("GetScores")
	local leaderboard = grooveStatsAf:GetChild("Leaderboard")
	local auto_submit = grooveStatsAf:GetChild("AutoSubmit")

	if not res["status"] == "success" then
		if res["status"] == "fail" then
			get_scores:settext("Failed to Load 😞")
		elseif res["status"] == "disabled" then
			get_scores:settext("Disabled")
		end
		leaderboard:visible(false)
		auto_submit:visible(false)

		-- These default to false, but may have changed throughout the game's lifetime.
		-- It doesn't hurt to explicitly set them to false.
		SL.GrooveStats.GetScores = false
		SL.GrooveStats.Leaderboard = false
		SL.GrooveStats.AutoSubmit = false
		return
	end

	local data = res["data"]
	if data == nil then return end

	if data["servicesAllowed"] ~= nil then
		local services = data["servicesAllowed"]

		if get_scores ~= nil and services["playerScores"] ~= nil then
			if services["playerScores"] then
				get_scores:settext("✔ Get Scores")
				SL.GrooveStats.GetScores = true
			else
				get_scores:settext("❌ Get Scores")
				SL.GrooveStats.GetScores = false
			end
		end

		if leaderboard ~= nil and services["playerLeaderboards"] ~= nil then
			if services["playerLeaderboards"] then
				leaderboard:settext("✔ Leaderboard")
				SL.GrooveStats.Leaderboard = true
			else
				leaderboard:settext("❌ Leaderboard")
				SL.GrooveStats.Leaderboard = false
			end
		end

		if auto_submit ~= nil and services["scoreSubmit"] ~= nil then
			if services["scoreSubmit"] then
				auto_submit:settext("✔ Auto-Submit")
				SL.GrooveStats.AutoSubmit = true
			else
				auto_submit:settext("❌ Auto-Submit")
				SL.GrooveStats.AutoSubmit = false
			end
		end
	end
end

if SL.GrooveStats.Launcher then
	af[#af+1] = Def.ActorFrame{
		Name="GrooveStatsInfo",
		InitCommand=function(self)
			self:zoom(0.5):y(-_screen.cy+15):x(_screen.cx-45):diffusealpha(0)
		end,
		OnCommand=function(self)

			self:visible(SL.GrooveStats.Launcher)
			self:sleep(0.2):linear(0.4):diffusealpha(1)
		end,

		LoadFont("Common Normal")..{
			Text="GrooveStats",
			InitCommand=function(self) self:diffuse(TextColor):horizalign(center) end,
		},

		LoadFont("Common Normal")..{
			Name="GetScores",
			Text=" ...   Get Scores",
			InitCommand=function(self) self:diffuse(TextColor):visible(true):addx(-40):addy(18):horizalign(left) end,
		},

		LoadFont("Common Normal")..{
			Name="Leaderboard",
			Text=" ...   Leaderboard",
			InitCommand=function(self) self:diffuse(TextColor):visible(true):addx(-40):addy(36):horizalign(left) end,
		},

		LoadFont("Common Normal")..{
			Name="AutoSubmit",
			Text=" ...   Auto-Submit",
			InitCommand=function(self) self:diffuse(TextColor):visible(true):addx(-40):addy(54):horizalign(left) end,
		},

		RequestResponseActor("NewSession", 10)..{
			OnCommand=function(self)
				MESSAGEMAN:Broadcast("NewSession", {
					data={action="groovestats/new-session", ChartHashVersion=SL.GrooveStats.ChartHashVersion},
					args=SCREENMAN:GetTopScreen():GetChild("Underlay"):GetChild("GrooveStatsInfo"),
					callback=NewSessionRequestProcessor
				})
			end
		}
	}
end

-- ensure that af2 is added as a child of af
af[#af+1] = af2

-- -----------------------------------------------------------------------

return af
