-- Pane6 displays QR codes for uploading scores to groovestats.com

local player, side = unpack(...)

-- ------------------------------------------
-- ValidForGrooveStats.lua contains various checks requested by Archi
-- to determine whether the score should be permitted on GrooveStats
-- and returns a table of booleans, one per check.
--
-- Obviously, this is trivial to circumvent and not meant to keep
-- malicious users out of GrooveStats. It is intended to prevent
-- well-intentioned-but-unaware players from accidentally submitting
-- invalid scores to GrooveStats.

local checks = LoadActor("./ValidForGrooveStats.lua", player)

-- reduce the table of booleans to single value; the score is valid or it isn't
local ValidForGrooveStats = true
for _, passed_check in ipairs(checks) do
	if not passed_check then ValidForGrooveStats = false; break end
end

local url, text = nil, ""
local X_HasBeenBlinked = false

-- GrooveStatsURL.lua returns a formatted URL with some parameters in the query string
if ValidForGrooveStats then
	url = LoadActor("./GrooveStatsURL.lua", player)
	text = ScreenString("QRInstructions")

else
	-- hbdi
	url = "https://www.youtube.com/watch?v=FMABVVk4Ge4"
	num_failed_checks = 0
	max_checks_to_display = 2

	for i, passed_check in ipairs(checks) do
		if passed_check == false and num_failed_checks < max_checks_to_display then
			num_failed_checks = num_failed_checks + 1
			-- the 4th check is GameMode (ITG, FA+, Casual, etc.)
			if i==4 then
				-- that string has a %s token so we can pass in the current SL GameMode
				text = text .. ScreenString("QRInvalidScore"..i):format(SL.Global.GameMode) .. "\n"
			else
				-- other strings can be used as-is
				text = text .. ScreenString("QRInvalidScore"..i) .. "\n"
			end
		end
	end
end

local qrcode_size = 122

-- ------------------------------------------

local pane = Def.ActorFrame{
	InitCommand=function(self) self:visible(false) end,
	PaneSwitchCommand=function(self)
		if self:GetVisible() and not ValidForGrooveStats and not X_HasBeenBlinked then
			self:queuecommand("BlinkX")
		end
	end
}

local text_x_offset = -100
local text_y_offset = 225
local text_width = 72
local text_body_size = 0.55
local code_x_offset = -21
local code_y_offset = 189

pane[#pane+1] = qrcode_amv( url, qrcode_size )..{
	OnCommand=function(self)
		self:xy(code_x_offset,code_y_offset)
	end
}

-- red X to visually cover the QR code if the score was invalid
if not ValidForGrooveStats then
	pane[#pane+1] = LoadActor("x.png")..{
		InitCommand=function(self)
			self:zoom(0.77):align(0,0):xy(code_x_offset,code_y_offset)
		end,
		-- blink the red X once when the player first toggles into the QR pane
		BlinkXCommand=function(self)
			X_HasBeenBlinked = true
			self:finishtweening():sleep(0.25):linear(0.3):diffusealpha(0):sleep(0.175):linear(0.3):diffusealpha(0.5)
		end
	}
end

pane[#pane+1] = LoadActor("../Pane2/Percentage.lua", player)

pane[#pane+1] = LoadFont("Common Normal")..{
	Text="GrooveStats QR",
	InitCommand=function(self) self:zoom(0.7):xy(text_x_offset, text_y_offset):align(0,0) end
}

pane[#pane+1] = Def.Quad{
	InitCommand=function(self) self:xy(text_x_offset, text_y_offset+20):zoomto(text_width-3,1):align(0,0):diffuse(1,1,1,0.33) end
}

-- localized help text, either "use your phone to scan" or "here's why your score was invalid"
pane[#pane+1] = LoadFont("Common Normal")..{
	Text=text,
	InitCommand=function(self)
		self:zoom(text_body_size):xy(text_x_offset,text_y_offset+27):align(0,0):vertspacing(-4):wrapwidthpixels(text_width/text_body_size):MaskDest()

		local z = ValidForGrooveStats and 0.8 or 0.675
		-- FIXME: Oof.
		if THEME:GetCurLanguage() == "ja" then self:_wrapwidthpixels( scale(96, 0,0.8, 0,z)/z ) end
	end,
}


return pane
