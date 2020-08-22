local args = ...
local af = args.af

local path = "/Themes/" ..THEME:GetCurThemeName().. "/Graphics/_flags/"
local files = FILEMAN:GetDirListing(path)

for file in ivalues(files) do
	-- attempt to filter out system files that start with "."
	if file:sub(1,1) ~= "." then
		af[#af+1] = LoadActor(THEME:GetPathG("","_flags/"..StripSpriteHints(file)..".png"))..{
			Name="Flag_"..StripSpriteHints(file),
			InitCommand=function(self) self:xy(-100, -210):zoom(0.35) end
		}
	end
end
