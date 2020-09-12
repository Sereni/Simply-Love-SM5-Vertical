local GetDeltaString = function()
	delta = SL.Global.ActiveModifiers.GlobalOffsetDelta * 1000
	form = delta > 0 and "+%d ms" or "%d ms"
	str = string.format(form, delta):gsub("^0.*", "")
	return str
end

local af = Def.ActorFrame{
	OffCommand=function(self)
		local topscreen = SCREENMAN:GetTopScreen()
		if topscreen then
			self:linear(0.1)
			self:diffusealpha(0)
		end
	end,

	LoadActor( THEME:GetPathG("", "_header.lua") ),
}

af[#af+1] = LoadFont("Wendy/_wendy small")..{
	Name="CustomGlobalOffset",
	InitCommand=function(self)
		self:diffusealpha(0):zoom(0.3):xy(_screen.cx-30, 7.5)
	end,
	OnCommand=function(self)
		self:settext(GetDeltaString())
			:sleep(0.1):decelerate(0.33):diffusealpha(1)
	end,
	GlobalOffsetChangedMessageCommand=function(self)
		self:settext(GetDeltaString())
	end
}

return af
