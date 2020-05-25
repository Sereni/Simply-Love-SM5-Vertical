local numItemsToDraw = 8
local scrolling_down = true
local quadHeight = 75
local quadWidth = 125
local maskHeight = 150

local transform_function = function(self,offsetFromCenter,itemIndex,numitems)
	self:y( offsetFromCenter * 17 )
end

-- ccl is a reference to the CourseContentsList actor that this update function is called on
-- dt is "delta time" (time in seconds since the last frame); we don't need it here
local update = function(ccl, dt)

	-- CourseContentsList:GetCurrentItem() returns a float, so call math.floor() on it
	-- while it's scrolling down or math.ceil() while it's scrolling up to do integer comparison.
	--
	-- if we've reached the bottom of the list and want the CCL to scroll up
	if math.floor(ccl:GetCurrentItem()) == (ccl:GetNumItems() - (numItemsToDraw/2)) then
		scrolling_down = false
		ccl:SetDestinationItem( 0 )

	-- elseif we've reached the top of the list and want the CCL to scroll down
	elseif math.ceil(ccl:GetCurrentItem()) == 0 then
		scrolling_down = true
		ccl:SetDestinationItem( math.max(0,ccl:GetNumItems() - numItemsToDraw/2) )
	end
end



local af = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(quadWidth/2, _screen.cy)
	end,

	---------------------------------------------------------------------
	-- Masks (as used here) are just Quads that serve to hide the rows
	-- of the CourseContentsList above and below where we want to see them.
	-- To see what I mean, try commenting out the two calls to MaskSource()
	-- (one per Quad) and refreshing the screen.
	--
	-- Normally, we would also have to call MaskDest() on the thing we wanted to
	-- be hidden by the mask, but that is effectively already called on the
	-- entire "Display" ActorFrame of the CourseContentsList in the engine's code.

	-- lower mask
	Def.Quad{
		InitCommand=function(self)
			self:y(quadHeight/2 + maskHeight/2)
				:zoomto(quadWidth, maskHeight)
				:MaskSource()
		end
	},

	-- upper mask
	Def.Quad{
		InitCommand=function(self)
			self:vertalign(bottom)
				:y(-quadHeight/2)
				:zoomto(quadWidth, maskHeight)
				:MaskSource()
		end
	},
	---------------------------------------------------------------------
	-- background
	Def.Quad{
		Name="Background",
		InitCommand=function(self)
			self:diffuse(color("#1e282f")):zoomto(quadWidth, quadHeight)
			if ThemePrefs.Get("RainbowMode") then
				self:diffusealpha(0.75)
			end
		end
	},
}

af[#af+1] = Def.CourseContentsList {
	-- I guess just set this to be arbitrarily large so as not to truncate longer
	-- courses from fully displaying their list of songs...?
	MaxSongs=1000,

	-- this is how many rows the ActorScroller should draw at a given moment
	NumItemsToDraw=numItemsToDraw,

	InitCommand=function(self)
		self:SetUpdateFunction( update ):vertalign(top)
	end,

	CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end,
	SetCommand=function(self)

		-- I have a very flimsy understanding of what most of these methods do,
		-- as they were all copied from the default theme's CourseContentsList, but
		-- commenting each one out broke the behavior of the ActorScroller in a unique
		-- way, so I'm leaving them intact here.
		self:SetFromGameState()
			:SetCurrentAndDestinationItem(0)
			:SetTransformFromFunction(transform_function)
			:PositionItems()

			:SetLoop(false)
			:SetPauseCountdownSeconds(1)
			:SetSecondsPauseBetweenItems( 0.2 )

		if scrolling_down then
			self:SetDestinationItem( math.max(0,self:GetNumItems() - numItemsToDraw/2) )
		else
			self:SetDestinationItem( 0 )
		end
	end,

	-- a generic row in the CourseContentsList
	Display=Def.ActorFrame {
		SetSongCommand=function(self, params)
			self:finishtweening()
				:zoomy(0)
				:sleep(0.125*params.Number)
				:linear(0.125):zoomy(1)
				:linear(0.05):zoomx(1)
				:decelerate(0.1):zoom(0.875)
		end,

		-- song title
		Def.BitmapText{
			Font="Common Normal",
			InitCommand=function(self)
				self:xy(-quadWidth/2+20, -quadHeight/2+7)
					:horizalign(left)
					:vertalign(top)
					:maxwidth(195)
					:zoom(0.5)
			end,
			SetSongCommand=function(self, params)
				if params.Song then
					self:settext( params.Song:GetDisplayFullTitle() )
				else
					self:settext( "??????????" )
				end
			end
		},

		-- Song difficulty
		Def.BitmapText{
			Font="_wendy small",
			InitCommand=function(self)
				self:xy(-quadWidth/2+15, -quadHeight/2+7)
				:horizalign(right)
				:vertalign(top)
				:zoom(0.2)
			end,
			SetSongCommand=function(self, params)
				self:settext( params.Meter or "?" ):diffuse( CustomDifficultyToColor(params.Difficulty) )
			end
		},
	}
}

return af
