-- A table containing functions to determine positions of UI elements.

-- Define top level table.
if not Positions then Positions = {} end

----------- ScreenGameplay -----------
Positions.ScreenGameplay = {}

-- Difficulty meter position (the small colored square).
Positions.ScreenGameplay.DifficultyMeterX = function(player)
  if IsVerticalScreen() then
    return _screen.w-25
  else
    if player == PLAYER_1 then
	  return WideScale(27,84)
	else
	  return _screen.w-WideScale(27,84)
	end
  end
end

Positions.ScreenGameplay.DifficultyMeterY = function()
  if IsVerticalScreen() then return 20 end
  if SL.Global.GameMode == "StomperZ" then return 20 end
  return 56
end

-- Life meters
Positions.ScreenGameplay.LifeMeterStandardX = function(player)
  if IsVerticalScreen() then return 61 end
  return _screen.cx + (player==PLAYER_1 and -1 or 1) * WideScale(238, 288)
  end

-- Playfield positions P1/P2
Positions.ScreenGameplay.P1SideX = function()
 if IsVerticalScreen() then
   return _screen.cx
 else
   return _screen.cx-(_screen.w*160/640)
 end
end

Positions.ScreenGameplay.P2SideX = function()
 if IsVerticalScreen() then
   return _screen.cx
 else
   return _screen.cx+(_screen.w*160/640)
 end
end

-- Score position (big white numbers)
Positions.ScreenGameplay.ScoreZoom = function()
  if IsVerticalScreen() then return 0.35 end
  if SL.Global.GameMode == "StomperZ" then
    return 0.4
  else
    return 0.5
  end
end

---------- ScreenTitleMenu ----------
Positions.ScreenTitleMenu = {}

-- Y-position of the "Gameplay, Edit Mode, Options..." menu.
Positions.ScreenTitleMenu.ScrollerY = function()
  if IsVerticalScreen() then
    return _screen.cy+_screen.h/5
  else
    return _screen.cy+_screen.h/3.8
  end
end
