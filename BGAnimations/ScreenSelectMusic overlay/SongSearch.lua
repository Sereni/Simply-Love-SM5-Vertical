local wheel
local screen

t = Def.ActorFrame{
	OnCommand=function(self)
		-- we are going to be using the screen and the wheel,
		-- but we will need them when the top screen is not ScreenSelectMusic
		-- so we have to get them here before any search happens
		screen = SCREENMAN:GetTopScreen()
		wheel = screen:GetMusicWheel()
	end,
	CodeMessageCommand=function(self, params)
		if params.Name:match("SongSearch") then
			self:playcommand("SearchSong")
		end
	end,
	SearchSongCommand=function(self)
                SCREENMAN:AddNewScreenToTop("ScreenTextEntry");
                local songSearch = {
                        Question = "Song name",
                        MaxInputLength = 255,
                        OnOK = function(answer)
				-- case insensitive search for a string
				-- in every song's title and subtitle
                                local results = {}
                                for i, Song in ipairs(SONGMAN:GetAllSongs()) do
                                        title = Song:GetDisplayFullTitle():lower()
                                        if title:match(answer:lower()) then
                                                results[#results+1] = Song
                                        end
                                end

				-- here we create a file in the "Other/" folder in the theme for every 
				-- search. you'll have to use an external tool to clean this folder since
				-- the theme can't delete files
                                if #results > 0 then
                                        filepath = THEME:GetCurrentThemeDirectory().."Other/SongManager "..answer..".txt"
                                        f = RageFileUtil.CreateRageFile()
                                        f:Open(filepath, 2) -- 2 = write
                                        f:PutLine("---Search Results") -- folder name
                                        for i, song in ipairs(results) do
                                                f:PutLine(song:GetGroupName().."/"..song:GetDisplayMainTitle()) -- song
                                        end
                                        f:Close()
                                        f:destroy()
                                        SONGMAN:SetPreferredSongs(answer..".txt")
                                        wheel:ChangeSort("SortOrder_Preferred")
					screen:SetNextScreenName("ScreenSelectMusic")
					screen:StartTransitioningScreen("SM_GoToNextScreen")
                                end
                        end,
                };
                SCREENMAN:GetTopScreen():Load(songSearch);
        end,
}

return t
