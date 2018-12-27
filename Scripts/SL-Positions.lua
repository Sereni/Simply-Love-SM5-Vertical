-- A table containing functions to determine positions of UI elements.

-- Define top level table.
if not Positions then Positions = {} end

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