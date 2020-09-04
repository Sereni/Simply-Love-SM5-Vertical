return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)

		if ECS.Mode == "ECS" then
			if PlayerIsUpper() == nil then return end

			if PlayerIsUpper() then
				local omlaah = SONGMAN:FindSong("ECS9 - Upper/[18] [186] One More Lovely (After After Hours) FP 186")
				if omlaah then
					GAMESTATE:SetPreferredSong(omlaah)
				end
			else
				local discovery = SONGMAN:FindSong("ECS9 - Lower/[12] [130] Discovery")
				if discovery then
					GAMESTATE:SetPreferredSong(discovery)
				else
					local ians_op = SONGMAN:FindSong("ECS9 - Lower/[17] [174] Ian's OP")
					if ians_op then
						GAMESTATE:SetPreferredSong(ians_op)
					end
				end
			end
		elseif ECS.Mode == "Marathon" then
			local stratospheric = SONGMAN:FindSong("ECS9 - Upper Marathon/Stratospheric Intricacy")
			if stratospheric then
				GAMESTATE:SetPreferredSong(stratospheric)
			end
		end
	end
}
