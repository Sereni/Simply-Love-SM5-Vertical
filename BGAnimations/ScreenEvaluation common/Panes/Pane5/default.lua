-- Pane5 displays TestInput.
-- DedicatedMenu buttons are necessary here to prevent players from getting stuck in this pane
if not PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then return end

local game = GAMESTATE:GetCurrentGame():GetName()
if not (game=="dance" or game=="pump" or game=="techno") then return end

-- -----------------------------------------------------------------------

local player = unpack(...)

local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())

local pane = Def.ActorFrame{
	-- ExpandForDoubleCommand() does not do anything here, but we check for its presence in
	-- this ActorFrame in ./InputHandler to determine which panes to expand the background for
	ExpandForDoubleCommand=function() end,
}

	pane[#pane+1] = LoadActor( THEME:GetPathB("", "_modules/TestInput Pad/default.lua"), {Player=player, ShowMenuButtons=false, ShowPlayerLabel=false})..{
		InitCommand=function(self) self:xy(40, 300):zoom(0.625) end
	}
	pane[#pane+1] = LoadFont("Common normal")..{
		Text=THEME:GetString("ScreenEvaluation",  "TestInput"),
		InitCommand=function(self) self:zoom(0.7):xy(-78, 225):vertalign(top):maxwidth(100/self:GetZoom()) end
	}
	pane[#pane+1] = Def.Quad{
		InitCommand=function(self) self:xy(-100, 225+20):zoomto(69,1):align(0,0):diffuse(1,1,1,0.33) end
	}
	pane[#pane+1] = LoadFont("Common normal")..{
		Text=THEME:GetString("ScreenEvaluation",  "TestInputInstructions"),
		InitCommand=function(self) self:zoom(0.55):xy(-100,225+27):_wrapwidthpixels(100/0.8):align(0,0):vertspacing(-4) end
	}
return pane
