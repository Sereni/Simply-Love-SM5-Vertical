local numItemsToDraw = 8
local scrolling_down = true
local quadHeight = 75
local quadWidth = 125
local maskHeight = 150
local PrevCurrentItem = 0
local SecondsToPause = 0.5

local transform_function = function(self,offsetFromCenter,itemIndex,numitems)
	self:y( offsetFromCenter * 17 )
end

-- ccl is a reference to the CourseContentsList actor that this update function is called on
-- dt is "delta time" (time in seconds since the last frame); we don't need it here
local update = function(ccl, dt)

	-- if ccl:GetCurrentItem() hasn't changed since the last update, the scrolling
	-- behavior has (probably) paused on a particular CourseEntry for a moment
	if (PrevCurrentItem == ccl:GetCurrentItem()) then
		MESSAGEMAN:Broadcast("UpdateTrailText", {index=round(PrevCurrentItem)+1})
	else
		PrevCurrentItem = ccl:GetCurrentItem()
	end

	-- CourseContentsList:GetCurrentItem() returns a float, so call math.floor()
	-- on it while it's scrolling down to attempt integer comparison, and wait
	-- for it to go negative when it's scrolling up (3 → 2 → 1 → 0 → -0.0012...)
	--
	-- if we've reached the bottom of the list and want the CCL to scroll up
	if math.floor(ccl:GetCurrentItem()) == (ccl:GetNumItems() - (numItemsToDraw/2)) then
		ccl:SetDestinationItem( 0 )

	-- elseif we've reached the top of the list and want the CCL to scroll down
	elseif ccl:GetCurrentItem() <= 0 and ccl:GetTweenTimeLeft() == 0 then
		ccl:playcommand("Wait")
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

	WaitCommand=function(self)
		self:sleep(SecondsToPause):queuecommand("StartScrollingDown")
	end,
	StartScrollingDownCommand=function(self)
		self:SetDestinationItem( math.max(0, self:GetNumItems() - 1) )
	end,

	SetCommand=function(self)
		self:finishtweening():SetFromGameState()

		-- I have a very flimsy understanding of what most of these methods do,
		-- as they were all copied from the default theme's CourseContentsList, but
		-- commenting each one out broke the behavior of the ActorScroller in a unique
		-- way, so I'm leaving them intact here.
		self:SetCurrentAndDestinationItem(0)
			:SetTransformFromFunction(transform_function)
			:PositionItems()

			:SetLoop(false)
			:SetPauseCountdownSeconds(0)
			:SetSecondsPauseBetweenItems( SecondsToPause )
	end,

	-- a generic row in the CourseContentsList
	Display=Def.ActorFrame {
		SetCommand=function(self)
			-- override fallback animation by forcing tween to finish immediately
			self:finishtweening()
		end,
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
			Font="Wendy/_wendy small",
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
