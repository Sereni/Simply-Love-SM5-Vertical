return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)
		if GetDivision() == nil then return end

		if ECS.Mode == "ECS" then
			if PlayerIsUpper() == nil then return end

			if PlayerIsUpper() then
				if GetDivision() == "upper" then
				local nachmancore = SONGMAN:FindSong("ECS10 - Upper/[22] [225] Nachmancore")
				if nachmancore then
					GAMESTATE:SetPreferredSong(nachmancore)
				end
			elseif GetDivision() == "mid" then
				local sukure = SONGMAN:FindSong("ECS10 - Mid/[17] [175] Sukure")
				if sukure then
					GAMESTATE:SetPreferredSong(sukure)
				end
			else
				local discovery = SONGMAN:FindSong("ECS10 - Lower/[12] [130] Discovery")
				if discovery then
					GAMESTATE:SetPreferredSong(discovery)
				end
			end
		elseif ECS.Mode == "Marathon" then
			if GetDivision() == "upper" then
				local memoriam = SONGMAN:FindSong("ECS10 - Upper Marathon/In Memoriam")
				if memoriam then
					GAMESTATE:SetPreferredSong(memoriam)
				end
			elseif GetDivision() == "mid" then
				local sideba = SONGMAN:FindSong("ECS10 - Mid Marathon/ECS Classics (Side B-A)")
				if sideba then
					GAMESTATE:SetPreferredSong(sideba)
				end
			else
				local sidea = SONGMAN:FindSong("ECS10 - Lower Marathon/ECS Classics (Side A)")
				if sidea then
					GAMESTATE:SetPreferredSong(sidea)
				end
			end
		end
	end
}
