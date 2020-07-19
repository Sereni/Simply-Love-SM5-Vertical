local headerHeight = 25
local rowHeight = 16

-- we'll figure out how many rows (that is, how many mappable buttons) there are
-- after the screen has initialized and we can get the scroller via SCREENMAN
local num_buttons
-- same with scroller_y; define to be 0 for now
local scroller_y = 0
-- First row y from metrics.ini, plus a row height to focus on the header
local first_row_y = _screen.cy/3 + rowHeight

local af = Def.ActorFrame{
	-- a Quad to move around the screen as the focus of the scroller changes
	Def.Quad{
		InitCommand=function(self) self:zoomto(34,rowHeight):diffuse(1,0,0,0.5) end,

		-- I'm having MapControllersFocusChanged and MapControllersFocusLost broadcast
		-- via MESSAGEMAN in Metrics.ini in the [ScreenMapControllers] section.
		MapControllersFocusChangedMessageCommand=function(self, params)
			-- Special case the first row so that the cursor initially appears in the
			-- right row. When moved, the cursor will update correctly.
			local y = first_row_y
			if params.bmt:GetParent().ItemIndex > 1 then
				y = params.bmt:GetParent().ItemIndex * rowHeight + scroller_y
			end

			local x = params.bmt:GetX()
			self:visible(true):xy(x,y)
		end,
		MapControllersFocusLostMessageCommand=function(self)
			self:visible(false)
		end
	},

	Def.ActorProxy{
		Name="Scroller",
		OnCommand=function(self)
			local scroller = SCREENMAN:GetTopScreen():GetChild("LineScroller")
			self:SetTarget(scroller)
			num_buttons = #scroller:GetChild("Line")
			-- need to queue so that the Scroller itself has time to apply its OnCommand as defined in Metrics.ini
			-- then we can get the y value that... doesn't seem to be accessible in any other way
			self:queuecommand("GetScrollerY")
		end,
		GetScrollerYCommand=function(self)
			scroller_y = SCREENMAN:GetTopScreen():GetChild("LineScroller"):GetY()
		end

	}
}

for i,player in ipairs( PlayerNumber ) do
	-- colored Quad serving as a background for the text "PLAYER 1" or "PLAYER 2"
	af[#af+1] = Def.Quad{
		InitCommand=function(self)
			self:align(PlayerNumber:Reverse()[player], 0):x(player==PLAYER_1 and 0 or _screen.w)
				:zoomto(_screen.cx, headerHeight):diffuse(PlayerColor(player)):diffusealpha(0.8)
		end
	}

	af[#af+1] = LoadFont("Common Header")..{
		Text=("%s %i"):format(THEME:GetString("ScreenTestInput", "Player"), PlayerNumber:Reverse()[player]+1),
		InitCommand=function(self)
			self:halign(PlayerNumber:Reverse()[OtherPlayer[player]])
				:x(_screen.cx + 60 * (player==PLAYER_1 and -1 or 1) )
				:y(headerHeight/2):zoom(0.3):diffusealpha(0)
		end,
		OnCommand=function(self) self:linear(0.5):diffusealpha(1) end,
		OffCommand=function(self) self:linear(0.5):diffusealpha(0) end,
	}
end

af[#af+1] = Def.Quad{
	Name="DevicesBG",
	InitCommand=function(self)
		self:x(_screen.cx):y(headerHeight/2):zoomto(100, headerHeight):diffuse(0.5,0.5,0.5,0.9)
	end
}

return af
