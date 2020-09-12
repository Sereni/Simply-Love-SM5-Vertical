ECS = {}

-- call this to (re)initialize per-player settings
InitializeECS = function()
	ECS.Mode = "Warmup"
	ECS.BreakTimer=(15 * 60)

	ECS.Player = {
		Profile=nil,
		Relics={},
		-- Use AddPlayedSongs to append to this table which will keep this table
		-- sorted in descending order of points.
		SongsPlayed={},
		TotalMarathonPoints=0,
	}
end

-- the master list
ECS.Relics = {
	{
		id=0,
		name="Stone Blade",
		desc="A low-level blade made from stone. Somewhat enhanced by the accuracy of your attacks.",
		effect="Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="stoneblade.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.1)
		end
	},
	{
		id=1,
		name="Stone Knife",
		desc="A low-level knife made from stone. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="stoneknife.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.dp * 0.1)
		end
	},
	{
		id=2,
		name="Stone Axe",
		desc="A low-level axe made from stone. Somewhat effective against large opponents.",
		effect="Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="stoneaxe.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.ep * 0.1)
		end
	},
	{
		id=3,
		name="Stone Arrow",
		desc="A low-level arrow tipped with stone. Deals weak damage with a bow equipped. Single use.",
		effect="+150 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="stonearrow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_bow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Long Bow" or name == "Eurytus Bow" or
				    name == "Artemis Bow" or name == "Twisted Bow") then
					has_bow = true
				end
			end
			if has_bow then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=4,
		name="Bronze Blade",
		desc="A mid-level blade made from bronze. Enhanced by the accuracy of your attacks.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeblade.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.2)
		end
	},
	{
		id=5,
		name="Bronze Knife",
		desc="A mid-level knife made from bronze. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeknife.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.dp * 0.2)
		end
	},
	{
		id=6,
		name="Bronze Axe",
		desc="A mid-level axe made from bronze. Effective against large opponents.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeaxe.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.ep * 0.2)
		end
	},
	{
		id=7,
		name="Bronze Arrow",
		desc="A mid-level arrow tipped with bronze. Deals good damage with a bow equipped. Single use.",
		effect="+350 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="bronzearrow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_bow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Long Bow" or name == "Eurytus Bow" or
				    name == "Artemis Bow" or name == "Twisted Bow") then
					has_bow = true
				end
			end
			if has_bow then
				return 350
			else
				return 0
			end
		end
	},
	{
		id=8,
		name="Mythril Blade",
		desc="A high-level blade made from mythril. Strongly enhanced by the accuracy of your attacks.",
		effect="Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilblade.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.3)
		end
	},
	{
		id=9,
		name="Mythril Knife",
		desc="A high-level knife made from mythril. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilknife.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.dp * 0.3)
		end
	},
	{
		id=10,
		name="Mythril Axe",
		desc="A high-level axe made from mythril. Strongly effective against large opponents.",
		effect="Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilaxe.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.ep * 0.3)
		end
	},
	{
		id=11,
		name="Mythril Arrow",
		desc="A high-level arrow tipped with mythril. Deals strong damage with a bow equipped. Single use.",
		effect="+650 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="mythrilarrow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_bow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Long Bow" or name == "Eurytus Bow" or
				    name == "Artemis Bow" or name == "Twisted Bow") then
					has_bow = true
				end
			end
			if has_bow then
				return 650
			else
				return 0
			end
		end
	},
	{
		id=12,
		name="Crystal Sword",
		desc="A stunningly beautiful crystal sword. Incredibly enhanced by the accuracy of your attacks.",
		effect="Lv. 4 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="crystalsword.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.4)
		end
	},
	{
		id=13,
		name="Diamond Sword",
		desc="An immaculate diamond sword. Maximally enhanced by the accuracy of your attacks.",
		effect="Lv. 5 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="diamondsword.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.5)
		end
	},
	{
		id=14,
		name="Shuriken",
		desc="Steel throwing star that can deal some good damage. Single use.",
		effect="+250 BP",
		is_consumable=true,
		is_marathon=false,
		img="shuriken.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 250
		end
	},
	{
		id=15,
		name="Astral Earring",
		desc="Earrings that possess a magic enchantment to deter The Bois.",
		effect="Decents/WayOffs Off",
		is_consumable=true,
		is_marathon=false,
		img="astralearring.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.TimingWindows = {true,true,true,false,false}
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW3)
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=16,
		name="Silver Stopwatch",
		desc="Stopwatch imbued with time magic.",
		effect="45 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="silverstopwatch.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 45
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=17,
		name="Blood Rune",
		desc="Made from the blood of DPRT convicts, this morbid rune is only used to charge a specific relic. Creepy. Single use.",
		effect="+300 BP with Scythe of Vitur equipped|45 seconds added to break timer with Scythe of Vitur equipped",
		is_consumable=true,
		is_marathon=false,
		img="bloodrune.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					-- Might be cleaner to pass in the relics used instead of accessing the global but meh it's fine.
					for active_relic in ivalues(ECS.Player.Relics) do
						if active_relic.name == "Scythe of Vitur" then
							ECS.BreakTimer = ECS.BreakTimer + 45
							return
						end
					end
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Scythe of Vitur" then
					return 300
				end
			end
			return 0
		end
	},
	{
		id=18,
		name="Lance of Longinus",
		desc="Extremely rare holy lance. Very effective against abominations.",
		effect="+3000 MP",
		is_consumable=false,
		is_marathon=true,
		img="lanceoflonginus.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- NOTE(teejusb): MP Relics will only show up during the marathon so
			-- returning the actual MP points is fine.
			return 3000
		end
	},
	{
		id=19,
		name="Mammon",
		desc="A massive war axe fueled by the essence of avarice. Has the potential to be extremely deadly.",
		effect="+600 BP for Rank 1 on Lifetime Song Gold|+BP based on Lifetime Song Gold for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		img="mammon.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- Determine Rank 1 gold by checking every player
			local all_gold_amounts = {}
			for name, player in ipairs(ECS.Players) do
				all_gold_amounts[#all_gold_amounts + 1] = player.lifetime_song_gold
			end
			table.sort(all_gold_amounts)

			local max_gold = all_gold_amounts[#all_gold_amounts]
			if max_gold == nil then return 0 end

			-- We need the 2nd highest as well for those that weren't rank 1
			local second_highest = nil
			for i = #all_gold_amounts, 1, -1 do
				if all_gold_amounts[i] < max_gold then
					second_highest = all_gold_amounts[i]
					break
				end
			end

			if max_gold == ecs_player.lifetime_song_gold then
				return 600
			else
				local second_highest = all_gold_amounts[#all_gold_amounts-1]
				if second_highest == nil then return 0 end
				return math.floor(400*(ecs_player.lifetime_song_gold / second_highest))
			end
		end
	},
	{
		id=20,
		name="Agility Potion",
		desc="Brewed in the Footspeed Empire by Arvin (who moonlights as a master alchemist), this potion grows more effective as you defeat fast enemies. Single use.",
		effect="At end of set, +BP equal to (average BPM of passed songs-120)^1.3",
		is_consumable=true,
		is_marathon=false,
		img="agilitypotion.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- TODO(teejusb): Handle end of set relics
			return 0
		end
	},
	{
		id=21,
		name="Dragon Arrow",
		desc="A vicious arrow tipped with a dragon fang. Strongly effective against fast opponents with a bow equipped. Single use.",
		effect="Lv. 3 DP Bonus with bow equipped|+500 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="dragonarrow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_bow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Long Bow" or name == "Eurytus Bow" or
				    name == "Artemis Bow" or name == "Twisted Bow") then
					has_bow = true
				end
			end
			if has_bow then
				return 500 + math.floor(song_data.dp * 0.3)
			else
				return 0
			end
		end
	},
	{
		id=22,
		name="Crystal Dagger",
		desc="A stunningly beautiful crystal dagger. Incredibly effective against fast opponents.",
		effect="Lv. 4 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="crystaldagger.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.dp * 0.4)
		end
	},
	{
		id=23,
		name="Diamond Dagger",
		desc="An immaculate diamond dagger. Maximally effective against fast opponents.",
		effect="Lv. 5 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="diamonddagger.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.dp * 0.5)
		end
	},
	{
		id=24,
		name="Twisted Bow",
		desc="Prized bow recovered from the Chambers of Xeric. Maximally effective against difficult opponents.",
		effect="Lv. 5 RP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="twistedbow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_arrow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Stone Arrow" or name == "Bronze Arrow" or name == "Mythril Arrow") then
					has_arrow = true
				end
			end
			if has_arrow then
				local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
				return math.floor(song_data.rp/(max_division_rp/1000)*0.5)
			else
				return 0
			end
		end
	},
	{
		id=25,
		name="Malefic Adumbration",
		desc="This dagger-- forged by Mad Matt deep within Mt. Sigatrev in ages past-- carries in it all the nice laughs, memes, and elitism of the Footspeed Empire. Transcendent effectiveness against fast opponents.",
		effect="+150 BP for tiers 270 and over|Lv. 6 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="maleficadumbration.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier >= 270 then
				bp = bp + 150
			end
			return bp + math.floor(song_data.dp * 0.6)
		end
	},
	{
		id=26,
		name="Ivory Tower",
		desc="It's not a place, it's a thing. Just like you. Only the truly jej can wield this monstrous double-bladed polearm effectively. ",
		effect="+600 BP for Rank 1 on Lifetime JP|+BP based on Lifetime JP for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		img="ivorytower.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- Determine Rank 1 JP by checking every player
			local all_jp_amounts = {}
			for name, player in ipairs(ECS.Players) do
				all_jp_amounts[#all_jp_amounts + 1] = player.lifetime_jp
			end
			table.sort(all_jp_amounts)

			local max_jp = all_jp_amounts[#all_jp_amounts]
			if max_jp == nil then return 0 end

			-- We need the 2nd highest as well for those that weren't rank 1
			local second_highest = nil
			for i = #all_jp_amounts, 1, -1 do
				if all_jp_amounts[i] < max_jp then
					second_highest = all_jp_amounts[i]
					break
				end
			end

			if max_jp == ecs_player.lifetime_jp then
				return 600
			else
				local second_highest = all_jp_amounts[#all_jp_amounts-1]
				if second_highest == nil then return 0 end
				return math.floor(400*(ecs_player.lifetime_jp / second_highest))
			end
		end
	},
	{
		id=27,
		name="Dirk",
		desc="Not to be confused with Big Dirk. #upsfanboy420. Single use.",
		effect="+150 BP for 130 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="dirk.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 130 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=28,
		name="Spike Knuckles",
		desc="A threatening-looking set of hand to hand weapons. Single use.",
		effect="+150 BP for 140 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="spikeknuckles.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 140 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=29,
		name="Shashka",
		desc="Standard-issue blade from the Slav Coast. Single use.",
		effect="+150 BP for 150 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="shashka.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 150 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=30,
		name="Barbed Lariat",
		desc="A tricky, mid-range weapon fashioned with painful barbs. Single use.",
		effect="+150 BP for 160 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="barbedlariat.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 160 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=31,
		name="Zweihander",
		desc="Wielded with two hands, this sword is a bit unbalanced, but packs a bunch. Single use.",
		effect="+150 BP for 170 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="zweihander.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 170 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=32,
		name="Long Bow",
		desc="If you've got a good arrow, this bow is capable of inflicting some serious pain from a long distance. Made from a sturdy but pliable wood.",
		effect="+100 BP for 180 BPM songs with arrow equipped|+50 BP with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="longbow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_arrow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Stone Arrow" or name == "Bronze Arrow" or name == "Mythril Arrow") then
					has_arrow = true
				end
			end
			if has_arrow then
				if song_data.bpm_tier == 180 then
					return 100 + 50
				else
					return 50
				end
			else
				return 0
			end
		end
	},
	{
		id=33,
		name="Epee",
		desc="Used by fencers, this weapon from French Coast Stamina is particularly useful for piercing weak spots in armor. Single use.",
		effect="+150 BP for 190 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="epee.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 190 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=34,
		name="Carolingian Sword",
		desc="An old, runed sword recovered from a fjord in Viking Coast Stamina. Single use.",
		effect="+150 BP for 200 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="carolingiansword.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 200 then
				return 150
			else
				return 0
			end
		end
	},
	{
		id=35,
		name="Regal Cutlass",
		desc="Practical, military-issue sword once used in the British Coast. Single use.",
		effect="+200 BP for 210 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="regalcutlass.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 210 then
				return 200
			else
				return 0
			end
		end
	},
	{
		id=36,
		name="Scythe",
		desc="Farming tool adapted for combat. Single use.",
		effect="+200 BP for 220 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="scythe.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 220 then
				return 200
			else
				return 0
			end
		end
	},
	{
		id=37,
		name="Jagged Greataxe",
		desc="A rough but effective battle axe. Single use.",
		effect="+200 BP for 230 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="jaggedgreataxe.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 230 then
				return 200
			else
				return 0
			end
		end
	},
	{
		id=38,
		name="Sakabato",
		desc="Once held by a repentant assassin, this katana's blade is on the wrong side. Single use.",
		effect="+200 BP for 240 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="sakabato.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 240 then
				return 200
			else
				return 0
			end
		end
	},
	{
		id=39,
		name="Heavy Glaive",
		desc="Nasty polearm that can do some serious damage. Single use.",
		effect="+200 BP for 250 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="heavyglaive.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 250 then
				return 200
			else
				return 0
			end
		end
	},
	{
		id=40,
		name="Double Warblade",
		desc="This double-bladed sword staff is difficult to master, but a menace to face in battle. Single use.",
		effect="+200 BP for 260 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="doublewarblade.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.bpm_tier == 260 then
				return 200
			else
				return 0
			end
		end
	},
	{
		id=41,
		name="Leavitas",
		desc="Sword tempered with the souls of slain n00bs. Levitas's left hand weapon. Incredibly effective against fast opponents.",
		effect="+100 BP for 270 BPM songs|Lv. 4 DP Bonus|+100 BP for tiers 280 and over with Laevitas equipped",
		is_consumable=false,
		is_marathon=false,
		img="leavitas.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_laevitas = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Laevitas" then
					has_laevitas = true
				end
			end
			local bp = 0
			if song_data.bpm_tier == 270 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp * 0.4)
			if has_laevitas and song_data.bpm_tier >= 280 then
				bp = bp + 100
			end
			return bp
		end
	},
	{
		id=42,
		name="Tizona",
		desc="Sword once used by a hero of Spanish Coast Stamina. Possesses strength that matches your skill.",
		effect="+BP equal to your skill in the speed tier",
		is_consumable=false,
		is_marathon=false,
		img="tizona.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return ecs_player.tier_skill[song_data.bpm_tier]
		end
	},
	{
		id=43,
		name="Zorlin Shape",
		desc="Sharp dagger with a uniquely shaped blade. Somewhat effective against fast opponents.",
		effect="+100 BP for 130 BPM songs|Lv. 1 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="zorlinshape.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 130 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp * 0.1)
			return bp
		end
	},
	{
		id=44,
		name="Cat's Claws",
		desc="These long claws can inflict some hurting at a close range. Somewhat enhanced by the accuracy of your attacks.",
		effect="+100 BP for 140 BPM songs|Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="catsclaws.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 140 then
				bp = bp + 100
			end
			bp = bp + math.floor(ap * 0.1)
			return bp
		end
	},
	{
		id=45,
		name="Samosek",
		desc="A magical, self-swinging sword originating from the Slav Coast. Somewhat effective against large opponents.",
		effect="+100 BP for 150 BPM songs|Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="samosek.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 150 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.1)
			return bp
		end
	},
	{
		id=46,
		name="Fire Lash",
		desc="This whip is wreathed in a magical flame that can induce painful burns. Effective against large opponents.",
		effect="+100 BP for 160 BPM songs|Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="firelash.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 160 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.2)
			return bp
		end
	},
	{
		id=47,
		name="Flamberge",
		desc="Two-handed long sword with a distinctive wave-shaped blade. Enhanced by the accuracy of your attacks.",
		effect="+100 BP for 170 BPM songs|Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="flamberge.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 170 then
				bp = bp + 100
			end
			bp = bp + math.floor(ap * 0.2)
			return bp
		end
	},
	{
		id=48,
		name="Eurytus Bow",
		desc="An ornately carved wooden bow made by a master craftsman. Effective against fast opponents.",
		effect="+100 BP for 180 BPM songs with arrow equipped|Lv. 2 DP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="eurytusbow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_arrow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Stone Arrow" or name == "Bronze Arrow" or name == "Mythril Arrow") then
					has_arrow = true
				end
			end
			if has_arrow then
				if song_data.bpm_tier == 180 then
					return 100 + math.floor(song_data.dp * 0.2)
				else
					return math.floor(song_data.dp * 0.2)
				end
			else
				return 0
			end
		end
	},
	{
		id=49,
		name="Hauteclere",
		desc="Formerly a favored weapon of a famous paladin from French Coast Stamina in ages past. Strongly effective against large opponents.",
		effect="+100 BP for 190 BPM songs|Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="hauteclere.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 190 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.3)
			return bp
		end
	},
	{
		id=50,
		name="Gram",
		desc="Legendary sword of the Viking Coast that was used to slay a dragon. Strongly effective against fast opponents.",
		effect="+100 BP for 200 BPM songs|Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="gram.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 200 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp * 0.3)
			return bp
		end
	},
	{
		id=51,
		name="Caliburn",
		desc="Pulled from a stone by an ancient king of the British Coast, this holy sword holds a deep history. Strongly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 210 BPM songs|Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="caliburn.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 210 then
				bp = bp + 100
			end
			bp = bp + math.floor(ap * 0.3)
			return bp
		end
	},
	{
		id=52,
		name="Doom Sickle",
		desc="A deadly scythe previously used by a sorcerer king. Incredibly effective against large opponents.",
		effect="+100 BP for 220 BPM songs|Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="doomsickle.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 220 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.4)
			return bp
		end
	},
	{
		id=53,
		name="Bravura",
		desc="This huge, single-bladed axe is designed for efficient killing. Incredible effectiveness against opponents that are both large and fast.",
		effect="+100 BP for 230 BPM songs|Lv. 4 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bravura.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 230 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp_ep * 0.4)
			return bp
		end
	},
	{
		id=54,
		name="Kusanagi",
		desc="Katana rumored to have been bequeathed to the early rulers of Japan Coast Stamina by a goddess. Incredibly effective against fast opponents.",
		effect="+100 BP for 240 BPM songs|Lv. 4 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="kusanagi.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 240 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp * 0.4)
			return bp
		end
	},
	{
		id=55,
		name="Gae Buide",
		desc="Vicious cursed spear that inflicts wounds that can't be healed. Maximum effectiveness against large opponents.",
		effect="+100 BP for 250 BPM songs|Lv. 5 EP Bonus|Lv. 1 AP Bonus if Gae Derg is equipped",
		is_consumable=false,
		is_marathon=false,
		img="gaebuide.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 250 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.5)
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Gae Derg" then
					bp = bp + math.floor(ap * 0.1)
				end
			end
			return bp
		end
	},
	{
		id=56,
		name="Endurend",
		desc="An exotic polearm sporting a pair of colorful and extraordinarily sharp blades. Maximum effectiveness against opponents that are both large and fast.",
		effect="+100 BP for 260 BPM songs|Lv. 5 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="endurend.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 260 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp_ep * 0.5)
			return bp
		end
	},
	{
		id=57,
		name="Laevitas",
		desc="Overflowing with magical footspeed energy, this is Levitas's right hand weapon. Maximum effectiveness against fast opponents.",
		effect="+100 BP for 270 BPM songs|Lv. 5 DP Bonus|+100 BP for tiers 280 and over with Leavitas equipped",
		is_consumable=false,
		is_marathon=false,
		img="laevitas.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_leavitas = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Leavitas" then
					has_leavitas = true
				end
			end
			local bp = 0
			if song_data.bpm_tier == 270 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.dp * 0.5)
			if has_leavitas and song_data.bpm_tier >= 280 then
				bp = bp + 100
			end
			return bp
		end
	},
	{
		id=58,
		name="Armajejjon",
		desc="Being the most jej of all weapons, this massive scythe has been wielded by heroes and miscreants of the recent past.",
		effect="+700 BP|30 seconds removed from break timer",
		is_consumable=false,
		is_marathon=false,
		img="armajejjon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				ECS.BreakTimer = ECS.BreakTimer - 30
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 700
		end
	},
	{
		id=59,
		name="Tiger Fangs",
		desc="Unusual claws fashioned from the fangs of a wild beast. Somewhat effective against large opponents.",
		effect="+150 BP for 140 BPM songs|Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="tigerfangs.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 140 then
				bp = bp + 150
			end
			bp = bp + math.floor(song_data.ep * 0.4)
			return bp
		end
	},
	{
		id=60,
		name="Kladenets",
		desc="Often confused with Samosek, this is another magic sword from the Slav Coast that, uh, can also swing itself. One might be tempted to say they were one in the same if it wasn't for the fact that they look different. Enhanced by the accuracy of your attacks.",
		effect="+100 BP for 150 BPM songs|Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="kladenets.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 150 then
				bp = bp + 100
			end
			bp = bp + math.floor(ap * 0.2)
			return bp
		end
	},
	{
		id=61,
		name="Vampire Killer",
		desc="Whip favored by a clan of vampire hunters (and rawinput). Effective against fast opponents.",
		effect="+150 BP for 160 BPM songs|Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="vampirekiller.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 160 then
				bp = bp + 150
			end
			bp = bp + math.floor(song_data.dp * 0.2)
			return bp
		end
	},
	{
		id=62,
		name="Pandemonium",
		desc="The Godfather's weapon of choice. Strongly effective against large opponents.",
		effect="+100 BP for 170 BPM songs|Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="pandemonium.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 170 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.3)
			return bp
		end
	},
	{
		id=63,
		name="Artemis Bow",
		desc="Supposedly once wielded by a goddess of many myths, this pristine bow is strongly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 180 BPM songs with arrow equipped|Lv. 3 AP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="artemisbow.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local has_arrow = false
			for relic in ivalues(relics_used) do
				local name = relic.name
				if (name == "Stone Arrow" or name == "Bronze Arrow" or name == "Mythril Arrow") then
					has_arrow = true
				end
			end
			if has_arrow then
				if song_data.bpm_tier == 180 then
					return 100 + math.floor(ap * 0.3)
				else
					return math.floor(ap * 0.3)
				end
			else
				return 0
			end
		end
	},
	{
		id=64,
		name="Durandal",
		desc="Indestructible sword once held by a hero of the French Coast. Strongly effective against fast opponents.",
		effect="+150 BP for 190 BPM songs|Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="durandal.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 190 then
				bp = bp + 150
			end
			bp = bp + math.floor(song_data.dp * 0.3)
			return bp
		end
	},
	{
		id=65,
		name="Skofnung",
		desc="The greatest of all swords forged in the Viking Coast, this weapon is said to be imbued with the souls of berserkers from the distant past. Strongly effective against large opponents.",
		effect="+150 BP for 200 BPM songs|Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="skofnung.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 200 then
				bp = bp + 150
			end
			bp = bp + math.floor(song_data.ep * 0.3)
			return bp
		end
	},
	{
		id=66,
		name="Clarent",
		desc="Known as a sword of peace, this holy sword was used in ceremonies by a legendary king of British Coast Stamina. Incredibly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 210 BPM songs|Lv. 4 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="clarent.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 210 then
				bp = bp + 100
			end
			bp = bp + math.floor(ap * 0.4)
			return bp
		end
	},
	{
		id=67,
		name="Scythe of Vitur",
		desc="Cruel and brutal, this horrific weapon can be enhanced by Blood Runes from the Border Shop to add to its capabilities. Incredibly effective against large opponents.",
		effect="+200 BP for 220 BPM songs|Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="scytheofvitur.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 220 then
				bp = bp + 200
			end
			bp = bp + math.floor(song_data.ep * 0.4)
			return bp
		end
	},
	{
		id=68,
		name="Wuuthrad",
		desc="An enormous ebony axe wrought to bring blight upon the elves. Incredibly effective against large opponents.",
		effect="+200 BP for 230 BPM songs|Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="wuuthrad.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 230 then
				bp = bp + 200
			end
			bp = bp + math.floor(song_data.ep * 0.4)
			return bp
		end
	},
	{
		id=69,
		name="Masamune",
		desc="Long, dangerous katana made by a legendary swordsmith. Incredible effectiveness against opponents that are both large and fast.",
		effect="+200 BP for 240 BPM songs|Lv. 4 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="masamune.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 240 then
				bp = bp + 200
			end
			bp = bp + math.floor(song_data.dp_ep * 0.4)
			return bp
		end
	},
	{
		id=70,
		name="Gae Derg",
		desc="Spear with the ability to rend magic fields. Maximum effectiveness against large opponents.",
		effect="+200 BP for 250 BPM songs|Lv. 5 EP Bonus|Lv. 1 RP Bonus if Gae Buide is equipped",
		is_consumable=false,
		is_marathon=false,
		img="gaederg.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 250 then
				bp = bp + 200
			end
			bp = bp + math.floor(song_data.ep * 0.5)
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Gae Buide" then
					local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
					bp = bp + math.floor(song_data.rp/(max_division_rp/1000)*0.1)
				end
			end
			return bp
		end
	},
	{
		id=71,
		name="Endless River",
		desc="Transcendent effectiveness against large opponents.",
		effect="+150 BP for tiers 260 and under|Lv. 6 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="endlessriver.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier <= 260 then
				bp = bp + 150
			end
			bp = bp + math.floor(song_data.ep * 0.6)
			return bp
		end
	},
	{
		id=72,
		name="Sword, Made of Steel",
		desc="Strike like dragons, have no fear!",
		effect="+100 BP",
		is_consumable=false,
		is_marathon=false,
		img="swordmadeofsteel.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 100
		end
	},
	{
		id=73,
		name="Pendulum Blade",
		desc="One of those swinging-blade dungeon traps. How are you even planning on using it without hurting yourself?",
		effect="+200 BP|Lv. 4 RP Bonus|Forces life 5",
		is_consumable=false,
		is_marathon=false,
		img="pendulumblade.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
			return 200 + math.floor(song_data.rp/(max_division_rp/1000)*0.4)
		end
	},
	{
		id=74,
		name="Baguette",
		desc="A week old baguette.",
		effect="Lv. 4 RP Bonus on any French Coast Stamina/BaguetteStreamz songs",
		is_consumable=true,
		is_marathon=false,
		img="baguette.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			if song_data.pack:lower():find("baguettestreamz") ~= nil or song_data.pack:lower():find("french coast stamina") then
				local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
				return math.floor(song_data.rp/(max_division_rp/1000)*0.4)
			else
				return 0
			end
		end
	},
	{
		id=75,
		name="Steel Wheat Bun",
		desc="A bun made from Steel Wheat, an extremely hardy and nutritious variety that grows in Texas Coast Stamina.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="steelwheatbun.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=76,
		name="Lon Lon Cheese",
		desc="High grade cheese made from the famous milk of Lon Lon Ranch. Delicious.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="lonloncheese.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=77,
		name="Mandragora Lettuce",
		desc="Valued for its unique taste, this lettuce is considered to have the best flavor when it's harvested from a live mandragora. Considering how dangerous Mandragora are, that presents quite a bit of a problem for any would-be collectors.",
		effect="None",
		img="mandragoralettuce.png",
		is_consumable=true,
		is_marathon=false,
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=78,
		name="Maxim Tomato",
		desc="These huge tomatoes are thought to have healing properties. And they also have a big M on them.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="maximtomato.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=79,
		name="Dire Kangaroo Patty",
		desc="Made from the ground-up meat of a kangaroo variety native to East Coast Straya that can grow to be as tall as 9 meters. Considered a delicacy for its rarity.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="direkangaroopatty.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=80,
		name="BURGER",
		desc="The ultimate burger, formed from expertly chosen ingredients in perfect harmony with one another. You can practically taste the aura of delicious burgerness radiating from it. Truly a divine entree.",
		effect="+1000 BP|The BP here stands for Burger Points|The Burger Points don't do anything",
		is_consumable=true,
		is_marathon=false,
		img="burger.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=81,
		name="Fursuit",
		desc="'WEAR THIS TO BECOME STRAIGHT'\n\n--Zetorux (when asked for a relic description), 4 ABP",
		effect="Lv. 1 EP Bonus|Lv. 1 DP Bonus|Lv. 1 RP Bonus|Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="fursuit.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
			return math.floor(song_data.ep * 0.1) + math.floor(song_data.dp * 0.1) + math.floor(ap * 0.1) + math.floor(song_data.rp/(max_division_rp/1000)*0.1)
		end
	},
	{
		id=82,
		name="Cowboy Hat",
		desc="I reckon this here hat belongs to Rust! Yeehaw ! ! !",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="cowboyhat.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=83,
		name="GUNgnir",
		desc="Enchanted spear that supposedly never misses its mark... except some idiot tied a gun to the tip, which will probably blow it apart when you use it. What a dumb design.",
		effect="Lv. 4 DP Bonus|1/2 chance of forced life 3",
		is_consumable=true,
		is_marathon=false,
		img="gungnir.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				if math.random() < 1.0/2.0 then
					local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
					if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
						PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
						SM("Set to Life 3")
					end
				else
					SM("No Effect")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.dp * 0.4)
		end
	},
	{
		id=84,
		name="Ryuko's Scissor Blade",
		desc="Capable of changing size, this is half of a giant pair of scissors. It's pretty good at destroying clothes.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="ryukosscissorblade.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(song_data.ep * 0.2)
		end
	},
	{
		id=85,
		name="Nui's Scissor Blade",
		desc="Once used by the Grand Couturier of a nefarious textile company, this massive scissor blade can change forms depending on the user.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="nuisscissorblade.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.2)
		end
	},
	{
		id=86,
		name="Rending Scissors",
		desc="Designed to sever life fibers, these huge scissors constitute a sizable threat to anyone that isn't naked.",
		effect="Lv. 2 AP Bonus|Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="rendingscissors.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.2) + math.floor(song_data.ep * 0.2)
		end
	},
	{
		id=87,
		name="Buster Sword",
		desc="Previously owned by various spikey haired warriors, this broadsword has inherited the hopes of those who fight.",
		effect="+77 BP",
		is_consumable=false,
		is_marathon=false,
		img="bustersword.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 77
		end
	},
	{
		id=88,
		name="Vampiric Longsword",
		desc="Originally conferred unto those who sought to challenge a many-tentacled Horror, this weapon absorbs the lifeforce of your enemies.",
		effect="+50 BP per minute of song length|18% of song length added to break timer",
		is_consumable=false,
		is_marathon=false,
		img="vampiriclongsword.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					-- BreakTimer is in seconds.
					ECS.BreakTimer = ECS.BreakTimer + (song_data.length * 60 * 0.18)
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 50 * math.floor(song_data.length)
		end
	},
	{
		id=89,
		name="Shards of Narsil",
		desc="These are shards from a legendary sword? Probably? Single use.",
		effect="Lv. 4 AP Bonus",
		is_consumable=true,
		is_marathon=false,
		img="shardsofnarsil.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.4)
		end
	},
	{
		id=90,
		name="Anduril",
		desc="Forged from the Shards of Narsil, this new weapon hails the return of the king. Transcendentally enhanced by the accuracy of your attacks.",
		effect="Lv. 6 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="anduril.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return math.floor(ap * 0.6)
		end
	},
	{
		id=91,
		name="Perish",
		desc="Possesses abominable power, but carries great risk with its use.",
		effect="+700 BP|Forces life 5",
		is_consumable=false,
		is_marathon=false,
		img="perish.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 700
		end
	},
	{
		id=92,
		name="Claiomh Solais",
		desc="Powerful sword once wielded by a paladin. Contains the essence of sacred fire and is extremely effective against abominations.",
		effect="+2000 MP",
		is_consumable=false,
		is_marathon=true,
		img="claiomhsolais.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- NOTE(teejusb): MP Relics will only show up during the marathon so
			-- returning the actual MP points is fine.
			return 2000
		end
	},
	{
		id=93,
		name="Aegis",
		desc="Shield previously used by a paladin. Very effective protection against various opponents.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=false,
		img="aegis.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
					SM("Set to Life 3")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=94,
		name="Throne",
		desc="A strange, sentient-throne familiar. Will come to your aid against abominations.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=true,
		img="throne.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
					SM("Set to Life 3")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=95,
		name="Skull Ring",
		desc="Magic ring that manipulates the flow of time in your favor -- at a price.",
		effect="Adds 60 seconds to the break timer|Forces life 5",
		is_consumable=true,
		is_marathon=false,
		img="skullring.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			elseif SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 60
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=96,
		name="Astral Ring",
		desc="Ring that possesses a magic enchantment to deter The Bois when you're facing abominations.",
		effect="Decents/WayOffs Off",
		is_consumable=true,
		is_marathon=true,
		img="astralring.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.TimingWindows = {true,true,true,false,false}
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW3)
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=97,
		name="Protect Ring",
		desc="Onyx ring imbued with powerful magic that will protect your life.",
		effect="Forces life 1",
		is_consumable=true,
		is_marathon=false,
		img="protectring.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.6) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.6)
					SM("Set to Life 1")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=98,
		name="Champion Belt",
		desc="Belt presented to the greatest champions of Stamina Nation. Single use.",
		effect="+100 BP|Allows user to equip one additional relic",
		is_consumable=true,
		is_marathon=false,
		img="championbelt.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			return 100
		end
	},
	{
		id=99,
		name="Bronze Trophy",
		desc="The Stamina Corps awards these trophies to fledgling staminadventurers as thanks for their good deeds.",
		effect="Access to #bronze-bistro on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="bronzetrophy.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=100,
		name="Mythril Trophy",
		desc="A trophy made from a rare metal. Only given to those who have made substantial contributions to the Stamina Nation.",
		effect="Access to #mythril-lounge on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="mythriltrophy.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=101,
		name="Crystal Trophy",
		desc="Awarded to high class staminadventurers for exceptional achievements.",
		effect="Access to #crystal-cafe on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="crystaltrophy.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=102,
		name="Slime Badge",
		desc="A cheaply made badge presented to you by the Stamina Corps for services rendered.",
		effect="At end of set, +100 BP for each song with a different speed tier",
		is_consumable=true,
		is_marathon=false,
		img="slimebadge.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- TODO(teejusb): Handle end of set relics
			return 0
		end
	},
	{
		id=103,
		name="Stamina Potion",
		desc="Engineered by Tom No Bar for use in the Stamina Corps, this potion grows more effective as you defeat large enemies. Single use.",
		effect="At end of set, +BP equal to total steps of passed songs divided by 75",
		is_consumable=true,
		is_marathon=false,
		img="staminapotion.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- TODO(teejusb): Handle end of set relics
			return 0
		end
	},
	{
		id=104,
		name="Golden Stopwatch",
		desc="Ornate stopwatch imbued with powerful time magic.",
		effect="90 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="goldenstopwatch.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 90
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=105,
		name="Arvin's Gambit",
		desc="Well-known set of playing cards from the Footspeed Empire. Highly prized for their magical qualities.",
		effect="If equipped, and you fail the marathon, you may reattempt it immediately with up to 20 additional minutes to warm up/fix the pads.",
		is_consumable=true,
		is_marathon=true,
		img="arvinsgambit.png",
		action=function()
		-- NOTE(teejusb): Handled in Graphics/_header.lua
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=106,
		name="Pandemonium Zero",
		desc="Forged by the Godfather in Chimney Rock on the Misty Moor, this weapon grows in strength alongside its wielder.",
		effect="+600 BP for Rank 1 on Lifetime EXP|+BP based on Lifetime EXP for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		img="pandemoniumzero.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			-- Determine Rank 1 EXP by checking every player
			local max_exp = 0
			for name, player in ipairs(ECS.Players) do
				max_exp = math.max(player.exp, max_exp)
			end

			if max_exp == ecs_player.exp then
				return 600
			else
				return math.floor(400*(ecs_player.level / 100))
			end
		end
	},
	{
		id=107,
		name="Faust's Scalpel",
		desc="This massive scalpel has the ability to split abominations in two.",
		effect="If equipped, the marathon is split into two parts, and you may take up to five minutes of break between them.",
		is_consumable=true,
		is_marathon=true,
		img="faustsscalpel.png",
		action=function()
		-- TODO(teejusb)
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
	{
		id=108,
		name="Reid",
		desc="Peerless sword passed down by a line of sword saints. The blade can only be drawn from its sheath against worthy adversaries. Transcendent effectiveness against difficult opponents.",
		effect="Lv. 6 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="reid.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap)
			local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
			return math.floor(song_data.rp/(max_division_rp/1000)*0.6)
		end
	},
	{
		id=109,
		name="Order of Ambrosia",
		desc="The greatest of honors bestowed upon staminadventurers.",
		effect="Allows user to equip an additional two relics",
		is_consumable=true,
		is_marathon=false,
		img="orderofambrosia.png",
		action=function() end,
		score=function(ecs_player, song_info, song_data, relics_used, ap) return 0 end
	},
}

ECS.GetRelicNames = function( list )
	-- if a player's list of relics isn't passed, use the master list
	if not list then list = ECS.Relics end

	local names = {}
	for relic in ivalues(list) do
		names[#names+1] = relic.name
	end
	return names
end

-- ------------------------------------------------------
-- Song Data

ECS.SongInfo = {}
ECS.SongInfo.Lower = {
	-- These values will be calculated and set below.
	MinBpm = 0,
	MaxBpm = 0,
	MinScaled16ths = 0,
	MaxScaled16ths = 0,
	MinBlockLevel = 0,
	MaxBlockLevel = 0,
	MinLength = 0,
	Songs = {
		{
			id=1,
			name="[12] [130] Once and Future King",
			pack="Kamelot",
			difficulty=12,
			steps=1738,
			bpm_tier=130,
			measures=98,
			adj_stream=0.7424,
			bpm=130,
			length=4.4,
			dp=0, ep=934, dp_ep=200, rp=1000,
		},
		{
			id=2,
			name="[12] [130] Discovery",
			pack="StoryTime Chapter 1",
			difficulty=12,
			steps=1931,
			bpm_tier=130,
			measures=110,
			adj_stream=0.7971,
			bpm=130,
			length=4.4,
			dp=0, ep=1000, dp_ep=299, rp=1000,
		},
		{
			id=3,
			name="[12] [133] Crazy Loop (Mm Ma Ma)",
			pack="Xynn's LVTS 2",
			difficulty=12,
			steps=1457,
			bpm_tier=130,
			measures=82,
			adj_stream=0.7664,
			bpm=133,
			length=3.55,
			dp=100, ep=800, dp_ep=149, rp=1000,
		},
		{
			id=4,
			name="[12] [136] The Ones We Loved (Dogzilla Remix)",
			pack="TranceMania 3",
			difficulty=12,
			steps=1927,
			bpm_tier=130,
			measures=86,
			adj_stream=0.6772,
			bpm=136,
			length=4.94,
			dp=200, ep=667, dp_ep=100, rp=1000,
		},
		{
			id=5,
			name="[12] [140] Beyond Life",
			pack="Helblinde 2016",
			difficulty=12,
			steps=1907,
			bpm_tier=140,
			measures=105,
			adj_stream=0.6688,
			bpm=140,
			length=4.63,
			dp=334, ep=867, dp_ep=601, rp=1000,
		},
		{
			id=6,
			name="[12] [140] Zi-Zi's Journey",
			pack="Lindsey Stirling",
			difficulty=12,
			steps=1373,
			bpm_tier=140,
			measures=77,
			adj_stream=0.7476,
			bpm=140,
			length=3.29,
			dp=334, ep=734, dp_ep=401, rp=1000,
		},
		{
			id=7,
			name="[12] [145] Pernicious Deed",
			pack="Nav's Spicy Singles",
			difficulty=12,
			steps=1892,
			bpm_tier=140,
			measures=84,
			adj_stream=0.5316,
			bpm=145,
			length=5.6,
			dp=500, ep=534, dp_ep=350, rp=1000,
		},
		{
			id=8,
			name="[12] [146] Wastelands",
			pack="Mozee Metal",
			difficulty=12,
			steps=1807,
			bpm_tier=140,
			measures=82,
			adj_stream=0.6165,
			bpm=146,
			length=4.55,
			dp=534, ep=600, dp_ep=500, rp=1000,
		},
		{
			id=9,
			name="[12] [150] EdenEcho",
			pack="Kamelot",
			difficulty=12,
			steps=1492,
			bpm_tier=150,
			measures=61,
			adj_stream=0.4388,
			bpm=150,
			length=4,
			dp=667, ep=400, dp_ep=400, rp=1000,
		},
		{
			id=10,
			name="[12] [150] The Sampling Paradise (Extended)",
			pack="SlowStreamz",
			difficulty=12,
			steps=2126,
			bpm_tier=150,
			measures=64,
			adj_stream=0.3596,
			bpm=150,
			length=5.12,
			dp=667, ep=334, dp_ep=301, rp=1000,
		},
		{
			id=11,
			name="[12] [150] Blood Is Pumpin' (Hard)",
			pack="SlowStreamz",
			difficulty=12,
			steps=1891,
			bpm_tier=150,
			measures=49,
			adj_stream=0.3063,
			bpm=150,
			length=5.52,
			dp=667, ep=134, dp_ep=0, rp=1000,
		},
		{
			id=12,
			name="[12] [156] Wheelpower & Go",
			pack="Eurobeat Is Fantastic",
			difficulty=12,
			steps=1528,
			bpm_tier=150,
			measures=43,
			adj_stream=0.3094,
			bpm=156,
			length=3.77,
			dp=867, ep=67, dp_ep=200, rp=1000,
		},
		{
			id=13,
			name="[12] [160] Speedy Runner",
			pack="Eurobeat Is Fantastic",
			difficulty=12,
			steps=1469,
			bpm_tier=160,
			measures=45,
			adj_stream=0.2866,
			bpm=160,
			length=4.13,
			dp=1000, ep=0, dp_ep=299, rp=1000,
		},
		{
			id=14,
			name="[12] [160] Stay Awake (Hard)",
			pack="Hospitality",
			difficulty=12,
			steps=1114,
			bpm_tier=160,
			measures=47,
			adj_stream=0.4123,
			bpm=160,
			length=3.4,
			dp=1000, ep=200, dp_ep=600, rp=1000,
		},
		{
			id=15,
			name="[12] [160] When the Sun Goes Down (Medium)",
			pack="Eurobeat Is Fantastic",
			difficulty=12,
			steps=1638,
			bpm_tier=160,
			measures=53,
			adj_stream=0.4015,
			bpm=160,
			length=4.35,
			dp=1000, ep=267, dp_ep=700, rp=1000,
		},
		{
			id=16,
			name="[12] [160] Drink",
			pack="Squirrel Metal II",
			difficulty=12,
			steps=1612,
			bpm_tier=160,
			measures=62,
			adj_stream=0.5536,
			bpm=160,
			length=3.32,
			dp=1000, ep=467, dp_ep=1000, rp=1000,
		},
		{
			id=17,
			name="[13] [132] No Shields",
			pack="SlowStreamz",
			difficulty=13,
			steps=2290,
			bpm_tier=130,
			measures=135,
			adj_stream=0.8766,
			bpm=132,
			length=5.21,
			dp=0, ep=895, dp_ep=335, rp=2000,
		},
		{
			id=18,
			name="[13] [134] March of the ants",
			pack="The Starter Pack of Stamina",
			difficulty=13,
			steps=1652,
			bpm_tier=130,
			measures=101,
			adj_stream=0.9902,
			bpm=134,
			length=3.43,
			dp=47, ep=790, dp_ep=244, rp=2000,
		},
		{
			id=19,
			name="[13] [138] Alone Tonight (Ronski Speed Remix)",
			pack="SlowStreamz",
			difficulty=13,
			steps=3305,
			bpm_tier=130,
			measures=190,
			adj_stream=0.819,
			bpm=138,
			length=7.33,
			dp=140, ep=1000, dp_ep=722, rp=2000,
		},
		{
			id=20,
			name="[13] [138] On A Good Day Above & Beyond Club Mix",
			pack="BaguetteStreamz",
			difficulty=13,
			steps=3487,
			bpm_tier=130,
			measures=200,
			adj_stream=0.7576,
			bpm=138,
			length=7.8,
			dp=140, ep=948, dp_ep=640, rp=2000,
		},
		{
			id=21,
			name="[13] [140] Switch !",
			pack="Eurobeat Is Fantastic",
			difficulty=13,
			steps=2259,
			bpm_tier=140,
			measures=117,
			adj_stream=0.7905,
			bpm=140,
			length=5.03,
			dp=187, ep=632, dp_ep=215, rp=2000,
		},
		{
			id=22,
			name="[13] [140] Blue Destination",
			pack="Trails of Cold Stream",
			difficulty=13,
			steps=2058,
			bpm_tier=140,
			measures=119,
			adj_stream=0.8686,
			bpm=140,
			length=4.23,
			dp=187, ep=737, dp_ep=381, rp=2000,
		},
		{
			id=23,
			name="[13] [140] Set Me On Fire (Novice)",
			pack="Pendulum Act III",
			difficulty=13,
			steps=2391,
			bpm_tier=140,
			measures=142,
			adj_stream=0.8402,
			bpm=140,
			length=5.09,
			dp=187, ep=843, dp_ep=549, rp=2000,
		},
		{
			id=24,
			name="[13] [145] Sa'eed",
			pack="SlowStreamz",
			difficulty=13,
			steps=2881,
			bpm_tier=140,
			measures=153,
			adj_stream=0.6955,
			bpm=145,
			length=6.62,
			dp=303, ep=685, dp_ep=482, rp=2000,
		},
		{
			id=25,
			name="[13] [150] Louder",
			pack="Hardbass Madness",
			difficulty=13,
			steps=2021,
			bpm_tier=150,
			measures=86,
			adj_stream=0.5772,
			bpm=150,
			length=4.4,
			dp=419, ep=264, dp_ep=0, rp=2000,
		},
		{
			id=26,
			name="[13] [150] RAVE2000009",
			pack="Sharpnelstreamz v2",
			difficulty=13,
			steps=2004,
			bpm_tier=150,
			measures=98,
			adj_stream=0.6853,
			bpm=150,
			length=4.11,
			dp=419, ep=579, dp_ep=498, rp=2000,
		},
		{
			id=27,
			name="[13] [154] Deja Vu",
			pack="Eurobeat Is Fantastic",
			difficulty=13,
			steps=1996,
			bpm_tier=150,
			measures=94,
			adj_stream=0.6763,
			bpm=154,
			length=4.13,
			dp=512, ep=474, dp_ep=479, rp=2000,
		},
		{
			id=28,
			name="[13] [155] Aphasia",
			pack="Team Grimoire",
			difficulty=13,
			steps=2057,
			bpm_tier=150,
			measures=97,
			adj_stream=0.6736,
			bpm=155,
			length=3.98,
			dp=535, ep=527, dp_ep=599, rp=2000,
		},
		{
			id=29,
			name="[13] [160] The Top",
			pack="Eurobeat Is Fantastic",
			difficulty=13,
			steps=1457,
			bpm_tier=160,
			measures=62,
			adj_stream=0.6019,
			bpm=160,
			length=3.22,
			dp=652, ep=106, dp_ep=119, rp=2000,
		},
		{
			id=30,
			name="[13] [160] GravitoN",
			pack="VocaJawnz II",
			difficulty=13,
			steps=1467,
			bpm_tier=160,
			measures=71,
			adj_stream=0.5868,
			bpm=160,
			length=3.7,
			dp=652, ep=158, dp_ep=201, rp=2000,
		},
		{
			id=31,
			name="[13] [162] Uh...Man",
			pack="Jayrocking",
			difficulty=13,
			steps=1890,
			bpm_tier=160,
			measures=91,
			adj_stream=0.6408,
			bpm=162,
			length=3.78,
			dp=698, ep=422, dp_ep=691, rp=2000,
		},
		{
			id=32,
			name="[13] [165] P.L.U.C.K. (Medium)",
			pack="System of a Down",
			difficulty=13,
			steps=1520,
			bpm_tier=160,
			measures=67,
			adj_stream=0.6505,
			bpm=165,
			length=3.42,
			dp=768, ep=211, dp_ep=468, rp=2000,
		},
		{
			id=33,
			name="[13] [175] Timeleap",
			pack="Comiket 95",
			difficulty=13,
			steps=2023,
			bpm_tier=170,
			measures=86,
			adj_stream=0.6232,
			bpm=165,
			length=4.23,
			dp=768, ep=369, dp_ep=718, rp=2000,
		},
		{
			id=34,
			name="[13] [170] Lost in Singularity",
			pack="Helblinde 2016",
			difficulty=13,
			steps=1566,
			bpm_tier=170,
			measures=52,
			adj_stream=0.4602,
			bpm=170,
			length=3.79,
			dp=884, ep=0, dp_ep=318, rp=2000,
		},
		{
			id=35,
			name="[13] [174] Come & Get It",
			pack="Hospitality",
			difficulty=13,
			steps=1267,
			bpm_tier=170,
			measures=57,
			adj_stream=0.5534,
			bpm=174,
			length=3.03,
			dp=977, ep=53, dp_ep=549, rp=2000,
		},
		{
			id=36,
			name="[13] [175] Sakura Fubuki (Ata Remix)",
			pack="ITGAlex's Stamina Safari",
			difficulty=13,
			steps=1237,
			bpm_tier=170,
			measures=63,
			adj_stream=0.7159,
			bpm=175,
			length=2.83,
			dp=1000, ep=316, dp_ep=1000, rp=2000,
		},
		{
			id=37,
			name="[14] [140] Dreamenddischarger",
			pack="SlowStreamz",
			difficulty=14,
			steps=4638,
			bpm_tier=140,
			measures=277,
			adj_stream=0.8602,
			bpm=140,
			length=9.37,
			dp=0, ep=1000, dp_ep=415, rp=3000,
		},
		{
			id=38,
			name="[14] [140] Pendulum",
			pack="Stephcharts and Richarts 2",
			difficulty=14,
			steps=5444,
			bpm_tier=140,
			measures=306,
			adj_stream=0.7727,
			bpm=140,
			length=11.37,
			dp=0, ep=895, dp_ep=115, rp=3000,
		},
		{
			id=39,
			name="[14] [145] Mala",
			pack="SlowStreamz",
			difficulty=14,
			steps=3508,
			bpm_tier=140,
			measures=209,
			adj_stream=0.9048,
			bpm=145,
			length=7.37,
			dp=112, ep=843, dp_ep=286, rp=3000,
		},
		{
			id=40,
			name="[14] [147] Moscow 3980",
			pack="SlowStreamz",
			difficulty=14,
			steps=4273,
			bpm_tier=140,
			measures=249,
			adj_stream=0.9055,
			bpm=147,
			length=7.97,
			dp=156, ep=948, dp_ep=712, rp=3000,
		},
		{
			id=41,
			name="[14] [150] Meteor 36.0",
			pack="VocaJawnz",
			difficulty=14,
			steps=2110,
			bpm_tier=150,
			measures=125,
			adj_stream=0.8741,
			bpm=150,
			length=4.03,
			dp=223, ep=632, dp_ep=0, rp=3000,
		},
		{
			id=42,
			name="[14] [150] Eyes Of Sky",
			pack="Eurobeat Is Fantastic 2",
			difficulty=14,
			steps=2109,
			bpm_tier=150,
			measures=121,
			adj_stream=0.8963,
			bpm=150,
			length=4.16,
			dp=223, ep=685, dp_ep=152, rp=3000,
		},
		{
			id=43,
			name="[14] [154] Gas Gas Gas",
			pack="Eurobeat Is Fantastic",
			difficulty=14,
			steps=2443,
			bpm_tier=150,
			measures=143,
			adj_stream=0.8363,
			bpm=154,
			length=4.52,
			dp=312, ep=790, dp_ep=706, rp=3000,
		},
		{
			id=44,
			name="[14] [158] Full Circle",
			pack="???",
			difficulty=14,
			steps=3459,
			bpm_tier=150,
			measures=174,
			adj_stream=0.719,
			bpm=158,
			length=7.44,
			dp=400, ep=737, dp_ep=806, rp=3000,
		},
		{
			id=45,
			name="[14] [160] Hooligans",
			pack="Eurobeat Is Fantastic",
			difficulty=14,
			steps=2100,
			bpm_tier=160,
			measures=105,
			adj_stream=0.7343,
			bpm=160,
			length=4.08,
			dp=445, ep=422, dp_ep=35, rp=3000,
		},
		{
			id=46,
			name="[14] [160] Katamari on the Rocks",
			pack="Xynn's LVTS 2",
			difficulty=14,
			steps=3144,
			bpm_tier=160,
			measures=148,
			adj_stream=0.682,
			bpm=160,
			length=5.88,
			dp=445, ep=579, dp_ep=483, rp=3000,
		},
		{
			id=47,
			name="[14] [161] 80808",
			pack="Death Grips",
			difficulty=14,
			steps=1797,
			bpm_tier=160,
			measures=100,
			adj_stream=0.7812,
			bpm=161,
			length=3.23,
			dp=467, ep=474, dp_ep=246, rp=3000,
		},
		{
			id=48,
			name="[14] [165] When the Rain Begins To Fall",
			pack="Stamina Showcase",
			difficulty=14,
			steps=2272,
			bpm_tier=160,
			measures=120,
			adj_stream=0.7453,
			bpm=165,
			length=4.15,
			dp=556, ep=527, dp_ep=652, rp=3000,
		},
		{
			id=49,
			name="[14] [174] Tension",
			pack="Hospitality",
			difficulty=14,
			steps=1811,
			bpm_tier=170,
			measures=89,
			adj_stream=0.6593,
			bpm=174,
			length=4.8,
			dp=756, ep=158, dp_ep=169, rp=3000,
		},
		{
			id=50,
			name="[14] [174] Witchcraft",
			pack="Pendulum Act III",
			difficulty=14,
			steps=1904,
			bpm_tier=170,
			measures=97,
			adj_stream=0.6644,
			bpm=174,
			length=4.18,
			dp=756, ep=264, dp_ep=472, rp=3000,
		},
		{
			id=51,
			name="[14] [174] Black Church",
			pack="Cirque du Miura",
			difficulty=14,
			steps=1862,
			bpm_tier=170,
			measures=96,
			adj_stream=0.7273,
			bpm=174,
			length=4.09,
			dp=756, ep=369, dp_ep=772, rp=3000,
		},
		{
			id=52,
			name="[14] [175] kagetsu",
			pack="Stamina Showcase 2",
			difficulty=14,
			steps=2554,
			bpm_tier=170,
			measures=111,
			adj_stream=0.5812,
			bpm=175,
			length=5.05,
			dp=778, ep=211, dp_ep=383, rp=3000,
		},
		{
			id=53,
			name="[14] [180] squartatrice",
			pack="Cirque Du Enzo",
			difficulty=14,
			steps=2338,
			bpm_tier=180,
			measures=87,
			adj_stream=0.5437,
			bpm=180,
			length=4.8,
			dp=889, ep=106, dp_ep=400, rp=3000,
		},
		{
			id=54,
			name="[14] [180] Way Away",
			pack="???",
			difficulty=14,
			steps=1846,
			bpm_tier=180,
			measures=95,
			adj_stream=0.6738,
			bpm=180,
			length=3.38,
			dp=889, ep=316, dp_ep=1000, rp=3000,
		},
		{
			id=55,
			name="[14] [180] Vertex ALPHA (Hard)",
			pack="BaguetteStreamz 2",
			difficulty=14,
			steps=1830,
			bpm_tier=180,
			measures=75,
			adj_stream=0.5102,
			bpm=180,
			length=4.07,
			dp=889, ep=53, dp_ep=249, rp=3000,
		},
		{
			id=56,
			name="[14] [185] The Defeated Boy",
			pack="VocaJawnz II",
			difficulty=14,
			steps=1619,
			bpm_tier=180,
			measures=47,
			adj_stream=0.4196,
			bpm=185,
			length=3.61,
			dp=1000, ep=0, dp_ep=415, rp=3000,
		},
		{
			id=57,
			name="[15] [150] Hallucinogen",
			pack="French Coast Stamina 2",
			difficulty=15,
			steps=5251,
			bpm_tier=150,
			measures=311,
			adj_stream=0.9041,
			bpm=150,
			length=10.13,
			dp=0, ep=1000, dp_ep=510, rp=4000,
		},
		{
			id=58,
			name="[15] [155] Night Of Fire v2",
			pack="BaguetteStreamz",
			difficulty=15,
			steps=2919,
			bpm_tier=150,
			measures=179,
			adj_stream=0.9728,
			bpm=155,
			length=4.85,
			dp=122, ep=895, dp_ep=531, rp=4000,
		},
		{
			id=59,
			name="[15] [155] G e n g a o z o -Noize of Nocent-",
			pack="Stamina Secret Santa 2019",
			difficulty=15,
			steps=4500,
			bpm_tier=150,
			measures=269,
			adj_stream=0.934,
			bpm=155,
			length=8.03,
			dp=122, ep=948, dp_ep=597, rp=4000,
		},
		{
			id=60,
			name="[15] [159] REASON for RED (Hard)",
			pack="Stamina Showcase 2",
			difficulty=15,
			steps=2628,
			bpm_tier=150,
			measures=149,
			adj_stream=0.9141,
			bpm=159,
			length=4.58,
			dp=220, ep=790, dp_ep=523, rp=4000,
		},
		{
			id=61,
			name="[15] [160] Battle Train -HOT SOTA MIX-",
			pack="Xynn's LVTS 2",
			difficulty=15,
			steps=2793,
			bpm_tier=160,
			measures=162,
			adj_stream=0.8438,
			bpm=160,
			length=5.18,
			dp=244, ep=685, dp_ep=423, rp=4000,
		},
		{
			id=62,
			name="[15] [165] Defiance",
			pack="untitled stream pack",
			difficulty=15,
			steps=2251,
			bpm_tier=160,
			measures=131,
			adj_stream=0.9493,
			bpm=165,
			length=4.02,
			dp=366, ep=632, dp_ep=508, rp=4000,
		},
		{
			id=63,
			name="[15] [165] Zusammengehorigkeit Hommarju Remix",
			pack="Baguettestreamz",
			difficulty=15,
			steps=3176,
			bpm_tier=160,
			measures=175,
			adj_stream=0.8102,
			bpm=165,
			length=5.79,
			dp=366, ep=737, dp_ep=637, rp=4000,
		},
		{
			id=64,
			name="[15] [168] Ice Angel",
			pack="StoryTime Chapter 1",
			difficulty=15,
			steps=3305,
			bpm_tier=160,
			measures=193,
			adj_stream=0.7782,
			bpm=168,
			length=6,
			dp=440, ep=843, dp_ep=859, rp=4000,
		},
		{
			id=65,
			name="[15] [174] Dimension Ninja",
			pack="Cirque Du Enzo",
			difficulty=15,
			steps=2425,
			bpm_tier=170,
			measures=100,
			adj_stream=0.4785,
			bpm=174,
			length=4.9,
			dp=586, ep=0, dp_ep=0, rp=4000,
		},
		{
			id=66,
			name="[15] [174] Salt in the Wounds",
			pack="Pendulum Act III",
			difficulty=15,
			steps=3117,
			bpm_tier=170,
			measures=141,
			adj_stream=0.6589,
			bpm=174,
			length=6.38,
			dp=586, ep=527, dp_ep=650, rp=4000,
		},
		{
			id=67,
			name="[15] [175] Wrong (Muzzy Remix)",
			pack="Hospitality",
			difficulty=15,
			steps=3146,
			bpm_tier=170,
			measures=138,
			adj_stream=0.5679,
			bpm=175,
			length=6.72,
			dp=610, ep=369, dp_ep=484, rp=4000,
		},
		{
			id=68,
			name="[15] [175] I Can Fly in the Universe",
			pack="Stamina Showcase",
			difficulty=15,
			steps=3072,
			bpm_tier=170,
			measures=144,
			adj_stream=0.6575,
			bpm=175,
			length=6.1,
			dp=610, ep=579, dp_ep=743, rp=4000,
		},
		{
			id=69,
			name="[15] [180] A Town With An Ocean View (el Poco Maro Remix)",
			pack="Hospitality",
			difficulty=15,
			steps=1748,
			bpm_tier=180,
			measures=91,
			adj_stream=0.7054,
			bpm=180,
			length=3.36,
			dp=732, ep=211, dp_ep=440, rp=4000,
		},
		{
			id=70,
			name="[15] [180] Get Over the Barrier! (-Evolution!!-)",
			pack="Trails of Cold Stream II",
			difficulty=15,
			steps=2017,
			bpm_tier=180,
			measures=115,
			adj_stream=0.7188,
			bpm=180,
			length=3.91,
			dp=732, ep=474, dp_ep=764, rp=4000,
		},
		{
			id=71,
			name="[15] [180] Epimedium",
			pack="Bass Chasers",
			difficulty=15,
			steps=1652,
			bpm_tier=180,
			measures=94,
			adj_stream=0.6912,
			bpm=180,
			length=3.51,
			dp=732, ep=158, dp_ep=375, rp=4000,
		},
		{
			id=72,
			name="[15] [188] Shanghai Kouchakan Chinese Tea Orchid Remix",
			pack="Cuties Party",
			difficulty=15,
			steps=2047,
			bpm_tier=180,
			measures=103,
			adj_stream=0.6776,
			bpm=188,
			length=3.55,
			dp=927, ep=316, dp_ep=810, rp=4000,
		},
		{
			id=73,
			name="[15] [190] Oshama Scramble",
			pack="Cuties Party",
			difficulty=15,
			steps=2292,
			bpm_tier=190,
			measures=106,
			adj_stream=0.5464,
			bpm=190,
			length=4.23,
			dp=976, ep=106, dp_ep=611, rp=4000,
		},
		{
			id=74,
			name="[15] [190] Dawn Of Victory",
			pack="BaguetteStreamz 2",
			difficulty=15,
			steps=2630,
			bpm_tier=190,
			measures=126,
			adj_stream=0.6238,
			bpm=190,
			length=4.72,
			dp=976, ep=422, dp_ep=1000, rp=4000,
		},
		{
			id=75,
			name="[15] [190] Unreliable Narrator",
			pack="Resistance Device",
			difficulty=15,
			steps=1362,
			bpm_tier=190,
			measures=68,
			adj_stream=0.8608,
			bpm=190,
			length=2.61,
			dp=976, ep=264, dp_ep=806, rp=4000,
		},
		{
			id=76,
			name="[15] [191] AO-INFINITY",
			pack="Cirque Du Enzo",
			difficulty=15,
			steps=1747,
			bpm_tier=190,
			measures=72,
			adj_stream=0.6667,
			bpm=191,
			length=3.56,
			dp=1000, ep=53, dp_ep=576, rp=4000,
		},
		{
			id=77,
			name="[16] [160] Eurobeat Is Fantastic ~Part 3~",
			pack="???",
			difficulty=16,
			steps=5614,
			bpm_tier=160,
			measures=330,
			adj_stream=0.8684,
			bpm=160,
			length=9.82,
			dp=0, ep=948, dp_ep=373, rp=5000,
		},
		{
			id=78,
			name="[16] [162] Entity",
			pack="ITGAlex's Stamina Safari",
			difficulty=16,
			steps=4797,
			bpm_tier=160,
			measures=291,
			adj_stream=0.9238,
			bpm=162,
			length=7.93,
			dp=42, ep=895, dp_ep=342, rp=5000,
		},
		{
			id=79,
			name="[16] [165] Bright Colors",
			pack="French Coast Stamina 3",
			difficulty=16,
			steps=11077,
			bpm_tier=160,
			measures=608,
			adj_stream=0.76,
			bpm=165,
			length=20.02,
			dp=105, ep=1000, dp_ep=827, rp=5000,
		},
		{
			id=80,
			name="[16] [165] Eastern Dream",
			pack="Demetori ACT 1",
			difficulty=16,
			steps=5762,
			bpm_tier=160,
			measures=324,
			adj_stream=0.8438,
			bpm=165,
			length=10.33,
			dp=105, ep=843, dp_ep=373, rp=5000,
		},
		{
			id=81,
			name="[16] [173] Just One Second",
			pack="Hospitality",
			difficulty=16,
			steps=3392,
			bpm_tier=170,
			measures=201,
			adj_stream=0.9013,
			bpm=173,
			length=5.46,
			dp=271, ep=685, dp_ep=396, rp=5000,
		},
		{
			id=82,
			name="[16] [174] Crush",
			pack="Pendulum Act III",
			difficulty=16,
			steps=1921,
			bpm_tier=170,
			measures=120,
			adj_stream=1,
			bpm=174,
			length=3.06,
			dp=292, ep=527, dp_ep=0, rp=5000,
		},
		{
			id=83,
			name="[16] [174] Meteor Shower",
			pack="Cirque Du Enzo",
			difficulty=16,
			steps=3719,
			bpm_tier=170,
			measures=224,
			adj_stream=0.875,
			bpm=174,
			length=5.98,
			dp=292, ep=737, dp_ep=607, rp=5000,
		},
		{
			id=84,
			name="[16] [178] Horrrable Dreamz",
			pack="Scrapyard Kent",
			difficulty=16,
			steps=3820,
			bpm_tier=170,
			measures=217,
			adj_stream=0.9118,
			bpm=178,
			length=6.43,
			dp=375, ep=790, dp_ep=1000, rp=5000,
		},
		{
			id=85,
			name="[16] [180] Hynek's Scale 180",
			pack="BaguetteStreamz",
			difficulty=16,
			steps=3557,
			bpm_tier=180,
			measures=206,
			adj_stream=0.8583,
			bpm=180,
			length=5.78,
			dp=417, ep=632, dp_ep=665, rp=5000,
		},
		{
			id=86,
			name="[16] [184] Heretic Witch",
			pack="SHARPNELSTREAMZ v3 Part 2",
			difficulty=16,
			steps=2155,
			bpm_tier=180,
			measures=133,
			adj_stream=0.9925,
			bpm=184,
			length=3.06,
			dp=500, ep=579, dp_ep=752, rp=5000,
		},
		{
			id=87,
			name="[16] [184] Cybernecia Catharsis",
			pack="ITGAlex's Stamina Singles",
			difficulty=16,
			steps=2512,
			bpm_tier=180,
			measures=138,
			adj_stream=0.7797,
			bpm=184,
			length=4.59,
			dp=500, ep=369, dp_ep=145, rp=5000,
		},
		{
			id=88,
			name="[16] [186] Fly Away",
			pack="ITGAlex's Stamina Safari",
			difficulty=16,
			steps=2283,
			bpm_tier=180,
			measures=134,
			adj_stream=0.8375,
			bpm=186,
			length=3.48,
			dp=542, ep=474, dp_ep=570, rp=5000,
		},
		{
			id=89,
			name="[16] [190] Ad Astra",
			pack="Helblinde 2016",
			difficulty=16,
			steps=3061,
			bpm_tier=190,
			measures=158,
			adj_stream=0.6475,
			bpm=190,
			length=5.24,
			dp=625, ep=316, dp_ep=353, rp=5000,
		},
		{
			id=90,
			name="[16] [192] Say Hello to HOLLOWood feat. Nene Akagawa",
			pack="BaguetteStreamz 2",
			difficulty=16,
			steps=2520,
			bpm_tier=190,
			measures=127,
			adj_stream=0.6318,
			bpm=192,
			length=4.56,
			dp=667, ep=158, dp_ep=18, rp=5000,
		},
		{
			id=91,
			name="[16] [192] Night sky",
			pack="ITGAlex's Stamina Safari",
			difficulty=16,
			steps=2708,
			bpm_tier=190,
			measures=148,
			adj_stream=0.7668,
			bpm=192,
			length=4.44,
			dp=667, ep=422, dp_ep=781, rp=5000,
		},
		{
			id=92,
			name="[16] [192] Salvation",
			pack="Cirque Du Enzo",
			difficulty=16,
			steps=2674,
			bpm_tier=190,
			measures=130,
			adj_stream=0.6373,
			bpm=192,
			length=4.92,
			dp=667, ep=211, dp_ep=171, rp=5000,
		},
		{
			id=93,
			name="[16] [200] Promethium",
			pack="SHARPNELSTREAMZ v3 Part 1",
			difficulty=16,
			steps=2444,
			bpm_tier=200,
			measures=107,
			adj_stream=0.7483,
			bpm=200,
			length=4.52,
			dp=834, ep=264, dp_ep=807, rp=5000,
		},
		{
			id=94,
			name="[16] [200] Heaven's Fall 2016 Rebuild",
			pack="Helblinde 2016",
			difficulty=16,
			steps=2623,
			bpm_tier=200,
			measures=127,
			adj_stream=0.6287,
			bpm=200,
			length=4.24,
			dp=834, ep=106, dp_ep=350, rp=5000,
		},
		{
			id=95,
			name="[16] [200] Liberator feat. blaxervant",
			pack="Resistance Device",
			difficulty=16,
			steps=1655,
			bpm_tier=200,
			measures=78,
			adj_stream=0.6903,
			bpm=200,
			length=3.56,
			dp=834, ep=0, dp_ep=44, rp=5000,
		},
		{
			id=96,
			name="[16] [208] Deus ex Machina",
			pack="Cirque Du Enzo",
			difficulty=16,
			steps=1877,
			bpm_tier=200,
			measures=87,
			adj_stream=0.6541,
			bpm=208,
			length=2.94,
			dp=1000, ep=53, dp_ep=677, rp=5000,
		},
		{
			id=97,
			name="[17] [174] Ian's OP",
			pack="Pendulum Act III",
			difficulty=17,
			steps=12096,
			bpm_tier=170,
			measures=577,
			adj_stream=0.6191,
			bpm=174,
			length=23.28,
			dp=0, ep=948, dp_ep=375, rp=6000,
		},
		{
			id=98,
			name="[17] [175] Space Box",
			pack="Scrapyard Kent",
			difficulty=17,
			steps=9735,
			bpm_tier=170,
			measures=575,
			adj_stream=0.8557,
			bpm=175,
			length=15.86,
			dp=27, ep=1000, dp_ep=562, rp=6000,
		},
		{
			id=99,
			name="[17] [179] Bio Tunnel Magnetic Transport",
			pack="Hospitality",
			difficulty=17,
			steps=5743,
			bpm_tier=170,
			measures=336,
			adj_stream=0.7636,
			bpm=179,
			length=10.3,
			dp=132, ep=843, dp_ep=439, rp=6000,
		},
		{
			id=100,
			name="[17] [179] Lift Off FB 179",
			pack="Scrapyard Kent",
			difficulty=17,
			steps=4570,
			bpm_tier=170,
			measures=279,
			adj_stream=0.9555,
			bpm=179,
			length=7.24,
			dp=132, ep=895, dp_ep=562, rp=6000,
		},
		{
			id=101,
			name="[17] [180] Signal (Girl's Vocal Mix)",
			pack="BaguetteStreamz 2",
			difficulty=17,
			steps=4253,
			bpm_tier=180,
			measures=250,
			adj_stream=0.8621,
			bpm=180,
			length=6.87,
			dp=158, ep=632, dp_ep=0, rp=6000,
		},
		{
			id=102,
			name="[17] [185] Tell Your Name",
			pack="Lolistyle GabberS",
			difficulty=17,
			steps=4089,
			bpm_tier=180,
			measures=246,
			adj_stream=0.9111,
			bpm=185,
			length=6.1,
			dp=290, ep=790, dp_ep=688, rp=6000,
		},
		{
			id=103,
			name="[17] [185] Asereje (Speed Mix)",
			pack="Jimmy Jawns 4",
			difficulty=17,
			steps=3349,
			bpm_tier=180,
			measures=208,
			adj_stream=0.9858,
			bpm=185,
			length=4.67,
			dp=290, ep=737, dp_ep=562, rp=6000,
		},
		{
			id=104,
			name="[17] [187] Destination Talos",
			pack="Cranked Pastry",
			difficulty=17,
			steps=4937,
			bpm_tier=180,
			measures=270,
			adj_stream=0.8157,
			bpm=187,
			length=7.47,
			dp=343, ep=579, dp_ep=313, rp=6000,
		},
		{
			id=105,
			name="[17] [190] I Miss You",
			pack="Trails of Cold Stream",
			difficulty=17,
			steps=3868,
			bpm_tier=190,
			measures=232,
			adj_stream=0.917,
			bpm=190,
			length=5.37,
			dp=422, ep=685, dp_ep=752, rp=6000,
		},
		{
			id=106,
			name="[17] [190] La Morale De La Fable",
			pack="ExJam09 Jams",
			difficulty=17,
			steps=3888,
			bpm_tier=190,
			measures=207,
			adj_stream=0.7841,
			bpm=190,
			length=6.08,
			dp=422, ep=527, dp_ep=377, rp=6000,
		},
		{
			id=107,
			name="[17] [191] Difficulty-G",
			pack="SHARPNELSTREAMZ v3 Part 2",
			difficulty=17,
			steps=2815,
			bpm_tier=190,
			measures=141,
			adj_stream=0.8393,
			bpm=191,
			length=4.24,
			dp=448, ep=369, dp_ep=64, rp=6000,
		},
		{
			id=108,
			name="[17] [195] Weigh Anchor!",
			pack="Lolistyle GabberS",
			difficulty=17,
			steps=3106,
			bpm_tier=190,
			measures=178,
			adj_stream=0.7706,
			bpm=195,
			length=4.8,
			dp=553, ep=474, dp_ep=562, rp=6000,
		},
		{
			id=109,
			name="[17] [200] Extraction Zone",
			pack="Dragonforce Kaioken",
			difficulty=17,
			steps=2897,
			bpm_tier=200,
			measures=149,
			adj_stream=0.6082,
			bpm=200,
			length=5.08,
			dp=685, ep=106, dp_ep=3, rp=6000,
		},
		{
			id=110,
			name="[17] [204] New Odyssey",
			pack="ITGAlex's Stamina Safari",
			difficulty=17,
			steps=2945,
			bpm_tier=200,
			measures=162,
			adj_stream=0.7788,
			bpm=204,
			length=4.75,
			dp=790, ep=422, dp_ep=1000, rp=6000,
		},
		{
			id=111,
			name="[17] [205] Little Lies",
			pack="ITGAlex's Stamina Safari",
			difficulty=17,
			steps=3072,
			bpm_tier=200,
			measures=169,
			adj_stream=0.6815,
			bpm=205,
			length=5.4,
			dp=816, ep=316, dp_ep=811, rp=6000,
		},
		{
			id=112,
			name="[17] [208] Yui & I",
			pack="Helblinde PDTA",
			difficulty=17,
			steps=3158,
			bpm_tier=200,
			measures=164,
			adj_stream=0.6189,
			bpm=208,
			length=5.51,
			dp=895, ep=158, dp_ep=624, rp=6000,
		},
		{
			id=113,
			name="[17] [210] Outbreak (P*Light & DJ Myosuke Remix)",
			pack="Stamina Selects",
			difficulty=17,
			steps=2414,
			bpm_tier=210,
			measures=117,
			adj_stream=0.6126,
			bpm=210,
			length=4.3,
			dp=948, ep=0, dp_ep=375, rp=6000,
		},
		{
			id=114,
			name="[17] [210] The Loop (AleX Tune Mashup Mix)",
			pack="Jimmy Jawns 3",
			difficulty=17,
			steps=2308,
			bpm_tier=210,
			measures=125,
			adj_stream=0.7764,
			bpm=210,
			length=3.56,
			dp=948, ep=264, dp_ep=1000, rp=6000,
		},
		{
			id=115,
			name="[17] [210] Unsainted",
			pack="Jimmy Jawns 4",
			difficulty=17,
			steps=2380,
			bpm_tier=210,
			measures=123,
			adj_stream=0.7834,
			bpm=210,
			length=3.83,
			dp=948, ep=211, dp_ep=875, rp=6000,
		},
		{
			id=116,
			name="[17] [212] Zap Your Channel",
			pack="Rebuild of Sharpnel",
			difficulty=17,
			steps=2125,
			bpm_tier=210,
			measures=107,
			adj_stream=0.6859,
			bpm=212,
			length=3.15,
			dp=1000, ep=53, dp_ep=624, rp=6000,
		},
		{
			id=117,
			name="[18] [180] Call Of Beauty",
			pack="BaguetteStreamz",
			difficulty=18,
			steps=8012,
			bpm_tier=180,
			measures=490,
			adj_stream=1,
			bpm=180,
			length=12.84,
			dp=0, ep=1000, dp_ep=436, rp=7000,
		},
		{
			id=118,
			name="[18] [185] White Laguna",
			pack="Scrapyard Kent",
			difficulty=18,
			steps=6034,
			bpm_tier=180,
			measures=374,
			adj_stream=0.9894,
			bpm=185,
			length=8.32,
			dp=112, ep=895, dp_ep=452, rp=7000,
		},
		{
			id=119,
			name="[18] [185] Stars FP 185",
			pack="Cranked Pastry",
			difficulty=18,
			steps=6359,
			bpm_tier=180,
			measures=388,
			adj_stream=0.97,
			bpm=185,
			length=9.45,
			dp=112, ep=948, dp_ep=572, rp=7000,
		},
		{
			id=120,
			name="[18] [188] Radiation 239",
			pack="BaguetteStreamz 2",
			difficulty=18,
			steps=4865,
			bpm_tier=180,
			measures=298,
			adj_stream=0.9198,
			bpm=188,
			length=7.34,
			dp=178, ep=843, dp_ep=483, rp=7000,
		},
		{
			id=121,
			name="[18] [190] Chaos Structure (Restep)",
			pack="Masochisma Mk 1",
			difficulty=18,
			steps=4500,
			bpm_tier=190,
			measures=277,
			adj_stream=0.9327,
			bpm=190,
			length=6.8,
			dp=223, ep=790, dp_ep=465, rp=7000,
		},
		{
			id=122,
			name="[18] [195] Pacific Girls",
			pack="SHARPNELSTREAMZ v3 Part 2",
			difficulty=18,
			steps=3734,
			bpm_tier=190,
			measures=212,
			adj_stream=0.8833,
			bpm=195,
			length=5.35,
			dp=334, ep=474, dp_ep=0, rp=7000,
		},
		{
			id=123,
			name="[18] [197] Silver Screen FB 197",
			pack="Cirque du Huayra",
			difficulty=18,
			steps=3970,
			bpm_tier=190,
			measures=236,
			adj_stream=0.9112,
			bpm=197,
			length=5.5,
			dp=378, ep=632, dp_ep=459, rp=7000,
		},
		{
			id=124,
			name="[18] [198] Shihen (Piece of Poetry)",
			pack="SHARPNELSTREAMZ v3 Part 2",
			difficulty=18,
			steps=4627,
			bpm_tier=190,
			measures=275,
			adj_stream=0.854,
			bpm=198,
			length=6.61,
			dp=400, ep=685, dp_ep=629, rp=7000,
		},
		{
			id=125,
			name="[18] [200] Marunouchi Surviver",
			pack="SHARPNELSTREAMZ v3 Part 1",
			difficulty=18,
			steps=3346,
			bpm_tier=200,
			measures=196,
			adj_stream=0.9202,
			bpm=200,
			length=4.71,
			dp=445, ep=422, dp_ep=134, rp=7000,
		},
		{
			id=126,
			name="[18] [200] USAO ULTIMATE HYPER MEGA MIX",
			pack="ITGAlex's Stamina Safari",
			difficulty=18,
			steps=3594,
			bpm_tier=200,
			measures=213,
			adj_stream=0.9301,
			bpm=200,
			length=5.08,
			dp=445, ep=527, dp_ep=372, rp=7000,
		},
		{
			id=127,
			name="[18] [200] Something Special",
			pack="The Apocalypse Sampler",
			difficulty=18,
			steps=4418,
			bpm_tier=200,
			measures=261,
			adj_stream=0.8208,
			bpm=200,
			length=6.74,
			dp=445, ep=579, dp_ep=490, rp=7000,
		},
		{
			id=128,
			name="[18] [203] SRPX-0004 (Part 2)",
			pack="SHARPNEL MARATHONZ",
			difficulty=18,
			steps=6172,
			bpm_tier=200,
			measures=330,
			adj_stream=0.8271,
			bpm=203,
			length=8.75,
			dp=512, ep=737, dp_ep=1000, rp=7000,
		},
		{
			id=129,
			name="[18] [210] We Luv Lama",
			pack="Rebuild of Sharpnel",
			difficulty=18,
			steps=3470,
			bpm_tier=210,
			measures=176,
			adj_stream=0.6743,
			bpm=210,
			length=5.45,
			dp=667, ep=264, dp_ep=279, rp=7000,
		},
		{
			id=130,
			name="[18] [210] Killian Is Lying To You",
			pack="Petriform's Factory",
			difficulty=18,
			steps=3214,
			bpm_tier=210,
			measures=188,
			adj_stream=0.8393,
			bpm=210,
			length=4.3,
			dp=667, ep=369, dp_ep=518, rp=7000,
		},
		{
			id=131,
			name="[18] [213] Hunter's Anthem",
			pack="BaguetteStreamz 2.5",
			difficulty=18,
			steps=3126,
			bpm_tier=210,
			measures=166,
			adj_stream=0.7511,
			bpm=213,
			length=4.69,
			dp=734, ep=316, dp_ep=549, rp=7000,
		},
		{
			id=132,
			name="[18] [218] Sunshine Coastline",
			pack="Trails of Cold Stream",
			difficulty=18,
			steps=2204,
			bpm_tier=210,
			measures=119,
			adj_stream=0.8561,
			bpm=218,
			length=3.17,
			dp=845, ep=211, dp_ep=563, rp=7000,
		},
		{
			id=133,
			name="[18] [220] The Silent World",
			pack="untitled stream pack",
			difficulty=18,
			steps=2270,
			bpm_tier=220,
			measures=106,
			adj_stream=0.6235,
			bpm=220,
			length=3.29,
			dp=889, ep=53, dp_ep=304, rp=7000,
		},
		{
			id=134,
			name="[18] [220] Energy Bomb",
			pack="ITGAlex's Stamina Singles",
			difficulty=18,
			steps=2125,
			bpm_tier=220,
			measures=105,
			adj_stream=0.6604,
			bpm=220,
			length=3.82,
			dp=889, ep=106, dp_ep=425, rp=7000,
		},
		{
			id=135,
			name="[18] [222] NINJA IS DEAD",
			pack="ITGAlex's Stamina Safari",
			difficulty=18,
			steps=2329,
			bpm_tier=220,
			measures=116,
			adj_stream=0.6554,
			bpm=222,
			length=3.57,
			dp=934, ep=158, dp_ep=644, rp=7000,
		},
		{
			id=136,
			name="[18] [225] Livingdead",
			pack="ITGAlex's Stamina Safari",
			difficulty=18,
			steps=1776,
			bpm_tier=220,
			measures=92,
			adj_stream=0.575,
			bpm=225,
			length=3.24,
			dp=1000, ep=0, dp_ep=436, rp=7000,
		},
		{
			id=137,
			name="[19] [193] Only Love (We Will Take)",
			pack="BaguetteStreamz",
			difficulty=19,
			steps=9225,
			bpm_tier=190,
			measures=574,
			adj_stream=0.9914,
			bpm=193,
			length=12.64,
			dp=174, ep=843, dp_ep=430, rp=8000,
		},
		{
			id=138,
			name="[19] [193] Extraterrestrial Pudding",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=10060,
			bpm_tier=190,
			measures=626,
			adj_stream=0.9858,
			bpm=193,
			length=13.28,
			dp=174, ep=948, dp_ep=1000, rp=8000,
		},
		{
			id=139,
			name="[19] [195] Through The Fire And France (Hard)",
			pack="French Coast Stamina 3",
			difficulty=19,
			steps=13941,
			bpm_tier=190,
			measures=807,
			adj_stream=0.8235,
			bpm=195,
			length=20.18,
			dp=212, ep=895, dp_ep=919, rp=8000,
		},
		{
			id=140,
			name="[19] [197] Ride the Centaurus FP 197",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=6820,
			bpm_tier=190,
			measures=406,
			adj_stream=0.9291,
			bpm=197,
			length=9.71,
			dp=250, ep=790, dp_ep=555, rp=8000,
		},
		{
			id=141,
			name="[19] [202] Modern Primitive",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=15544,
			bpm_tier=200,
			measures=912,
			adj_stream=0.8932,
			bpm=184,
			length=22.29,
			dp=0, ep=1000, dp_ep=337, rp=8000,
		},
		{
			id=142,
			name="[19] [200] Trails of Cold Stream SC (Part 3)",
			pack="Trails of Cold Stream II",
			difficulty=19,
			steps=6834,
			bpm_tier=200,
			measures=407,
			adj_stream=0.9004,
			bpm=200,
			length=9.1,
			dp=308, ep=737, dp_ep=582, rp=8000,
		},
		{
			id=143,
			name="[19] [204] The Bell",
			pack="ITGAlex's Stamina Safari",
			difficulty=19,
			steps=6011,
			bpm_tier=200,
			measures=368,
			adj_stream=0.9583,
			bpm=204,
			length=7.75,
			dp=385, ep=685, dp_ep=718, rp=8000,
		},
		{
			id=144,
			name="[19] [207] Digital Messias FB 207",
			pack="Cirque du Huayra",
			difficulty=19,
			steps=5505,
			bpm_tier=200,
			measures=331,
			adj_stream=0.922,
			bpm=207,
			length=7.05,
			dp=443, ep=632, dp_ep=745, rp=8000,
		},
		{
			id=145,
			name="[19] [210] Mental Spectrum Hacker",
			pack="ITGAlex's Stamina Safari",
			difficulty=19,
			steps=5324,
			bpm_tier=210,
			measures=310,
			adj_stream=0.8378,
			bpm=210,
			length=7.26,
			dp=500, ep=527, dp_ep=484, rp=8000,
		},
		{
			id=146,
			name="[19] [210] Dodgeball",
			pack="Petriform's Factory",
			difficulty=19,
			steps=3001,
			bpm_tier=210,
			measures=183,
			adj_stream=0.8883,
			bpm=210,
			length=4.17,
			dp=500, ep=474, dp_ep=196, rp=8000,
		},
		{
			id=147,
			name="[19] [212] Floating",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=4921,
			bpm_tier=210,
			measures=289,
			adj_stream=0.8838,
			bpm=212,
			length=6.51,
			dp=539, ep=579, dp_ep=979, rp=8000,
		},
		{
			id=148,
			name="[19] [218] Plateau (Hard)",
			pack="ITGAlex's Stamina Safari",
			difficulty=19,
			steps=4178,
			bpm_tier=210,
			measures=222,
			adj_stream=0.7525,
			bpm=218,
			length=6.09,
			dp=654, ep=422, dp_ep=750, rp=8000,
		},
		{
			id=149,
			name="[19] [220] katagiri catchball",
			pack="katagiri",
			difficulty=19,
			steps=2943,
			bpm_tier=220,
			measures=170,
			adj_stream=0.85,
			bpm=220,
			length=3.85,
			dp=693, ep=369, dp_ep=674, rp=8000,
		},
		{
			id=150,
			name="[19] [220] Fallen World",
			pack="Dragonforce Kaioken",
			difficulty=19,
			steps=3031,
			bpm_tier=220,
			measures=171,
			adj_stream=0.8261,
			bpm=220,
			length=4.11,
			dp=693, ep=316, dp_ep=386, rp=8000,
		},
		{
			id=151,
			name="[19] [224] Sayonara Planet Wars",
			pack="ITGAlex's Stamina Safari",
			difficulty=19,
			steps=2926,
			bpm_tier=220,
			measures=150,
			adj_stream=0.7109,
			bpm=224,
			length=3.91,
			dp=770, ep=211, dp_ep=234, rp=8000,
		},
		{
			id=152,
			name="[19] [225] Vicodin Beach Party",
			pack="Petriform's Factory",
			difficulty=19,
			steps=2368,
			bpm_tier=220,
			measures=127,
			adj_stream=0.7937,
			bpm=225,
			length=3.2,
			dp=789, ep=264, dp_ep=625, rp=8000,
		},
		{
			id=153,
			name="[19] [230] Daydreamer",
			pack="???",
			difficulty=19,
			steps=2189,
			bpm_tier=230,
			measures=105,
			adj_stream=0.8015,
			bpm=230,
			length=3.5,
			dp=885, ep=158, dp_ep=571, rp=8000,
		},
		{
			id=154,
			name="[19] [230] Struggle In Your Room With J. (Restep)",
			pack="???",
			difficulty=19,
			steps=2545,
			bpm_tier=230,
			measures=112,
			adj_stream=0.5685,
			bpm=230,
			length=3.72,
			dp=885, ep=53, dp_ep=0, rp=8000,
		},
		{
			id=155,
			name="[19] [230] Heisei Memehunters (Hard)",
			pack="ITGAlex's Stamina Safari",
			difficulty=19,
			steps=2499,
			bpm_tier=230,
			measures=115,
			adj_stream=0.5838,
			bpm=230,
			length=3.57,
			dp=885, ep=106, dp_ep=289, rp=8000,
		},
		{
			id=156,
			name="[19] [236] EgO",
			pack="StreamVoltex ep.2",
			difficulty=19,
			steps=1455,
			bpm_tier=230,
			measures=79,
			adj_stream=0.7054,
			bpm=236,
			length=2.03,
			dp=1000, ep=0, dp_ep=337, rp=8000,
		},
		{
			id=157,
			name="[20] [200] Spacetime",
			pack="Psychedelia 2",
			difficulty=20,
			steps=8449,
			bpm_tier=200,
			measures=528,
			adj_stream=1,
			bpm=200,
			length=10.8,
			dp=0, ep=1000, dp_ep=123, rp=9000,
		},
		{
			id=158,
			name="[20] [205] Trails of Cold Stream the 3rd (Part 2)",
			pack="Trails of Cold Stream III",
			difficulty=20,
			steps=8661,
			bpm_tier=200,
			measures=504,
			adj_stream=0.8675,
			bpm=205,
			length=11.47,
			dp=122, ep=948, dp_ep=451, rp=9000,
		},
		{
			id=159,
			name="[20] [208] Ride the Centaurus",
			pack="Scrapyard Kent",
			difficulty=20,
			steps=6820,
			bpm_tier=200,
			measures=406,
			adj_stream=0.9291,
			bpm=208,
			length=9.19,
			dp=196, ep=895, dp_ep=550, rp=9000,
		},
		{
			id=160,
			name="[20] [208] Guilty Surfacing FP 208",
			pack="Scrapyard Kent",
			difficulty=20,
			steps=6855,
			bpm_tier=200,
			measures=404,
			adj_stream=0.9182,
			bpm=208,
			length=8.71,
			dp=196, ep=843, dp_ep=306, rp=9000,
		},
		{
			id=161,
			name="[20] [210] Trails of Cold Stream SC (Part 5)",
			pack="Trails of Cold Stream II",
			difficulty=20,
			steps=6862,
			bpm_tier=210,
			measures=405,
			adj_stream=0.8368,
			bpm=210,
			length=9.55,
			dp=244, ep=737, dp_ep=33, rp=9000,
		},
		{
			id=162,
			name="[20] [212] Life Burst (Liquid E.T. Remix)",
			pack="Stamina Showcase 2",
			difficulty=20,
			steps=6176,
			bpm_tier=210,
			measures=372,
			adj_stream=0.9323,
			bpm=212,
			length=8.28,
			dp=293, ep=790, dp_ep=512, rp=9000,
		},
		{
			id=163,
			name="[20] [214] We Came To Gangbang",
			pack="Stamina Selects",
			difficulty=20,
			steps=4679,
			bpm_tier=210,
			measures=272,
			adj_stream=0.9444,
			bpm=214,
			length=6,
			dp=342, ep=632, dp_ep=0, rp=9000,
		},
		{
			id=164,
			name="[20] [215] Flamethrower Jambon Beurre",
			pack="ITGAlex's Stamina Singles",
			difficulty=20,
			steps=5324,
			bpm_tier=210,
			measures=321,
			adj_stream=0.9093,
			bpm=215,
			length=6.88,
			dp=366, ep=685, dp_ep=362, rp=9000,
		},
		{
			id=165,
			name="[20] [220] Out Of Time",
			pack="Psychedelia",
			difficulty=20,
			steps=4200,
			bpm_tier=220,
			measures=255,
			adj_stream=0.8444,
			bpm=220,
			length=5.84,
			dp=488, ep=579, dp_ep=437, rp=9000,
		},
		{
			id=166,
			name="[20] [224] Spiral of Erebos",
			pack="Trails of Cold Stream III",
			difficulty=20,
			steps=2847,
			bpm_tier=220,
			measures=164,
			adj_stream=0.988,
			bpm=224,
			length=3.87,
			dp=586, ep=527, dp_ep=653, rp=9000,
		},
		{
			id=167,
			name="[20] [225] Glorious Crown",
			pack="Stamina Selects",
			difficulty=20,
			steps=3309,
			bpm_tier=220,
			measures=191,
			adj_stream=0.8451,
			bpm=226,
			length=4.08,
			dp=635, ep=422, dp_ep=390, rp=9000,
		},
		{
			id=168,
			name="[20] [226] Black night",
			pack="???",
			difficulty=20,
			steps=3544,
			bpm_tier=220,
			measures=209,
			adj_stream=0.836,
			bpm=226,
			length=4.78,
			dp=635, ep=474, dp_ep=634, rp=9000,
		},
		{
			id=169,
			name="[20] [230] Battle with Rival (Speed Metal Arrange)",
			pack="Jimmy Jawns 4",
			difficulty=20,
			steps=2215,
			bpm_tier=230,
			measures=125,
			adj_stream=0.8333,
			bpm=230,
			length=2.82,
			dp=732, ep=316, dp_ep=348, rp=9000,
		},
		{
			id=170,
			name="[20] [230] Grimm (Restep) (DJKurara Remix)",
			pack="???",
			difficulty=20,
			steps=3205,
			bpm_tier=230,
			measures=163,
			adj_stream=0.6546,
			bpm=230,
			length=4.45,
			dp=732, ep=264, dp_ep=104, rp=9000,
		},
		{
			id=171,
			name="[20] [232] Endless Adventure",
			pack="ITGAlex's Stamina Singles",
			difficulty=20,
			steps=2743,
			bpm_tier=230,
			measures=157,
			adj_stream=0.801,
			bpm=232,
			length=3.93,
			dp=781, ep=369, dp_ep=827, rp=9000,
		},
		{
			id=172,
			name="[20] [234] Ragnarok",
			pack="ITGAlex's Stamina Safari",
			difficulty=20,
			steps=3204,
			bpm_tier=230,
			measures=142,
			adj_stream=0.5966,
			bpm=234,
			length=4.76,
			dp=830, ep=158, dp_ep=66, rp=9000,
		},
		{
			id=173,
			name="[20] [240] Ernst (Ys vs. Sora no Kiseki) (Medium)",
			pack="Trails of Cold Stream III",
			difficulty=20,
			steps=2708,
			bpm_tier=240,
			measures=111,
			adj_stream=0.5311,
			bpm=240,
			length=4.13,
			dp=976, ep=0, dp_ep=10, rp=9000,
		},
		{
			id=174,
			name="[20] [240] Concentrate All Firepower!! (Evolution)",
			pack="Trails of Cold Stream II",
			difficulty=20,
			steps=2054,
			bpm_tier=240,
			measures=115,
			adj_stream=0.7099,
			bpm=240,
			length=2.87,
			dp=976, ep=211, dp_ep=1000, rp=9000,
		},
		{
			id=175,
			name="[20] [240] Reboot",
			pack="StreamVoltex ep.2",
			difficulty=20,
			steps=1533,
			bpm_tier=240,
			measures=79,
			adj_stream=0.6583,
			bpm=240,
			length=2.05,
			dp=976, ep=53, dp_ep=259, rp=9000,
		},
		{
			id=176,
			name="[20] [241] Madness",
			pack="SPEEDCOOOORE 4",
			difficulty=20,
			steps=2025,
			bpm_tier=240,
			measures=104,
			adj_stream=0.638,
			bpm=241,
			length=2.92,
			dp=1000, ep=106, dp_ep=620, rp=9000,
		},
		{
			id=177,
			name="[21] [214] Cranked Pastry Megamix (Side B)",
			pack="Psychedelia",
			difficulty=21,
			steps=23275,
			bpm_tier=210,
			measures=1396,
			adj_stream=0.9382,
			bpm=202,
			length=30.44,
			dp=0, ep=1000, dp_ep=118, rp=10000,
		},
		{
			id=178,
			name="[21] [210] Penultimate Trip",
			pack="BUTTLANDER",
			difficulty=21,
			steps=12079,
			bpm_tier=210,
			measures=731,
			adj_stream=0.9265,
			bpm=208,
			length=16.03,
			dp=120, ep=948, dp_ep=414, rp=10000,
		},
		{
			id=179,
			name="[21] [210] HAUNT Sampler Mix",
			pack="ITGAlex's Stamina Safari",
			difficulty=21,
			steps=10170,
			bpm_tier=210,
			measures=613,
			adj_stream=0.9445,
			bpm=210,
			length=13.09,
			dp=160, ep=895, dp_ep=357, rp=10000,
		},
		{
			id=180,
			name="[21] [219] The Bell FB 219",
			pack="ITGAlex's Stamina Safari",
			difficulty=21,
			steps=6011,
			bpm_tier=210,
			measures=368,
			adj_stream=0.9583,
			bpm=219,
			length=7.49,
			dp=340, ep=790, dp_ep=683, rp=10000,
		},
		{
			id=181,
			name="[21] [220] Sonic Energy",
			pack="Scrapyard Kent",
			difficulty=21,
			steps=5716,
			bpm_tier=220,
			measures=353,
			adj_stream=0.9698,
			bpm=220,
			length=6.64,
			dp=360, ep=737, dp_ep=540, rp=10000,
		},
		{
			id=182,
			name="[21] [220] Funky Fresh Blitz (Restep)",
			pack="Petriform's Factory",
			difficulty=21,
			steps=9542,
			bpm_tier=220,
			measures=567,
			adj_stream=0.8526,
			bpm=220,
			length=12.49,
			dp=360, ep=843, dp_ep=1000, rp=10000,
		},
		{
			id=183,
			name="[21] [226] Dino 2.0 FB 226",
			pack="Scrapyard Kent",
			difficulty=21,
			steps=4661,
			bpm_tier=220,
			measures=276,
			adj_stream=0.8762,
			bpm=226,
			length=5.89,
			dp=480, ep=632, dp_ep=605, rp=10000,
		},
		{
			id=184,
			name="[21] [228] Lunar Eclipse",
			pack="Psychedelia",
			difficulty=21,
			steps=4488,
			bpm_tier=220,
			measures=263,
			adj_stream=0.8457,
			bpm=228,
			length=6.09,
			dp=520, ep=579, dp_ep=548, rp=10000,
		},
		{
			id=185,
			name="[21] [230] Xenoflux",
			pack="The Apocalypse Sampler",
			difficulty=21,
			steps=4215,
			bpm_tier=230,
			measures=258,
			adj_stream=0.9736,
			bpm=218,
			length=5.04,
			dp=320, ep=685, dp_ep=140, rp=10000,
		},
		{
			id=186,
			name="[21] [230] NIGHTMARE CITY",
			pack="ITGAlex's Stamina Singles",
			difficulty=21,
			steps=4463,
			bpm_tier=230,
			measures=250,
			adj_stream=0.753,
			bpm=230,
			length=7.08,
			dp=560, ep=474, dp_ep=266, rp=10000,
		},
		{
			id=187,
			name="[21] [232] Stronger",
			pack="ITGAlex's Stamina Safari",
			difficulty=21,
			steps=3513,
			bpm_tier=230,
			measures=216,
			adj_stream=0.931,
			bpm=232,
			length=4.17,
			dp=600, ep=527, dp_ep=670, rp=10000,
		},
		{
			id=188,
			name="[21] [235] Mario-chi Survivor (Restep)",
			pack="Content Cop - Tachyon Epsilon",
			difficulty=21,
			steps=2429,
			bpm_tier=230,
			measures=141,
			adj_stream=0.8924,
			bpm=235,
			length=3.01,
			dp=660, ep=422, dp_ep=474, rp=10000,
		},
		{
			id=189,
			name="[21] [240] Call of the Hound",
			pack="Content Cop - Tachyon Epsilon",
			difficulty=21,
			steps=2059,
			bpm_tier=240,
			measures=113,
			adj_stream=0.876,
			bpm=240,
			length=2.68,
			dp=760, ep=369, dp_ep=679, rp=10000,
		},
		{
			id=190,
			name="[21] [240] Punch Buggy Slug Bug",
			pack="Petriform's Factory",
			difficulty=21,
			steps=2732,
			bpm_tier=240,
			measures=146,
			adj_stream=0.73,
			bpm=240,
			length=3.5,
			dp=760, ep=316, dp_ep=448, rp=10000,
		},
		{
			id=191,
			name="[21] [246] Metal Max Metals",
			pack="Saitama's Ultimate Weapon",
			difficulty=21,
			steps=2408,
			bpm_tier=240,
			measures=129,
			adj_stream=0.7371,
			bpm=246,
			length=3.28,
			dp=880, ep=264, dp_ep=744, rp=10000,
		},
		{
			id=192,
			name="[21] [248] Omakeno Stroke (HARI KARI REMIX)",
			pack="Jimmy Jawns 3",
			difficulty=21,
			steps=1813,
			bpm_tier=240,
			measures=91,
			adj_stream=0.5583,
			bpm=248,
			length=3.29,
			dp=920, ep=53, dp_ep=0, rp=10000,
		},
		{
			id=193,
			name="[21] [250] Call My Life",
			pack="BangerZ 2",
			difficulty=21,
			steps=1916,
			bpm_tier=250,
			measures=96,
			adj_stream=0.6316,
			bpm=250,
			length=3.79,
			dp=960, ep=106, dp_ep=405, rp=10000,
		},
		{
			id=194,
			name="[21] [250] I'm A Maid (C-type Remix)",
			pack="Rebuild of Sharpnel",
			difficulty=21,
			steps=1814,
			bpm_tier=250,
			measures=96,
			adj_stream=0.6957,
			bpm=250,
			length=2.76,
			dp=960, ep=211, dp_ep=861, rp=10000,
		},
		{
			id=195,
			name="[21] [250] Shakunetsu Candle Master Tomosy",
			pack="Confetto",
			difficulty=21,
			steps=2629,
			bpm_tier=250,
			measures=129,
			adj_stream=0.5265,
			bpm=250,
			length=4.37,
			dp=960, ep=158, dp_ep=631, rp=10000,
		},
		{
			id=196,
			name="[21] [252] The Island (Medium) Pt. 2 (Dusk)",
			pack="Pendulum Act III",
			difficulty=21,
			steps=2275,
			bpm_tier=250,
			measures=103,
			adj_stream=0.4905,
			bpm=252,
			length=4.17,
			dp=1000, ep=0, dp_ep=118, rp=10000,
		},
	}
}

ECS.SongInfo.Upper = {
	-- These values will be calculated and set below.
	MinBpm = 0,
	MaxBpm = 0,
	MinScaled16ths = 0,
	MaxScaled16ths = 0,
	MinBlockLevel = 0,
	MaxBlockLevel = 0,
	MinLength = 0,
	Songs = {
		{
			id=1,
			name="[18] [186] One More Lovely (After After Hours) FP 186",
			pack="Crapyard Scent",
			difficulty=18,
			steps=5994,
			bpm_tier=180,
			measures=358,
			adj_stream=0.9917,
			bpm=186,
			length=8.56,
			dp=0, ep=917, dp_ep=286, rp=1000,
		},
		{
			id=2,
			name="[18] [187] JackOff Marathon FP 187",
			pack="Cranked Pastry",
			difficulty=18,
			steps=6722,
			bpm_tier=180,
			measures=404,
			adj_stream=0.9309,
			bpm=187,
			length=9.43,
			dp=28, ep=1000, dp_ep=571, rp=1000,
		},
		{
			id=3,
			name="[18] [197] Magic Cycles",
			pack="SHARPNELSTREAMZ v3 Part 1",
			difficulty=18,
			steps=3787,
			bpm_tier=190,
			measures=225,
			adj_stream=0.8621,
			bpm=197,
			length=5.46,
			dp=306, ep=500, dp_ep=0, rp=1000,
		},
		{
			id=4,
			name="[18] [198] Hochzeit Girl",
			pack="Scrapyard Kent",
			difficulty=18,
			steps=4079,
			bpm_tier=190,
			measures=240,
			adj_stream=0.8759,
			bpm=198,
			length=6.42,
			dp=334, ep=584, dp_ep=288, rp=1000,
		},
		{
			id=5,
			name="[18] [190] 90's Girly Tekno Beats",
			pack="Morbidly Obese Waves",
			difficulty=18,
			steps=5903,
			bpm_tier=190,
			measures=351,
			adj_stream=0.9213,
			bpm=190,
			length=8.17,
			dp=112, ep=834, dp_ep=360, rp=1000,
		},
		{
			id=6,
			name="[18] [208] Dynasty -Da Capo-",
			pack="BaguetteStreamz 2.5",
			difficulty=18,
			steps=4122,
			bpm_tier=200,
			measures=233,
			adj_stream=0.8204,
			bpm=208,
			length=5.62,
			dp=612, ep=417, dp_ep=574, rp=1000,
		},
		{
			id=7,
			name="[18] [200] Robot Brain Era",
			pack="Cirque du Huayra",
			difficulty=18,
			steps=5535,
			bpm_tier=200,
			measures=324,
			adj_stream=0.8757,
			bpm=200,
			length=7.92,
			dp=389, ep=667, dp_ep=643, rp=1000,
		},
		{
			id=8,
			name="[18] [202] Ruten",
			pack="Scrapyard Kent",
			difficulty=18,
			steps=5583,
			bpm_tier=200,
			measures=335,
			adj_stream=0.9005,
			bpm=202,
			length=7.41,
			dp=445, ep=750, dp_ep=1000, rp=1000,
		},
		{
			id=9,
			name="[18] [215] I Don't Like The Original Title of This Song So I Changed It, F**k You",
			pack="Petriform's Factory",
			difficulty=18,
			steps=2093,
			bpm_tier=210,
			measures=122,
			adj_stream=0.8472,
			bpm=215,
			length=3.11,
			dp=806, ep=167, dp_ep=430, rp=1000,
		},
		{
			id=10,
			name="[18] [210] Driver's High",
			pack="Jayrocking",
			difficulty=18,
			steps=2489,
			bpm_tier=210,
			measures=144,
			adj_stream=0.8571,
			bpm=210,
			length=3.49,
			dp=667, ep=334, dp_ep=502, rp=1000,
		},
		{
			id=11,
			name="[18] [210] Battle for Eternity",
			pack="Gloryhammer",
			difficulty=18,
			steps=2696,
			bpm_tier=210,
			measures=149,
			adj_stream=0.7602,
			bpm=210,
			length=3.87,
			dp=667, ep=250, dp_ep=286, rp=1000,
		},
		{
			id=12,
			name="[18] [222] say it ain't low",
			pack="Goreshit 2020",
			difficulty=18,
			steps=1965,
			bpm_tier=220,
			measures=97,
			adj_stream=0.7185,
			bpm=222,
			length=2.67,
			dp=1000, ep=0, dp_ep=499, rp=1000,
		},
		{
			id=13,
			name="[18] [220] Todestrieb und Lebenstrieb",
			pack="BaguetteStreamz 2.5",
			difficulty=18,
			steps=2895,
			bpm_tier=220,
			measures=147,
			adj_stream=0.6562,
			bpm=220,
			length=4.35,
			dp=945, ep=84, dp_ep=574, rp=1000,
		},
		{
			id=14,
			name="[19] [197] After End Start Before FP 197",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=6864,
			bpm_tier=190,
			measures=408,
			adj_stream=0.9488,
			bpm=197,
			length=9.42,
			dp=156, ep=847, dp_ep=324, rp=2000,
		},
		{
			id=15,
			name="[19] [190] Call Of Beauty FB 190",
			pack="BaguetteStreamz",
			difficulty=19,
			steps=8012,
			bpm_tier=190,
			measures=490,
			adj_stream=1,
			bpm=190,
			length=12.17,
			dp=0, ep=924, dp_ep=80, rp=2000,
		},
		{
			id=16,
			name="[19] [208] Ruten (Angry Luna Mix) FB 208",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=4527,
			bpm_tier=200,
			measures=280,
			adj_stream=0.9655,
			bpm=208,
			length=5.69,
			dp=400, ep=616, dp_ep=364, rp=2000,
		},
		{
			id=17,
			name="[19] [204] 2 Crazy Brothers",
			pack="Masochisma Mk 1",
			difficulty=19,
			steps=5815,
			bpm_tier=200,
			measures=359,
			adj_stream=0.989,
			bpm=204,
			length=7.31,
			dp=312, ep=770, dp_ep=567, rp=2000,
		},
		{
			id=18,
			name="[19] [200] Yaadae",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=6591,
			bpm_tier=200,
			measures=395,
			adj_stream=0.9316,
			bpm=200,
			length=9.04,
			dp=223, ep=693, dp_ep=56, rp=2000,
		},
		{
			id=19,
			name="[19] [200] Lucky Lotus 8 VIP",
			pack="Zaniel's Junts",
			difficulty=19,
			steps=16225,
			bpm_tier=200,
			measures=851,
			adj_stream=0.7298,
			bpm=200,
			length=24.02,
			dp=223, ep=1000, dp_ep=1000, rp=2000,
		},
		{
			id=20,
			name="[19] [210] What Is A Tunecore",
			pack="Morbidly Obese Waves",
			difficulty=19,
			steps=3551,
			bpm_tier=210,
			measures=216,
			adj_stream=0.9643,
			bpm=210,
			length=4.59,
			dp=445, ep=539, dp_ep=265, rp=2000,
		},
		{
			id=21,
			name="[19] [217] So Damn Tough (Kopophobia RMX)",
			pack="Feelin' Rusty 4",
			difficulty=19,
			steps=4483,
			bpm_tier=210,
			measures=251,
			adj_stream=0.848,
			bpm=217,
			length=6.08,
			dp=600, ep=462, dp_ep=505, rp=2000,
		},
		{
			id=22,
			name="[19] [218] Reflection",
			pack="Noah",
			difficulty=19,
			steps=4435,
			bpm_tier=210,
			measures=260,
			adj_stream=0.7808,
			bpm=218,
			length=6.35,
			dp=623, ep=385, dp_ep=339, rp=2000,
		},
		{
			id=23,
			name="[19] [225] Liar, Liar",
			pack="The Joy Of Streaming",
			difficulty=19,
			steps=2153,
			bpm_tier=220,
			measures=130,
			adj_stream=0.8025,
			bpm=225,
			length=3.16,
			dp=778, ep=154, dp_ep=105, rp=2000,
		},
		{
			id=24,
			name="[19] [220] Hustle Bones",
			pack="Death Grips",
			difficulty=19,
			steps=2393,
			bpm_tier=220,
			measures=142,
			adj_stream=0.8875,
			bpm=220,
			length=3.09,
			dp=667, ep=308, dp_ep=237, rp=2000,
		},
		{
			id=25,
			name="[19] [220] Katayoku no Tori",
			pack="Morbidly Obese Waves",
			difficulty=19,
			steps=3051,
			bpm_tier=220,
			measures=179,
			adj_stream=0.7336,
			bpm=220,
			length=4.53,
			dp=667, ep=231, dp_ep=0, rp=2000,
		},
		{
			id=26,
			name="[19] [235] Catch Game Battle of Humankind vs. Ball-Throwing Robot Tama-chan",
			pack="Confetto",
			difficulty=19,
			steps=2347,
			bpm_tier=230,
			measures=124,
			adj_stream=0.6294,
			bpm=235,
			length=3.54,
			dp=1000, ep=77, dp_ep=551, rp=2000,
		},
		{
			id=27,
			name="[19] [232] Tengaku (Medium)",
			pack="Jayrocking",
			difficulty=19,
			steps=2683,
			bpm_tier=230,
			measures=128,
			adj_stream=0.5565,
			bpm=232,
			length=4.45,
			dp=934, ep=0, dp_ep=111, rp=2000,
		},
		{
			id=28,
			name="[20] [208] Fast Animu Music 2020 Reduxx FB 208",
			pack="BaguetteStreamz 2.5",
			difficulty=20,
			steps=7370,
			bpm_tier=200,
			measures=447,
			adj_stream=0.9332,
			bpm=208,
			length=9.62,
			dp=0, ep=917, dp_ep=227, rp=3000,
		},
		{
			id=29,
			name="[20] [209] Cheper FB 209",
			pack="French Coast Stamina 3",
			difficulty=20,
			steps=10346,
			bpm_tier=200,
			measures=596,
			adj_stream=0.8221,
			bpm=209,
			length=14.51,
			dp=30, ep=1000, dp_ep=750, rp=3000,
		},
		{
			id=30,
			name="[20] [217] scotch cherries",
			pack="Goreshit 2020",
			difficulty=20,
			steps=3484,
			bpm_tier=210,
			measures=217,
			adj_stream=0.9954,
			bpm=217,
			length=4.13,
			dp=265, ep=667, dp_ep=297, rp=3000,
		},
		{
			id=31,
			name="[20] [214] Cosmic Energy",
			pack="Scrapyard Kent",
			difficulty=20,
			steps=6005,
			bpm_tier=210,
			measures=355,
			adj_stream=0.9595,
			bpm=214,
			length=7.55,
			dp=177, ep=834, dp_ep=663, rp=3000,
		},
		{
			id=32,
			name="[20] [212] Extreme Ritual",
			pack="Digital Nightmare",
			difficulty=20,
			steps=6186,
			bpm_tier=210,
			measures=362,
			adj_stream=0.905,
			bpm=212,
			length=8.19,
			dp=118, ep=750, dp_ep=0, rp=3000,
		},
		{
			id=33,
			name="[20] [227] thinking of you",
			pack="Goreshit 2020",
			difficulty=20,
			steps=2228,
			bpm_tier=220,
			measures=136,
			adj_stream=1,
			bpm=227,
			length=2.85,
			dp=559, ep=417, dp_ep=500, rp=3000,
		},
		{
			id=34,
			name="[20] [222] Non-existence proof",
			pack="Noah",
			difficulty=20,
			steps=3382,
			bpm_tier=220,
			measures=202,
			adj_stream=0.8559,
			bpm=222,
			length=4.43,
			dp=412, ep=584, dp_ep=593, rp=3000,
		},
		{
			id=35,
			name="[20] [225] Abyssal",
			pack="Masochisma Mk 1",
			difficulty=20,
			steps=4635,
			bpm_tier=220,
			measures=237,
			adj_stream=0.7204,
			bpm=225,
			length=6.4,
			dp=500, ep=500, dp_ep=612, rp=3000,
		},
		{
			id=36,
			name="[20] [234] crossing blue",
			pack="StreamVoltex ep.2",
			difficulty=20,
			steps=1561,
			bpm_tier=230,
			measures=83,
			adj_stream=0.7981,
			bpm=234,
			length=2.02,
			dp=765, ep=167, dp_ep=297, rp=3000,
		},
		{
			id=37,
			name="[20] [230] Countdown",
			pack="ITGAlex's Stamina Singles",
			difficulty=20,
			steps=2794,
			bpm_tier=230,
			measures=161,
			adj_stream=0.7778,
			bpm=230,
			length=3.74,
			dp=648, ep=250, dp_ep=139, rp=3000,
		},
		{
			id=38,
			name="[20] [230] SprrRush!!",
			pack="ITGAlex's Stamina Singles",
			difficulty=20,
			steps=2770,
			bpm_tier=230,
			measures=163,
			adj_stream=0.8069,
			bpm=230,
			length=3.81,
			dp=648, ep=334, dp_ep=528, rp=3000,
		},
		{
			id=39,
			name="[20] [240] GaLaXyEggPlanT",
			pack="StreamVoltex ep.1",
			difficulty=20,
			steps=1431,
			bpm_tier=240,
			measures=78,
			adj_stream=0.8041,
			bpm=240,
			length=1.82,
			dp=942, ep=0, dp_ep=343, rp=3000,
		},
		{
			id=40,
			name="[20] [242] MEGALOVANIA (Camellia Remix)",
			pack="BaguetteStreamz 2.5",
			difficulty=20,
			steps=3767,
			bpm_tier=240,
			measures=167,
			adj_stream=0.5045,
			bpm=242,
			length=6.02,
			dp=1000, ep=84, dp_ep=1000, rp=3000,
		},
		{
			id=41,
			name="[21] [217] FASTER Animu Music 2020 Reduxx FB 217",
			pack="BaguetteStreamz 2.5",
			difficulty=21,
			steps=7704,
			bpm_tier=210,
			measures=459,
			adj_stream=0.8878,
			bpm=217,
			length=9.81,
			dp=171, ep=770, dp_ep=413, rp=4000,
		},
		{
			id=42,
			name="[21] [213] Winter Solstice FP 213",
			pack="Masochisma Mk 1",
			difficulty=21,
			steps=8550,
			bpm_tier=210,
			measures=511,
			adj_stream=0.9257,
			bpm=213,
			length=10.76,
			dp=86, ep=924, dp_ep=637, rp=4000,
		},
		{
			id=43,
			name="[21] [210] nothing is for sure (Side A)",
			pack="Petriform's Factory",
			difficulty=21,
			steps=25175,
			bpm_tier=210,
			measures=1505,
			adj_stream=0.858,
			bpm=209,
			length=33.49,
			dp=0, ep=1000, dp_ep=604, rp=4000,
		},
		{
			id=44,
			name="[21] [228] Video Girl (Petriform Remix)",
			pack="Petriform's Factory",
			difficulty=21,
			steps=3295,
			bpm_tier=220,
			measures=190,
			adj_stream=0.9048,
			bpm=228,
			length=5.05,
			dp=405, ep=539, dp_ep=423, rp=4000,
		},
		{
			id=45,
			name="[21] [220] Dernier Voyage (Hard) 2020 Reduxx",
			pack="BaguetteStreamz 2.5",
			difficulty=21,
			steps=7745,
			bpm_tier=220,
			measures=433,
			adj_stream=0.8109,
			bpm=219,
			length=10.25,
			dp=213, ep=693, dp_ep=299, rp=4000,
		},
		{
			id=46,
			name="[21] [220] Funky Fresh Blitz",
			pack="Petriform's Factory",
			difficulty=21,
			steps=9542,
			bpm_tier=220,
			measures=567,
			adj_stream=0.8526,
			bpm=220,
			length=12.49,
			dp=235, ep=847, dp_ep=871, rp=4000,
		},
		{
			id=47,
			name="[21] [236] Confront",
			pack="Noah",
			difficulty=21,
			steps=2256,
			bpm_tier=230,
			measures=134,
			adj_stream=0.859,
			bpm=236,
			length=2.76,
			dp=575, ep=308, dp_ep=225, rp=4000,
		},
		{
			id=48,
			name="[21] [234] Concentrate All Firepower!! FB 234",
			pack="Trails of Cold Stream IV",
			difficulty=21,
			steps=2346,
			bpm_tier=230,
			measures=141,
			adj_stream=0.9156,
			bpm=234,
			length=2.8,
			dp=532, ep=385, dp_ep=335, rp=4000,
		},
		{
			id=49,
			name="[21] [230] Eternity",
			pack="THE DARK SQUIRRELS OF METAL",
			difficulty=21,
			steps=3496,
			bpm_tier=230,
			measures=217,
			adj_stream=0.9909,
			bpm=230,
			length=3.9,
			dp=447, ep=616, dp_ep=809, rp=4000,
		},
		{
			id=50,
			name="[21] [240] Not The Same (Petriform Cover)",
			pack="Petriform's Factory",
			difficulty=21,
			steps=2533,
			bpm_tier=240,
			measures=139,
			adj_stream=0.7898,
			bpm=240,
			length=3.1,
			dp=660, ep=231, dp_ep=250, rp=4000,
		},
		{
			id=51,
			name="[21] [240] Having Sex",
			pack="Jimmy Jawns 4",
			difficulty=21,
			steps=2757,
			bpm_tier=240,
			measures=153,
			adj_stream=0.7217,
			bpm=240,
			length=3.73,
			dp=660, ep=154, dp_ep=0, rp=4000,
		},
		{
			id=52,
			name="[21] [240] planet of the kemomimi loli",
			pack="katagiri",
			difficulty=21,
			steps=3175,
			bpm_tier=240,
			measures=183,
			adj_stream=0.8206,
			bpm=240,
			length=4.05,
			dp=660, ep=462, dp_ep=1000, rp=4000,
		},
		{
			id=53,
			name="[21] [256] on stage!",
			pack="ITGAlex's Footspeed Fiesta",
			difficulty=21,
			steps=1460,
			bpm_tier=250,
			measures=65,
			adj_stream=0.5,
			bpm=256,
			length=2.77,
			dp=1000, ep=0, dp_ep=604, rp=4000,
		},
		{
			id=54,
			name="[21] [250] Gjallarhorn",
			pack="ITGAlex's Footspeed Fiesta",
			difficulty=21,
			steps=2134,
			bpm_tier=250,
			measures=91,
			adj_stream=0.4892,
			bpm=250,
			length=3.3,
			dp=873, ep=77, dp_ep=442, rp=4000,
		},
		{
			id=55,
			name="[22] [224] Revengeful 255 Train FP 224",
			pack="Morbidly Obese Waves",
			difficulty=22,
			steps=10793,
			bpm_tier=220,
			measures=633,
			adj_stream=0.8474,
			bpm=224,
			length=13.91,
			dp=0, ep=875, dp_ep=128, rp=5000,
		},
		{
			id=56,
			name="[22] [225] Trails of Cold Stream the 3rd (Part 5)",
			pack="Trails of Cold Stream III",
			difficulty=22,
			steps=13613,
			bpm_tier=220,
			measures=759,
			adj_stream=0.7906,
			bpm=225,
			length=18.08,
			dp=28, ep=1000, dp_ep=484, rp=5000,
		},
		{
			id=57,
			name="[22] [237] Your Contract Has Expired FP 237",
			pack="Stamina Secret Santa 2019",
			difficulty=22,
			steps=3672,
			bpm_tier=230,
			measures=222,
			adj_stream=0.9328,
			bpm=237,
			length=4.1,
			dp=362, ep=625, dp_ep=389, rp=5000,
		},
		{
			id=58,
			name="[22] [234] Blaze and determination",
			pack="Noah",
			difficulty=22,
			steps=4063,
			bpm_tier=230,
			measures=244,
			adj_stream=0.9208,
			bpm=234,
			length=4.6,
			dp=278, ep=750, dp_ep=484, rp=5000,
		},
		{
			id=59,
			name="[22] [240] Avenger",
			pack="katagiri",
			difficulty=22,
			steps=2253,
			bpm_tier=240,
			measures=138,
			adj_stream=1,
			bpm=240,
			length=2.53,
			dp=445, ep=375, dp_ep=0, rp=5000,
		},
		{
			id=60,
			name="[22] [244] FLYING OUT TO THE SKY",
			pack="Confetto",
			difficulty=22,
			steps=3723,
			bpm_tier=240,
			measures=208,
			adj_stream=0.8421,
			bpm=244,
			length=4.43,
			dp=556, ep=500, dp_ep=549, rp=5000,
		},
		{
			id=61,
			name="[22] [258] Kangokurakuou",
			pack="StreamVoltex ep.2",
			difficulty=22,
			steps=1458,
			bpm_tier=250,
			measures=76,
			adj_stream=0.7238,
			bpm=258,
			length=1.84,
			dp=945, ep=0, dp_ep=291, rp=5000,
		},
		{
			id=62,
			name="[22] [252] The Island (Hard) Pt. 2 (Dusk)",
			pack="Pendulum Act III",
			difficulty=22,
			steps=2471,
			bpm_tier=250,
			measures=120,
			adj_stream=0.5714,
			bpm=252,
			length=4.17,
			dp=778, ep=125, dp_ep=194, rp=5000,
		},
		{
			id=63,
			name="[22] [260] IMAGE-MATERIAL <REFLEC BEAT Edition>",
			pack="StoryTime Chapter 1",
			difficulty=22,
			steps=1234,
			bpm_tier=260,
			measures=71,
			adj_stream=0.8161,
			bpm=260,
			length=1.88,
			dp=1000, ep=250, dp_ep=1000, rp=5000,
		},
		{
			id=64,
			name="[23] [238] Apocynthion Drive FB 238",
			pack="SRPG3",
			difficulty=23,
			steps=5067,
			bpm_tier=230,
			measures=299,
			adj_stream=0.9172,
			bpm=238,
			length=5.6,
			dp=200, ep=875, dp_ep=667, rp=6000,
		},
		{
			id=65,
			name="[23] [230] Stamina Nation Megamix 2",
			pack="Jimmy Jawns 4",
			difficulty=23,
			steps=12975,
			bpm_tier=230,
			measures=748,
			adj_stream=0.8034,
			bpm=230,
			length=16.63,
			dp=0, ep=1000, dp_ep=167, rp=6000,
		},
		{
			id=66,
			name="[23] [249] Bwark?",
			pack="Petriform's Factory",
			difficulty=23,
			steps=3258,
			bpm_tier=240,
			measures=185,
			adj_stream=0.7974,
			bpm=249,
			length=4.34,
			dp=475, ep=500, dp_ep=0, rp=6000,
		},
		{
			id=67,
			name="[23] [240] H.A.R.D.C.O.R.E.",
			pack="Morbidly Obese Waves",
			difficulty=23,
			steps=4988,
			bpm_tier=240,
			measures=294,
			adj_stream=0.9046,
			bpm=240,
			length=5.85,
			dp=250, ep=750, dp_ep=167, rp=6000,
		},
		{
			id=68,
			name="[23] [250] Code Name- Foxtrot",
			pack="katagiri",
			difficulty=23,
			steps=2646,
			bpm_tier=250,
			measures=163,
			adj_stream=0.9157,
			bpm=250,
			length=3.15,
			dp=500, ep=625, dp_ep=1000, rp=6000,
		},
		{
			id=69,
			name="[23] [255] Cartoon Heroes (Speedy Mix)",
			pack="Dump Dump Revolution",
			difficulty=23,
			steps=2958,
			bpm_tier=250,
			measures=170,
			adj_stream=0.8057,
			bpm=255,
			length=3.84,
			dp=625, ep=375, dp_ep=167, rp=6000,
		},
		{
			id=70,
			name="[23] [266] NaiNai 69",
			pack="Jimmy Jawns 4",
			difficulty=23,
			steps=1673,
			bpm_tier=260,
			measures=83,
			adj_stream=0.7411,
			bpm=266,
			length=2.26,
			dp=900, ep=125, dp_ep=334, rp=6000,
		},
		{
			id=71,
			name="[23] [260] Otworz Oczy (Bez Miesa Version)",
			pack="Kyypakkaus",
			difficulty=23,
			steps=1834,
			bpm_tier=260,
			measures=95,
			adj_stream=0.76,
			bpm=260,
			length=2.45,
			dp=750, ep=250, dp_ep=167, rp=6000,
		},
		{
			id=72,
			name="[23] [270] Rabbit in the Black Room",
			pack="Morbidly Obese Waves",
			difficulty=23,
			steps=1399,
			bpm_tier=270,
			measures=60,
			adj_stream=0.566,
			bpm=270,
			length=2.21,
			dp=1000, ep=0, dp_ep=167, rp=6000,
		},
		{
			id=73,
			name="[24] [244] Wings of Stones FB 244",
			pack="Morbidly Obese Waves",
			difficulty=24,
			steps=7363,
			bpm_tier=240,
			measures=443,
			adj_stream=0.9801,
			bpm=244,
			length=8.16,
			dp=0, ep=1000, dp_ep=293, rp=7000,
		},
		{
			id=74,
			name="[24] [250] Tachyon Beam Cannon",
			pack="Jimmy Jawns 4",
			difficulty=24,
			steps=3205,
			bpm_tier=250,
			measures=191,
			adj_stream=0.9845,
			bpm=250,
			length=3.55,
			dp=167, ep=858, dp_ep=403, rp=7000,
		},
		{
			id=75,
			name="[24] [257] Crimson",
			pack="Morbidly Obese Waves",
			difficulty=24,
			steps=3803,
			bpm_tier=250,
			measures=211,
			adj_stream=0.7153,
			bpm=257,
			length=4.87,
			dp=362, ep=572, dp_ep=0, rp=7000,
		},
		{
			id=76,
			name="[24] [264] Condemnation Wings II",
			pack="Morbidly Obese Waves",
			difficulty=24,
			steps=2091,
			bpm_tier=260,
			measures=127,
			adj_stream=0.9769,
			bpm=264,
			length=2.27,
			dp=556, ep=429, dp_ep=226, rp=7000,
		},
		{
			id=77,
			name="[24] [260] Masochist",
			pack="Pendulum Act III",
			difficulty=24,
			steps=3150,
			bpm_tier=260,
			measures=186,
			adj_stream=0.8416,
			bpm=260,
			length=3.54,
			dp=445, ep=715, dp_ep=1000, rp=7000,
		},
		{
			id=78,
			name="[24] [270] High-Dimensional Space",
			pack="BangerZ",
			difficulty=24,
			steps=1811,
			bpm_tier=270,
			measures=74,
			adj_stream=1,
			bpm=270,
			length=2.69,
			dp=723, ep=286, dp_ep=332, rp=7000,
		},
		{
			id=79,
			name="[24] [275] Chu Chu Lovely (Maximum The Hormone Cover)",
			pack="Jimmy Jawns 4",
			difficulty=24,
			steps=1592,
			bpm_tier=270,
			measures=89,
			adj_stream=0.8091,
			bpm=275,
			length=1.66,
			dp=862, ep=143, dp_ep=315, rp=7000,
		},
		{
			id=80,
			name="[24] [280] NITRO PANIC!",
			pack="fof",
			difficulty=24,
			steps=1584,
			bpm_tier=280,
			measures=80,
			adj_stream=0.597,
			bpm=280,
			length=2.5,
			dp=1000, ep=0, dp_ep=293, rp=7000,
		},
		{
			id=81,
			name="[25] [256] Yume No Tsuzuki (DJ HypeBeat Remaster)",
			pack="City Pop",
			difficulty=25,
			steps=4493,
			bpm_tier=250,
			measures=274,
			adj_stream=0.9856,
			bpm=256,
			length=4.77,
			dp=0, ep=834, dp_ep=0, rp=8000,
		},
		{
			id=82,
			name="[25] [268] Battle #3",
			pack="fof",
			difficulty=25,
			steps=3794,
			bpm_tier=260,
			measures=219,
			adj_stream=0.8939,
			bpm=268,
			length=4.09,
			dp=500, ep=667, dp_ep=1000, rp=8000,
		},
		{
			id=83,
			name="[25] [260] Alice in Underground",
			pack="BaguetteStreamz 2.5",
			difficulty=25,
			steps=5932,
			bpm_tier=260,
			measures=339,
			adj_stream=0.8737,
			bpm=260,
			length=6.28,
			dp=167, ep=1000, dp_ep=1000, rp=8000,
		},
		{
			id=84,
			name="[25] [270] Epic Manner",
			pack="Content Cop - Tachyon Epsilon",
			difficulty=25,
			steps=2173,
			bpm_tier=270,
			measures=123,
			adj_stream=0.8542,
			bpm=270,
			length=2.53,
			dp=584, ep=334, dp_ep=253, rp=8000,
		},
		{
			id=85,
			name="[25] [270] Burnout",
			pack="ITGAlex's Footspeed Fiesta",
			difficulty=25,
			steps=3546,
			bpm_tier=270,
			measures=196,
			adj_stream=0.7538,
			bpm=270,
			length=4.53,
			dp=584, ep=500, dp_ep=751, rp=8000,
		},
		{
			id=86,
			name="[25] [280] Magus Night Fever",
			pack="Tachyon Rebirth",
			difficulty=25,
			steps=1792,
			bpm_tier=280,
			measures=98,
			adj_stream=0.8376,
			bpm=280,
			length=1.83,
			dp=1000, ep=167, dp_ep=1000, rp=8000,
		},
		{
			id=87,
			name="[25] [280] Penguins Prank Party",
			pack="katagiri",
			difficulty=25,
			steps=2222,
			bpm_tier=280,
			measures=117,
			adj_stream=0.7091,
			bpm=280,
			length=2.73,
			dp=1000, ep=0, dp_ep=499, rp=8000,
		},
		{
			id=88,
			name="[26] [250] Chipspeed Legacy",
			pack="Morbidly Obese Waves",
			difficulty=26,
			steps=19143,
			bpm_tier=250,
			measures=1144,
			adj_stream=0.8854,
			bpm=250,
			length=21.97,
			dp=0, ep=1000, dp_ep=0, rp=9000,
		},
		{
			id=89,
			name="[26] [262] Silent Desert (Super Arrange)",
			pack="Trails of Cold Stream IV",
			difficulty=26,
			steps=5423,
			bpm_tier=260,
			measures=310,
			adj_stream=0.9118,
			bpm=262,
			length=5.71,
			dp=375, ep=667, dp_ep=1000, rp=9000,
		},
		{
			id=90,
			name="[26] [272] Holy Orders (Be Just or Be Dead) (Exploding Festival Ver.)",
			pack="Saitama's Ultimate Weapon",
			difficulty=26,
			steps=3956,
			bpm_tier=270,
			measures=222,
			adj_stream=0.8605,
			bpm=272,
			length=4.09,
			dp=688, ep=334, dp_ep=524, rp=9000,
		},
		{
			id=91,
			name="[26] [282] Lay Your Hands On Me",
			pack="fof",
			difficulty=26,
			steps=2800,
			bpm_tier=280,
			measures=144,
			adj_stream=0.7826,
			bpm=282,
			length=3.76,
			dp=1000, ep=0, dp_ep=0, rp=9000,
		},
	}
}

local InitializeSongStats = function(SongInfo)
	for song_data in ivalues(SongInfo.Songs) do
		SongInfo.MinBpm = SongInfo.MinBpm == 0 and song_data.bpm or math.min(SongInfo.MinBpm, song_data.bpm)
		SongInfo.MaxBpm = SongInfo.MaxBpm == 0 and song_data.bpm or math.max(SongInfo.MaxBpm, song_data.bpm)
		SongInfo.MinScaled16ths = SongInfo.MinScaled16ths == 0 and song_data.measures or math.min(SongInfo.MinScaled16ths, song_data.measures)
		SongInfo.MaxScaled16ths = SongInfo.MaxScaled16ths == 0 and song_data.measures or math.max(SongInfo.MaxScaled16ths, song_data.measures)
		SongInfo.MinBlockLevel = SongInfo.MinBlockLevel == 0 and song_data.difficulty or math.min(SongInfo.MinBlockLevel, song_data.difficulty)
		SongInfo.MaxBlockLevel = SongInfo.MaxBlockLevel == 0 and song_data.difficulty or math.max(SongInfo.MaxBlockLevel, song_data.difficulty)
		SongInfo.MinLength = SongInfo.MinLength == 0 and song_data.length or math.min(SongInfo.MinLength, song_data.length)
	end
end

InitializeSongStats(ECS.SongInfo.Lower)
InitializeSongStats(ECS.SongInfo.Upper)

-- ------------------------------------------------------
-- Player Data

-- initial player relic data
ECS.Players = {}

ECS.Players["fof"] = {
	id=66683,
	isupper=true,
	country="Canada",
	level=99,
	exp=3867047,
	relics = {
		{name="Silver Stopwatch",	quantity=7},
		{name="Agility Potion",	quantity=2},
		{name="Malefic Adumbration",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Gae Buide",	quantity=1},
		{name="Endurend",	quantity=1},
		{name="Laevitas",	quantity=1},
		{name="Armajejjon",	quantity=1},
		{name="Gae Derg",	quantity=1},
		{name="Endless River",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Throne",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Astral Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
		{name="Faust's Scalpel",	quantity=1},
		{name="Reid",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=10, [140]=5, [150]=58, [160]=30, [170]=49, [180]=31, [190]=13, [200]=39, [210]=31, [220]=42, [230]=62, [240]=73, [250]=99, [260]=99, [270]=99, [280]=99},
	affinities = {dp=0, ep=0, rp=800, ap=0},
	lifetime_song_gold = 3719,
	lifetime_jp = 1764142,
}

ECS.Players["baconandeggs"] = {
	id=66550,
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=5727204,
	relics = {
		{name="Blood Rune",	quantity=1},
		{name="Agility Potion",	quantity=1},
		{name="Dragon Arrow",	quantity=1},
		{name="Crystal Dagger",	quantity=1},
		{name="Diamond Dagger",	quantity=1},
		{name="Twisted Bow",	quantity=1},
		{name="Malefic Adumbration",	quantity=1},
		{name="Ivory Tower",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Caliburn",	quantity=1},
		{name="Doom Sickle",	quantity=1},
		{name="Bravura",	quantity=1},
		{name="Kusanagi",	quantity=1},
		{name="Gae Buide",	quantity=1},
		{name="Endurend",	quantity=1},
		{name="Laevitas",	quantity=1},
		{name="Armajejjon",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Clarent",	quantity=1},
		{name="Wuuthrad",	quantity=1},
		{name="Masamune",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Vampiric Longsword",	quantity=1},
		{name="Anduril",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Throne",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Astral Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
		{name="Faust's Scalpel",	quantity=1},
		{name="Reid",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=16, [150]=99, [160]=27, [170]=37, [180]=14, [190]=4, [200]=35, [210]=99, [220]=99, [230]=99, [240]=99, [250]=99, [260]=99, [270]=99, [280]=99},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6163,
	lifetime_jp = 2910064,
}

ECS.Players["Rawinput"] = {
	id=1975,
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=3297084,
	relics = {
		{name="Astral Earring",	quantity=7},
		{name="Malefic Adumbration",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Laevitas",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Throne",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Astral Ring",	quantity=1},
		{name="Champion Belt",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
		{name="Faust's Scalpel",	quantity=1},
		{name="Reid",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=83, [160]=99, [170]=99, [180]=77, [190]=55, [200]=25, [210]=19, [220]=21, [230]=18, [240]=30, [250]=52, [260]=60, [270]=99, [280]=52},
	affinities = {dp=800, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10642,
	lifetime_jp = 913873,
}

ECS.Players["Jake B"] = {
	id=66685,
	isupper=true,
	country="Canada",
	level=97,
	exp=2536114,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Throne",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
		{name="Faust's Scalpel",	quantity=1},
		{name="Reid",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=78, [160]=47, [170]=49, [180]=19, [190]=17, [200]=40, [210]=20, [220]=28, [230]=44, [240]=49, [250]=45, [260]=30, [270]=74, [280]=41},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4552,
	lifetime_jp = 563674,
}

ECS.Players["nico"] = {
	id=35619,
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=5714314,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Mythril Arrow",	quantity=1},
		{name="Astral Earring",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Agility Potion",	quantity=1},
		{name="Dragon Arrow",	quantity=1},
		{name="Twisted Bow",	quantity=1},
		{name="Malefic Adumbration",	quantity=1},
		{name="Ivory Tower",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Kusanagi",	quantity=1},
		{name="Gae Buide",	quantity=1},
		{name="Endurend",	quantity=1},
		{name="Laevitas",	quantity=1},
		{name="Armajejjon",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Astral Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
		{name="Faust's Scalpel",	quantity=1},
		{name="Reid",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=87, [190]=66, [200]=55, [210]=50, [220]=65, [230]=74, [240]=99, [250]=99, [260]=99, [270]=99, [280]=99},
	affinities = {dp=0, ep=0, rp=800, ap=0},
	lifetime_song_gold = 15258,
	lifetime_jp = 2505645,
}

ECS.Players["Aoreo"] = {
	id=4707,
	isupper=true,
	country="Canada",
	level=95,
	exp=2131970,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Throne",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
		{name="Faust's Scalpel",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=40, [190]=39, [200]=49, [210]=40, [220]=44, [230]=43, [240]=47, [250]=41, [260]=35, [270]=71, [280]=32},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 30197,
	lifetime_jp = 420694,
}

ECS.Players["Milkopia"] = {
	id=8209,
	isupper=true,
	country="Unspecified",
	level=96,
	exp=2287510,
	relics = {
		{name="Diamond Dagger",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Leavitas",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Cowboy Hat",	quantity=1},
		{name="GUNgnir",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=42, [150]=38, [160]=24, [170]=43, [180]=30, [190]=48, [200]=59, [210]=56, [220]=47, [230]=66, [240]=61, [250]=55, [260]=49, [270]=70, [280]=36},
	affinities = {dp=729, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4726,
	lifetime_jp = 518247,
}

ECS.Players["SoftTofu"] = {
	id=886,
	isupper=true,
	country="U.S.A.",
	level=97,
	exp=2470573,
	relics = {
		{name="Astral Earring",	quantity=4},
		{name="Silver Stopwatch",	quantity=5},
		{name="Lance of Longinus",	quantity=1},
		{name="Mammon",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Gram",	quantity=1},
		{name="Caliburn",	quantity=1},
		{name="Doom Sickle",	quantity=1},
		{name="Bravura",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Artemis Bow",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Skofnung",	quantity=1},
		{name="Clarent",	quantity=1},
		{name="Scythe of Vitur",	quantity=1},
		{name="Wuuthrad",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Vampiric Longsword",	quantity=1},
		{name="Anduril",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Throne",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=99, [220]=99, [230]=99, [240]=94, [250]=56, [260]=36, [270]=14, [280]=9},
	affinities = {dp=0, ep=746, rp=0, ap=0},
	lifetime_song_gold = 120820,
	lifetime_jp = 206252,
}

ECS.Players["DownArrowCatastrophe"] = {
	id=66667,
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=2860809,
	relics = {
		{name="Astral Earring",	quantity=3},
		{name="Lance of Longinus",	quantity=1},
		{name="Dragon Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Heavy Glaive",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Gram",	quantity=1},
		{name="Caliburn",	quantity=1},
		{name="Doom Sickle",	quantity=1},
		{name="Bravura",	quantity=1},
		{name="Kusanagi",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Artemis Bow",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Skofnung",	quantity=1},
		{name="Clarent",	quantity=1},
		{name="Scythe of Vitur",	quantity=1},
		{name="Masamune",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Vampiric Longsword",	quantity=1},
		{name="Perish",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Astral Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=99, [220]=99, [230]=99, [240]=99, [250]=60, [260]=18, [270]=7, [280]=3},
	affinities = {dp=0, ep=0, rp=800, ap=0},
	lifetime_song_gold = 31598,
	lifetime_jp = 182216,
}

ECS.Players["Akou"] = {
	id=73042,
	isupper=true,
	country="U.S.A.",
	level=86,
	exp=997186,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Double Warblade",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=22, [140]=3, [150]=1, [160]=5, [170]=11, [180]=19, [190]=24, [200]=37, [210]=35, [220]=67, [230]=57, [240]=39, [250]=24, [260]=24, [270]=1, [280]=1},
	affinities = {dp=175, ep=175, rp=100, ap=120},
	lifetime_song_gold = 19257,
	lifetime_jp = 80198,
}

ECS.Players["feedbacker"] = {
	id=66677,
	isupper=true,
	country="South Korea",
	level=85,
	exp=937438,
	relics = {
		{name="Stone Arrow",	quantity=25},
		{name="Crystal Sword",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=48, [140]=15, [150]=47, [160]=36, [170]=41, [180]=38, [190]=22, [200]=45, [210]=41, [220]=44, [230]=44, [240]=12, [250]=9, [260]=5, [270]=3, [280]=1},
	affinities = {dp=0, ep=555, rp=0, ap=0},
	lifetime_song_gold = 22941,
	lifetime_jp = 26498,
}

ECS.Players["Archi"] = {
	id=6562,
	isupper=true,
	country="U.S.A.",
	level=97,
	exp=2387055,
	relics = {
		{name="Silver Stopwatch",	quantity=4},
		{name="Lance of Longinus",	quantity=1},
		{name="Mammon",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sakabato",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Gram",	quantity=1},
		{name="Caliburn",	quantity=1},
		{name="Doom Sickle",	quantity=1},
		{name="Bravura",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Artemis Bow",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Skofnung",	quantity=1},
		{name="Clarent",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=99, [220]=99, [230]=99, [240]=64, [250]=19, [260]=3, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=746},
	lifetime_song_gold = 101162,
	lifetime_jp = 60662,
}

ECS.Players["SteveReen"] = {
	id=5023,
	isupper=true,
	country="U.S.A.",
	level=87,
	exp=1081410,
	relics = {
		{name="Crystal Sword",	quantity=1},
		{name="Silver Stopwatch",	quantity=3},
		{name="Lance of Longinus",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Anduril",	quantity=1},
		{name="Claiomh Solais",	quantity=1},
		{name="Aegis",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=67, [140]=50, [150]=50, [160]=39, [170]=80, [180]=59, [190]=99, [200]=43, [210]=32, [220]=59, [230]=39, [240]=19, [250]=6, [260]=1, [270]=1, [280]=1},
	affinities = {dp=70, ep=80, rp=85, ap=350},
	lifetime_song_gold = 58733,
	lifetime_jp = 12503,
}

ECS.Players["nidyz"] = {
	id=66678,
	isupper=true,
	country="Netherlands",
	level=81,
	exp=649326,
	relics = {
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=1, [140]=11, [150]=13, [160]=22, [170]=26, [180]=22, [190]=19, [200]=18, [210]=26, [220]=39, [230]=33, [240]=34, [250]=9, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12186,
	lifetime_jp = 21419,
}

ECS.Players["Hsarus"] = {
	id=66471,
	isupper=true,
	country="Canada",
	level=92,
	exp=1695791,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Astral Earring",	quantity=4},
		{name="Lance of Longinus",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Gram",	quantity=1},
		{name="Caliburn",	quantity=1},
		{name="Doom Sickle",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Artemis Bow",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Skofnung",	quantity=1},
		{name="Clarent",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=99, [220]=99, [230]=49, [240]=12, [250]=2, [260]=1, [270]=1, [280]=1},
	affinities = {dp=107, ep=300, rp=150, ap=106},
	lifetime_song_gold = 61190,
	lifetime_jp = 10598,
}

ECS.Players["CardboardBox"] = {
	id=7260,
	isupper=true,
	country="Canada",
	level=80,
	exp=606916,
	relics = {
		{name="Sakabato",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Champion Belt",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=2, [170]=18, [180]=15, [190]=10, [200]=15, [210]=14, [220]=27, [230]=18, [240]=37, [250]=11, [260]=18, [270]=9, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6038,
	lifetime_jp = 76382,
}

ECS.Players["Bran"] = {
	id=7457,
	isupper=true,
	country="U.S.A.",
	level=80,
	exp=605141,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Shuriken",	quantity=1},
		{name="Lance of Longinus",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Anduril",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=4, [140]=3, [150]=20, [160]=16, [170]=31, [180]=18, [190]=22, [200]=20, [210]=20, [220]=28, [230]=24, [240]=23, [250]=18, [260]=6, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 28881,
	lifetime_jp = 38115,
}

ECS.Players["Matt Magdon"] = {
	id=6657,
	isupper=true,
	country="U.S.A.",
	level=86,
	exp=1043961,
	relics = {
		{name="Shuriken",	quantity=6},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Ryuko's Scissor Blade",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
		{name="Pandemonium Zero",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=77, [150]=81, [160]=70, [170]=70, [180]=99, [190]=56, [200]=54, [210]=43, [220]=52, [230]=37, [240]=20, [250]=6, [260]=4, [270]=5, [280]=1},
	affinities = {dp=170, ep=0, rp=400, ap=0},
	lifetime_song_gold = 10202,
	lifetime_jp = 24429,
}

ECS.Players["hippaheikki"] = {
	id=6039,
	isupper=true,
	country="Finland",
	level=74,
	exp=386350,
	relics = {
		{name="Carolingian Sword",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=4, [140]=1, [150]=1, [160]=7, [170]=20, [180]=11, [190]=14, [200]=43, [210]=24, [220]=40, [230]=14, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2158,
	lifetime_jp = 0,
}

ECS.Players["NBCrescendo"] = {
	id=6069,
	isupper=true,
	country="Finland",
	level=86,
	exp=985882,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=27},
		{name="Mythril Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Gram",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Skofnung",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=69, [180]=44, [190]=99, [200]=99, [210]=48, [220]=31, [230]=21, [240]=6, [250]=3, [260]=1, [270]=3, [280]=1},
	affinities = {dp=9, ep=500, rp=60, ap=1},
	lifetime_song_gold = 11534,
	lifetime_jp = 8499,
}

ECS.Players["Urza89"] = {
	id=66763,
	isupper=true,
	country="Sweden",
	level=84,
	exp=881868,
	relics = {
		{name="Bronze Arrow",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Shuriken",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Artemis Bow",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=62, [200]=52, [210]=52, [220]=42, [230]=16, [240]=9, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=540, rp=0, ap=0},
	lifetime_song_gold = 16748,
	lifetime_jp = 1344,
}

ECS.Players["Sidro"] = {
	id=66613,
	isupper=true,
	country="U.S.A.",
	level=85,
	exp=944179,
	relics = {
		{name="Bronze Arrow",	quantity=6},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Fursuit",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=18, [150]=40, [160]=35, [170]=55, [180]=99, [190]=60, [200]=51, [210]=61, [220]=56, [230]=25, [240]=6, [250]=2, [260]=1, [270]=1, [280]=1},
	affinities = {dp=555, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6639,
	lifetime_jp = 4098,
}

ECS.Players["Arvin"] = {
	id=4866,
	isupper=true,
	country="Canada",
	level=75,
	exp=392525,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Crystal Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=3, [230]=3, [240]=7, [250]=6, [260]=1, [270]=7, [280]=5},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 154096,
}

ECS.Players["Maxx-Storm"] = {
	id=935,
	isupper=true,
	country="United Kingdom",
	level=84,
	exp=854599,
	relics = {
		{name="Stone Arrow",	quantity=6},
		{name="Mythril Arrow",	quantity=1},
		{name="Shuriken",	quantity=7},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=43, [140]=51, [150]=67, [160]=36, [170]=92, [180]=41, [190]=39, [200]=51, [210]=56, [220]=47, [230]=42, [240]=17, [250]=6, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 30884,
	lifetime_jp = 10512,
}

ECS.Players["ITGAlex"] = {
	id=46152,
	isupper=true,
	country="U.S.A.",
	level=86,
	exp=1009338,
	relics = {
		{name="Stone Arrow",	quantity=1},
		{name="Mythril Arrow",	quantity=2},
		{name="Diamond Sword",	quantity=1},
		{name="Shuriken",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=49, [210]=44, [220]=30, [230]=23, [240]=13, [250]=4, [260]=2, [270]=1, [280]=1},
	affinities = {dp=170, ep=0, rp=0, ap=400},
	lifetime_song_gold = 63200,
	lifetime_jp = 10495,
}

ECS.Players["HISA"] = {
	id=66727,
	isupper=true,
	country="Japan",
	level=72,
	exp=308489,
	relics = {
		{name="Carolingian Sword",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=18, [140]=1, [150]=4, [160]=14, [170]=11, [180]=15, [190]=23, [200]=47, [210]=12, [220]=9, [230]=4, [240]=4, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=100, ep=100, rp=171, ap=0},
	lifetime_song_gold = 2959,
	lifetime_jp = 2930,
}

ECS.Players["Dr.0ctgonapus"] = {
	id=66554,
	isupper=false,
	country="U.S.A.",
	level=77,
	exp=462904,
	relics = {
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=79, [130]=34, [140]=10, [150]=2, [160]=15, [170]=29, [180]=18, [190]=21, [200]=34, [210]=20, [220]=39, [230]=24, [240]=7, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9771,
	lifetime_jp = 1359,
}

ECS.Players["dominick_v"] = {
	id=66762,
	isupper=false,
	country="U.S.A.",
	level=89,
	exp=1277000,
	relics = {
		{name="Bronze Arrow",	quantity=2},
		{name="Mythril Arrow",	quantity=1},
		{name="Diamond Sword",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Scythe",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="BURGER",	quantity=1},
		{name="Ryuko's Scissor Blade",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
		{name="Arvin's Gambit",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=70, [200]=48, [210]=61, [220]=51, [230]=31, [240]=10, [250]=2, [260]=1, [270]=1, [280]=1},
	affinities = {dp=100, ep=200, rp=0, ap=315},
	lifetime_song_gold = 49414,
	lifetime_jp = 7182,
}

ECS.Players["Dingoshi"] = {
	id=66546,
	isupper=false,
	country="Australia",
	level=74,
	exp=369279,
	relics = {
		{name="Stone Arrow",	quantity=18},
		{name="Bronze Arrow",	quantity=3},
		{name="Long Bow",	quantity=1},
		{name="Jagged Greataxe",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=4, [140]=1, [150]=8, [160]=17, [170]=15, [180]=21, [190]=19, [200]=17, [210]=17, [220]=15, [230]=28, [240]=7, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=407, ap=0},
	lifetime_song_gold = 4214,
	lifetime_jp = 3484,
}

ECS.Players["JWong"] = {
	id=76367,
	isupper=false,
	country="U.S.A.",
	level=80,
	exp=602034,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=68, [190]=99, [200]=69, [210]=15, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=150, ep=150, rp=134, ap=50},
	lifetime_song_gold = 25651,
	lifetime_jp = 0,
}

ECS.Players["Jeremyy"] = {
	id=2114,
	isupper=false,
	country="U.S.A.",
	level=65,
	exp=176587,
	relics = {
		{name="Steel Wheat Bun",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=4, [180]=4, [190]=2, [200]=5, [210]=4, [220]=8, [230]=6, [240]=3, [250]=6, [260]=3, [270]=3, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 425,
	lifetime_jp = 17697,
}

ECS.Players["Murd"] = {
	id=66755,
	isupper=false,
	country="Canada",
	level=80,
	exp=594127,
	relics = {
		{name="Stone Arrow",	quantity=3},
		{name="Bronze Arrow",	quantity=4},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Hauteclere",	quantity=1},
		{name="Durandal",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=39, [140]=39, [150]=65, [160]=72, [170]=62, [180]=99, [190]=99, [200]=38, [210]=26, [220]=10, [230]=3, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6584,
	lifetime_jp = 2432,
}

ECS.Players["4199"] = {
	id=66692,
	isupper=false,
	country="Canada",
	level=68,
	exp=222065,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=10, [140]=1, [150]=1, [160]=4, [170]=6, [180]=2, [190]=6, [200]=9, [210]=10, [220]=9, [230]=9, [240]=11, [250]=6, [260]=2, [270]=1, [280]=1},
	affinities = {dp=100, ep=69, rp=100, ap=25},
	lifetime_song_gold = 1905,
	lifetime_jp = 11399,
}

ECS.Players["skateinmars"] = {
	id=66545,
	isupper=false,
	country="France",
	level=81,
	exp=689824,
	relics = {
		{name="Bronze Arrow",	quantity=7},
		{name="Shuriken",	quantity=3},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=88, [200]=60, [210]=32, [220]=28, [230]=13, [240]=2, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=198, ep=0, rp=300, ap=0},
	lifetime_song_gold = 24608,
	lifetime_jp = 1886,
}

ECS.Players["Tuuc"] = {
	id=7036,
	isupper=false,
	country="Finland",
	level=78,
	exp=512152,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=19, [150]=32, [160]=21, [170]=57, [180]=38, [190]=29, [200]=38, [210]=30, [220]=14, [230]=5, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=458, ap=0},
	lifetime_song_gold = 1306,
	lifetime_jp = 282,
}

ECS.Players["DF.CaptainBlack"] = {
	id=7737,
	isupper=false,
	country="U.S.A.",
	level=76,
	exp=450965,
	relics = {
		{name="Crystal Sword",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Ryuko's Scissor Blade",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Champion Belt",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=30, [150]=52, [160]=30, [170]=57, [180]=56, [190]=59, [200]=47, [210]=12, [220]=5, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=50, rp=200, ap=182},
	lifetime_song_gold = 22117,
	lifetime_jp = 0,
}

ECS.Players["saddong"] = {
	id=128282,
	isupper=false,
	country="U.S.A.",
	level=68,
	exp=217531,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=5, [190]=23, [200]=31, [210]=12, [220]=18, [230]=11, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7,
	lifetime_jp = 0,
}

ECS.Players["Nandii"] = {
	id=78597,
	isupper=false,
	country="Netherlands",
	level=74,
	exp=374279,
	relics = {
		{name="Stone Arrow",	quantity=4},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Arrow",	quantity=2},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Rending Scissors",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=46, [150]=99, [160]=60, [170]=59, [180]=35, [190]=44, [200]=35, [210]=16, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3881,
	lifetime_jp = 35,
}

ECS.Players["Yoney"] = {
	id=6118,
	isupper=false,
	country="U.S.A.",
	level=77,
	exp=473724,
	relics = {
		{name="Bronze Arrow",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Nui's Scissor Blade",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=65, [140]=40, [150]=65, [160]=44, [170]=62, [180]=71, [190]=73, [200]=53, [210]=24, [220]=7, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=445, ap=0},
	lifetime_song_gold = 14756,
	lifetime_jp = 0,
}

ECS.Players["Fieoner"] = {
	id=66724,
	isupper=false,
	country="Spain",
	level=75,
	exp=406251,
	relics = {
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=24, [150]=54, [160]=18, [170]=8, [180]=10, [190]=17, [200]=24, [210]=6, [220]=19, [230]=19, [240]=4, [250]=2, [260]=2, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 509,
	lifetime_jp = 10546,
}

ECS.Players["ZoG-"] = {
	id=66664,
	isupper=false,
	country="Finland",
	level=75,
	exp=405001,
	relics = {
		{name="Stone Arrow",	quantity=3},
		{name="Astral Earring",	quantity=2},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=58, [200]=23, [210]=7, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=419, rp=0, ap=0},
	lifetime_song_gold = 9857,
	lifetime_jp = 0,
}

ECS.Players["TroyNK"] = {
	id=1129,
	isupper=false,
	country="U.S.A.",
	level=80,
	exp=616691,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=2},
		{name="Bronze Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=97, [200]=46, [210]=16, [220]=5, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=161, ep=162, rp=161, ap=0},
	lifetime_song_gold = 1075,
	lifetime_jp = 0,
}

ECS.Players["Nebel"] = {
	id=5843,
	isupper=false,
	country="U.S.A.",
	level=75,
	exp=405755,
	relics = {
		{name="Bronze Arrow",	quantity=6},
		{name="Astral Earring",	quantity=3},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pandemonium",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=85, [190]=36, [200]=21, [210]=13, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=50, ep=119, rp=150, ap=100},
	lifetime_song_gold = 27624,
	lifetime_jp = 21,
}

ECS.Players["JOKR"] = {
	id=1037,
	isupper=false,
	country="U.S.A.",
	level=78,
	exp=522603,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Arrow",	quantity=8},
		{name="Bronze Blade",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Regal Cutlass",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Lon Lon Cheese",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=43, [140]=31, [150]=56, [160]=47, [170]=66, [180]=56, [190]=81, [200]=61, [210]=36, [220]=13, [230]=4, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=458, ap=0},
	lifetime_song_gold = 19260,
	lifetime_jp = 0,
}

ECS.Players["PochoITG"] = {
	id=58407,
	isupper=false,
	country="Chile",
	level=73,
	exp=343007,
	relics = {
		{name="Mythril Arrow",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=13, [150]=36, [160]=25, [170]=52, [180]=23, [190]=36, [200]=30, [210]=21, [220]=18, [230]=7, [240]=2, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 18607,
	lifetime_jp = 168,
}

ECS.Players["Keaize"] = {
	id=66660,
	isupper=false,
	country="U.S.A.",
	level=76,
	exp=457486,
	relics = {
		{name="Mythril Blade",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=71, [200]=38, [210]=13, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 35226,
	lifetime_jp = 0,
}

ECS.Players["poog"] = {
	id=7924,
	isupper=false,
	country="U.S.A.",
	level=77,
	exp=482002,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=80, [190]=57, [200]=31, [210]=12, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 489,
	lifetime_jp = 0,
}

ECS.Players["ICTtoken"] = {
	id=6502,
	isupper=false,
	country="U.S.A.",
	level=79,
	exp=562647,
	relics = {
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Mythril Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=95, [180]=90, [190]=68, [200]=37, [210]=25, [220]=7, [230]=7, [240]=4, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1114,
	lifetime_jp = 522,
}

ECS.Players["rayword45"] = {
	id=45603,
	isupper=false,
	country="U.S.A.",
	level=74,
	exp=387247,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=56, [200]=15, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3457,
	lifetime_jp = 0,
}

ECS.Players["lolipo"] = {
	id=35701,
	isupper=false,
	country="U.S.A.",
	level=68,
	exp=223676,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=49, [170]=50, [180]=32, [190]=43, [200]=10, [210]=3, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 20550,
	lifetime_jp = 0,
}

ECS.Players["Freyja"] = {
	id=49444,
	isupper=false,
	country="U.S.A.",
	level=74,
	exp=376184,
	relics = {
		{name="Crystal Sword",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=47, [200]=8, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=157, rp=0, ap=250},
	lifetime_song_gold = 24700,
	lifetime_jp = 0,
}

ECS.Players["Xynn"] = {
	id=7385,
	isupper=false,
	country="U.S.A.",
	level=74,
	exp=361711,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Bronze Arrow",	quantity=2},
		{name="Mythril Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=90, [190]=47, [200]=12, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=407, rp=0, ap=0},
	lifetime_song_gold = 21834,
	lifetime_jp = 0,
}

ECS.Players["VincentITG"] = {
	id=65671,
	isupper=false,
	country="U.S.A.",
	level=72,
	exp=305908,
	relics = {
		{name="Stone Arrow",	quantity=3},
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Arrow",	quantity=3},
		{name="Mythril Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=86, [140]=65, [150]=76, [160]=48, [170]=61, [180]=41, [190]=30, [200]=15, [210]=14, [220]=11, [230]=4, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=134, ep=57, rp=57, ap=135},
	lifetime_song_gold = 24338,
	lifetime_jp = 77,
}

ECS.Players["fidelitg"] = {
	id=66704,
	isupper=false,
	country="Chile",
	level=80,
	exp=628559,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=8},
		{name="Bronze Blade",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Lance of Longinus",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=96, [180]=99, [190]=78, [200]=35, [210]=16, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 32469,
	lifetime_jp = 0,
}

ECS.Players["Loak"] = {
	id=44927,
	isupper=false,
	country="U.S.A.",
	level=77,
	exp=487617,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Carolingian Sword",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Eurytus Bow",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=69, [200]=39, [210]=18, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 29298,
	lifetime_jp = 0,
}

ECS.Players["Jboy.VictoryDance"] = {
	id=633,
	isupper=false,
	country="U.S.A.",
	level=74,
	exp=367229,
	relics = {
		{name="Stone Arrow",	quantity=7},
		{name="Bronze Arrow",	quantity=5},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=54, [190]=50, [200]=20, [210]=6, [220]=5, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=383, rp=0, ap=0},
	lifetime_song_gold = 9747,
	lifetime_jp = 0,
}

ECS.Players["Okami"] = {
	id=66509,
	isupper=false,
	country="France",
	level=69,
	exp=242473,
	relics = {
		{name="Stone Arrow",	quantity=27},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Shuriken",	quantity=3},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=32, [150]=43, [160]=44, [170]=22, [180]=26, [190]=27, [200]=18, [210]=17, [220]=11, [230]=8, [240]=2, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 14698,
	lifetime_jp = 91,
}

ECS.Players["Yuzu"] = {
	id=104911,
	isupper=false,
	country="Japan",
	level=75,
	exp=394653,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=92, [190]=61, [200]=27, [210]=7, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8367,
	lifetime_jp = 0,
}

ECS.Players["Kev!"] = {
	id=75618,
	isupper=false,
	country="U.S.A.",
	level=65,
	exp=167665,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=44, [150]=13, [160]=22, [170]=32, [180]=17, [190]=53, [200]=7, [210]=8, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9355,
	lifetime_jp = 0,
}

ECS.Players["itgaz"] = {
	id=66662,
	isupper=false,
	country="United Kingdom",
	level=72,
	exp=314346,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=63, [140]=30, [150]=84, [160]=59, [170]=48, [180]=27, [190]=34, [200]=29, [210]=23, [220]=7, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 15657,
	lifetime_jp = 0,
}

ECS.Players["artimst"] = {
	id=78743,
	isupper=false,
	country="U.S.A.",
	level=63,
	exp=149379,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=62, [140]=17, [150]=12, [160]=25, [170]=51, [180]=23, [190]=19, [200]=12, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3377,
	lifetime_jp = 0,
}

ECS.Players["Uiichi"] = {
	id=66653,
	isupper=false,
	country="U.S.A.",
	level=61,
	exp=122872,
	relics = {
		{name="Long Bow",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=28, [140]=8, [150]=19, [160]=26, [170]=16, [180]=23, [190]=25, [200]=10, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 521,
	lifetime_jp = 0,
}

ECS.Players["YUNGJONXLORDEOFITGSTAMINA"] = {
	id=133830,
	isupper=false,
	country="U.S.A.",
	level=59,
	exp=107998,
	relics = {
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Champion Belt",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=4, [140]=9, [150]=5, [160]=16, [170]=36, [180]=10, [190]=6, [200]=8, [210]=4, [220]=2, [230]=2, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5348,
	lifetime_jp = 0,
}

ECS.Players["AMOG"] = {
	id=133808,
	isupper=false,
	country="Unspecified",
	level=60,
	exp=111607,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=33, [150]=24, [160]=41, [170]=9, [180]=25, [190]=15, [200]=11, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1394,
	lifetime_jp = 0,
}

ECS.Players["Sefirot"] = {
	id=66400,
	isupper=false,
	country="Japan",
	level=69,
	exp=252715,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=53, [140]=30, [150]=71, [160]=48, [170]=26, [180]=38, [190]=43, [200]=31, [210]=11, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4104,
	lifetime_jp = 0,
}

ECS.Players["Fietsemaker"] = {
	id=66575,
	isupper=false,
	country="Netherlands",
	level=72,
	exp=325971,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
		{name="Golden Stopwatch",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=44, [160]=41, [170]=43, [180]=18, [190]=10, [200]=23, [210]=7, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3022,
	lifetime_jp = 0,
}

ECS.Players["garichimist"] = {
	id=77575,
	isupper=false,
	country="Chile",
	level=56,
	exp=83431,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=2, [150]=16, [160]=7, [170]=2, [180]=14, [190]=19, [200]=10, [210]=5, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1508,
	lifetime_jp = 0,
}

ECS.Players["Cozy"] = {
	id=73458,
	isupper=false,
	country="U.S.A.",
	level=67,
	exp=213178,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=69, [150]=99, [160]=59, [170]=71, [180]=43, [190]=22, [200]=9, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11583,
	lifetime_jp = 0,
}

ECS.Players["dj Maki"] = {
	id=66793,
	isupper=false,
	country="U.S.A.",
	level=77,
	exp=470104,
	relics = {
		{name="Astral Earring",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=90, [190]=56, [200]=22, [210]=6, [220]=7, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=7, ep=7, rp=7, ap=7},
	lifetime_song_gold = 4677,
	lifetime_jp = 130,
}

ECS.Players["yutsi"] = {
	id=97270,
	isupper=false,
	country="U.S.A.",
	level=70,
	exp=257785,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Arrow",	quantity=23},
		{name="Bronze Arrow",	quantity=2},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=76, [170]=96, [180]=74, [190]=35, [200]=11, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=359, rp=0, ap=0},
	lifetime_song_gold = 5538,
	lifetime_jp = 0,
}

ECS.Players["Steve_V"] = {
	id=3631,
	isupper=false,
	country="Canada",
	level=73,
	exp=337633,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=98, [180]=64, [190]=39, [200]=12, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=10, ep=73, rp=10, ap=10},
	lifetime_song_gold = 1638,
	lifetime_jp = 0,
}

ECS.Players["goodbye"] = {
	id=128330,
	isupper=false,
	country="Unspecified",
	level=62,
	exp=131692,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Bronze Arrow",	quantity=2},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Pendulum Blade",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=41, [140]=19, [150]=22, [160]=42, [170]=61, [180]=21, [190]=19, [200]=9, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=50, ep=50, rp=124, ap=50},
	lifetime_song_gold = 7666,
	lifetime_jp = 0,
}

ECS.Players["Electromuis"] = {
	id=77168,
	isupper=false,
	country="Netherlands",
	level=67,
	exp=211021,
	relics = {
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=23, [130]=10, [140]=5, [150]=51, [160]=23, [170]=47, [180]=15, [190]=28, [200]=31, [210]=14, [220]=5, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1203,
	lifetime_jp = 0,
}

ECS.Players["RAN.S"] = {
	id=113250,
	isupper=false,
	country="Japan",
	level=65,
	exp=175590,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=53, [140]=26, [150]=73, [160]=53, [170]=70, [180]=50, [190]=25, [200]=7, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10946,
	lifetime_jp = 0,
}

ECS.Players["B3NS3X"] = {
	id=2593,
	isupper=false,
	country="Canada",
	level=62,
	exp=134797,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=23, [130]=36, [140]=40, [150]=38, [160]=8, [170]=34, [180]=20, [190]=14, [200]=7, [210]=3, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10120,
	lifetime_jp = 0,
}

ECS.Players["kelly_kato"] = {
	id=66413,
	isupper=false,
	country="Russian Federation",
	level=69,
	exp=244068,
	relics = {
		{name="Stone Arrow",	quantity=6},
		{name="Bronze Arrow",	quantity=7},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=83, [180]=48, [190]=29, [200]=11, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=348, rp=0, ap=0},
	lifetime_song_gold = 15498,
	lifetime_jp = 0,
}

ECS.Players["tum"] = {
	id=137326,
	isupper=false,
	country="Australia",
	level=71,
	exp=292174,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=55, [190]=34, [200]=14, [210]=4, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1746,
	lifetime_jp = 0,
}

ECS.Players["arol-nobar"] = {
	id=127752,
	isupper=false,
	country="U.S.A.",
	level=72,
	exp=304947,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=83, [160]=77, [170]=78, [180]=41, [190]=37, [200]=24, [210]=8, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5474,
	lifetime_jp = 0,
}

ECS.Players["Janus5k"] = {
	id=8349,
	isupper=false,
	country="U.S.A.",
	level=68,
	exp=235116,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Mythril Axe",	quantity=1},
		{name="Shuriken",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=94, [170]=81, [180]=57, [190]=24, [200]=12, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=120, rp=97, ap=120},
	lifetime_song_gold = 23470,
	lifetime_jp = 0,
}

ECS.Players["Doughbun"] = {
	id=91630,
	isupper=false,
	country="U.S.A.",
	level=49,
	exp=44594,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=4, [180]=1, [190]=3, [200]=4, [210]=1, [220]=2, [230]=4, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 605,
	lifetime_jp = 0,
}

ECS.Players["FranITG"] = {
	id=31669,
	isupper=false,
	country="Chile",
	level=72,
	exp=326071,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=2},
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=73, [190]=37, [200]=10, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11936,
	lifetime_jp = 0,
}

ECS.Players["L3andr0ITG"] = {
	id=78966,
	isupper=false,
	country="Chile",
	level=65,
	exp=180665,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=57, [130]=33, [140]=47, [150]=38, [160]=45, [170]=77, [180]=50, [190]=33, [200]=10, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 18290,
	lifetime_jp = 0,
}

ECS.Players["diablos"] = {
	id=77740,
	isupper=false,
	country="France",
	level=69,
	exp=239702,
	relics = {
		{name="Mythril Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=96, [150]=99, [160]=97, [170]=97, [180]=56, [190]=25, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=60, ep=100, rp=60, ap=117},
	lifetime_song_gold = 25256,
	lifetime_jp = 0,
}

ECS.Players["no bar"] = {
	id=129469,
	isupper=false,
	country="Australia",
	level=60,
	exp=114763,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=91, [140]=70, [150]=48, [160]=32, [170]=34, [180]=22, [190]=16, [200]=11, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11304,
	lifetime_jp = 0,
}

ECS.Players["PkGam"] = {
	id=66753,
	isupper=false,
	country="U.S.A.",
	level=72,
	exp=302976,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=2},
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Shuriken",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=87, [180]=86, [190]=43, [200]=16, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 19806,
	lifetime_jp = 0,
}

ECS.Players["iGoCollege"] = {
	id=66352,
	isupper=false,
	country="U.S.A.",
	level=70,
	exp=263816,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Sword, Made of Steel",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=37, [150]=49, [160]=56, [170]=81, [180]=71, [190]=48, [200]=19, [210]=3, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 31951,
	lifetime_jp = 0,
}

ECS.Players["IHYD.JJK"] = {
	id=62,
	isupper=false,
	country="U.S.A.",
	level=70,
	exp=261820,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=45, [190]=19, [200]=14, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 15874,
	lifetime_jp = 0,
}

ECS.Players["Sereni"] = {
	id=66364,
	isupper=false,
	country="Russian Federation",
	level=69,
	exp=236005,
	relics = {
		{name="Bronze Arrow",	quantity=6},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=89, [180]=54, [190]=29, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=348, rp=0, ap=0},
	lifetime_song_gold = 17733,
	lifetime_jp = 0,
}

ECS.Players["Platinum"] = {
	id=66215,
	isupper=false,
	country="U.S.A.",
	level=54,
	exp=67383,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=3, [150]=10, [160]=4, [170]=19, [180]=12, [190]=5, [200]=4, [210]=4, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2368,
	lifetime_jp = 0,
}

ECS.Players["Zeipher_Hawk"] = {
	id=66726,
	isupper=false,
	country="U.S.A.",
	level=67,
	exp=211960,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=96, [150]=99, [160]=99, [170]=52, [180]=39, [190]=25, [200]=8, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11694,
	lifetime_jp = 0,
}

ECS.Players["LOG"] = {
	id=66603,
	isupper=false,
	country="Japan",
	level=67,
	exp=216085,
	relics = {
		{name="Astral Earring",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=95, [160]=85, [170]=99, [180]=50, [190]=12, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 16084,
	lifetime_jp = 0,
}

ECS.Players["Badjas"] = {
	id=66701,
	isupper=false,
	country="Netherlands",
	level=69,
	exp=237061,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Flamberge",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=44, [190]=23, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12825,
	lifetime_jp = 0,
}

ECS.Players["teejusb"] = {
	id=50287,
	isupper=false,
	country="U.S.A.",
	level=65,
	exp=178721,
	relics = {
		{name="Stone Arrow",	quantity=7},
		{name="Bronze Arrow",	quantity=6},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=84, [180]=22, [190]=8, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=304, rp=0, ap=0},
	lifetime_song_gold = 13950,
	lifetime_jp = 0,
}

ECS.Players["SirDelins"] = {
	id=127205,
	isupper=false,
	country="U.S.A.",
	level=69,
	exp=239656,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Epee",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=82, [180]=60, [190]=30, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=50, ep=238, rp=30, ap=30},
	lifetime_song_gold = 5463,
	lifetime_jp = 0,
}

ECS.Players["titandude21"] = {
	id=4400,
	isupper=false,
	country="U.S.A.",
	level=68,
	exp=224134,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=80, [160]=44, [170]=49, [180]=34, [190]=11, [200]=8, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8770,
	lifetime_jp = 0,
}

ECS.Players["Cyxsound"] = {
	id=129083,
	isupper=false,
	country="Canada",
	level=68,
	exp=221467,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=94, [180]=43, [190]=22, [200]=9, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8611,
	lifetime_jp = 0,
}

ECS.Players["RiOdO"] = {
	id=1964,
	isupper=false,
	country="U.S.A.",
	level=61,
	exp=122543,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=48, [140]=31, [150]=45, [160]=47, [170]=65, [180]=26, [190]=13, [200]=7, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 19440,
	lifetime_jp = 0,
}

ECS.Players["Raijin29a6"] = {
	id=127933,
	isupper=false,
	country="U.S.A.",
	level=53,
	exp=60599,
	relics = {
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=3, [140]=1, [150]=6, [160]=8, [170]=24, [180]=16, [190]=18, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1687,
	lifetime_jp = 0,
}

ECS.Players["zxevik"] = {
	id=12,
	isupper=false,
	country="U.S.A.",
	level=67,
	exp=200301,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=68, [140]=29, [150]=26, [160]=39, [170]=47, [180]=17, [190]=28, [200]=16, [210]=4, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9786,
	lifetime_jp = 0,
}

ECS.Players["Snooze"] = {
	id=75988,
	isupper=false,
	country="U.S.A.",
	level=65,
	exp=167898,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=35, [140]=40, [150]=72, [160]=74, [170]=85, [180]=34, [190]=16, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3250,
	lifetime_jp = 0,
}

ECS.Players["TYLR"] = {
	id=6915,
	isupper=false,
	country="U.S.A.",
	level=52,
	exp=56828,
	relics = {
		{name="Astral Earring",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=18, [140]=2, [150]=1, [160]=10, [170]=22, [180]=16, [190]=5, [200]=5, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4651,
	lifetime_jp = 0,
}

ECS.Players["Fanion"] = {
	id=66385,
	isupper=false,
	country="France",
	level=69,
	exp=237284,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=81, [180]=53, [190]=17, [200]=8, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7238,
	lifetime_jp = 0,
}

ECS.Players["jimmydeanhimself"] = {
	id=127858,
	isupper=false,
	country="U.S.A.",
	level=68,
	exp=229325,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=84, [170]=70, [180]=33, [190]=13, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 13517,
	lifetime_jp = 0,
}

ECS.Players["pinguu"] = {
	id=46624,
	isupper=false,
	country="France",
	level=52,
	exp=54926,
	relics = {
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=21, [140]=7, [150]=9, [160]=13, [170]=33, [180]=14, [190]=7, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2593,
	lifetime_jp = 0,
}

ECS.Players["9V"] = {
	id=3610,
	isupper=false,
	country="U.S.A.",
	level=62,
	exp=139447,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Bronze Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=59, [150]=62, [160]=41, [170]=52, [180]=25, [190]=8, [200]=9, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=264},
	lifetime_song_gold = 17363,
	lifetime_jp = 0,
}

ECS.Players["UK.s34n"] = {
	id=483,
	isupper=false,
	country="United Kingdom",
	level=52,
	exp=54580,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=1, [140]=23, [150]=15, [160]=17, [170]=15, [180]=6, [190]=1, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1380,
	lifetime_jp = 0,
}

ECS.Players["aeubanks"] = {
	id=77372,
	isupper=false,
	country="U.S.A.",
	level=59,
	exp=100268,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=6, [140]=1, [150]=17, [160]=26, [170]=31, [180]=27, [190]=20, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2618,
	lifetime_jp = 0,
}

ECS.Players["Redzone"] = {
	id=66652,
	isupper=false,
	country="U.S.A.",
	level=53,
	exp=60458,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=19, [140]=7, [150]=20, [160]=35, [170]=27, [180]=15, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3569,
	lifetime_jp = 0,
}

ECS.Players["Rems"] = {
	id=66383,
	isupper=false,
	country="France",
	level=57,
	exp=89828,
	relics = {
		{name="Spike Knuckles",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=26, [150]=22, [160]=13, [170]=44, [180]=15, [190]=7, [200]=6, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4533,
	lifetime_jp = 0,
}

ECS.Players["PrawnSkunk"] = {
	id=76070,
	isupper=false,
	country="Canada",
	level=64,
	exp=160486,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=78, [180]=26, [190]=14, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5690,
	lifetime_jp = 0,
}

ECS.Players["BenouKat"] = {
	id=66710,
	isupper=false,
	country="France",
	level=68,
	exp=217338,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=88, [170]=74, [180]=39, [190]=16, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=155, rp=0, ap=0},
	lifetime_song_gold = 3693,
	lifetime_jp = 0,
}

ECS.Players["jeshusha1"] = {
	id=66661,
	isupper=false,
	country="Chile",
	level=57,
	exp=83867,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Maxim Tomato",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=37, [150]=29, [160]=33, [170]=21, [180]=11, [190]=10, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3278,
	lifetime_jp = 77,
}

ECS.Players["CLINTBEASTWOOD"] = {
	id=1087,
	isupper=false,
	country="U.S.A.",
	level=62,
	exp=136435,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=69, [150]=80, [160]=52, [170]=34, [180]=17, [190]=7, [200]=5, [210]=6, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=87},
	lifetime_song_gold = 18877,
	lifetime_jp = 0,
}

ECS.Players["aminuteawayx"] = {
	id=66674,
	isupper=false,
	country="U.S.A.",
	level=63,
	exp=148167,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=58, [180]=21, [190]=6, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=200, rp=84, ap=0},
	lifetime_song_gold = 4623,
	lifetime_jp = 0,
}

ECS.Players["CocoaFox"] = {
	id=75743,
	isupper=false,
	country="U.S.A.",
	level=59,
	exp=107713,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=75, [150]=91, [160]=56, [170]=36, [180]=12, [190]=11, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=16, ep=100, rp=93, ap=0},
	lifetime_song_gold = 14402,
	lifetime_jp = 0,
}

ECS.Players["MCXR1987"] = {
	id=66621,
	isupper=false,
	country="Colombia",
	level=59,
	exp=108141,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Shards of Narsil",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=55, [170]=44, [180]=6, [190]=1, [200]=1, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11091,
	lifetime_jp = 0,
}

ECS.Players["Scanline"] = {
	id=111503,
	isupper=false,
	country="Canada",
	level=54,
	exp=66407,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=85, [140]=63, [150]=40, [160]=22, [170]=34, [180]=9, [190]=6, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 912,
	lifetime_jp = 0,
}

ECS.Players["hk"] = {
	id=77437,
	isupper=false,
	country="Finland",
	level=60,
	exp=118169,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Fire Lash",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Vampire Killer",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=36, [180]=8, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=254, rp=0, ap=0},
	lifetime_song_gold = 1276,
	lifetime_jp = 0,
}

ECS.Players["DarkGobow"] = {
	id=66491,
	isupper=false,
	country="Japan",
	level=54,
	exp=65632,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=56, [150]=57, [160]=31, [170]=32, [180]=7, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1899,
	lifetime_jp = 0,
}

ECS.Players["sigeru03"] = {
	id=132343,
	isupper=false,
	country="Japan",
	level=55,
	exp=72955,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=65, [140]=29, [150]=20, [160]=31, [170]=23, [180]=15, [190]=7, [200]=6, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7932,
	lifetime_jp = 0,
}

ECS.Players["phnix"] = {
	id=128039,
	isupper=false,
	country="U.S.A.",
	level=58,
	exp=93493,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=80, [140]=74, [150]=61, [160]=29, [170]=48, [180]=9, [190]=7, [200]=2, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 15283,
	lifetime_jp = 0,
}

ECS.Players["Behy"] = {
	id=66693,
	isupper=false,
	country="Netherlands",
	level=60,
	exp=111450,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=54, [150]=44, [160]=26, [170]=31, [180]=14, [190]=15, [200]=8, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=20, ep=15, rp=10, ap=70},
	lifetime_song_gold = 8692,
	lifetime_jp = 0,
}

ECS.Players["koppepan"] = {
	id=133800,
	isupper=false,
	country="Japan",
	level=56,
	exp=77948,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=99, [140]=99, [150]=53, [160]=45, [170]=48, [180]=8, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5230,
	lifetime_jp = 0,
}

ECS.Players["pingsn"] = {
	id=132456,
	isupper=false,
	country="U.S.A.",
	level=45,
	exp=28881,
	relics = {
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=44, [130]=27, [140]=3, [150]=10, [160]=1, [170]=2, [180]=6, [190]=10, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 715,
	lifetime_jp = 0,
}

ECS.Players["Vince_V"] = {
	id=127775,
	isupper=false,
	country="Canada",
	level=61,
	exp=120952,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=58, [130]=99, [140]=99, [150]=99, [160]=72, [170]=40, [180]=16, [190]=8, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=86, ep=178, rp=0, ap=0},
	lifetime_song_gold = 566,
	lifetime_jp = 0,
}

ECS.Players["Collin"] = {
	id=80478,
	isupper=false,
	country="Sweden",
	level=61,
	exp=123483,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=65, [170]=57, [180]=15, [190]=11, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 53,
	lifetime_jp = 0,
}

ECS.Players["Unspecified "] = {
	id=66665,
	isupper=false,
	country="Spain",
	level=63,
	exp=148745,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=87, [160]=66, [170]=55, [180]=24, [190]=14, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8716,
	lifetime_jp = 0,
}

ECS.Players["IKA3K"] = {
	id=66302,
	isupper=false,
	country="Japan",
	level=64,
	exp=159897,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Long Bow",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=44, [150]=73, [160]=47, [170]=36, [180]=27, [190]=18, [200]=9, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=40, ep=100, rp=100, ap=54},
	lifetime_song_gold = 9433,
	lifetime_jp = 0,
}

ECS.Players["Jerros"] = {
	id=66565,
	isupper=false,
	country="Netherlands",
	level=58,
	exp=99336,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Kladenets",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=90, [170]=18, [180]=7, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 228,
	lifetime_jp = 475,
}

ECS.Players["ChiefSkittles"] = {
	id=66673,
	isupper=false,
	country="U.S.A.",
	level=56,
	exp=80937,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=81, [140]=77, [150]=39, [160]=52, [170]=20, [180]=16, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=25, ep=70, rp=10, ap=72},
	lifetime_song_gold = 6710,
	lifetime_jp = 0,
}

ECS.Players["Narwhal Prime"] = {
	id=76913,
	isupper=false,
	country="U.S.A.",
	level=62,
	exp=135783,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Shuriken",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=69, [170]=42, [180]=18, [190]=9, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=80, ep=80, rp=80, ap=34},
	lifetime_song_gold = 3989,
	lifetime_jp = 0,
}

ECS.Players["andkaseywaslike"] = {
	id=75738,
	isupper=false,
	country="U.S.A.",
	level=52,
	exp=54992,
	relics = {
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=26, [140]=21, [150]=54, [160]=17, [170]=20, [180]=5, [190]=2, [200]=2, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5043,
	lifetime_jp = 0,
}

ECS.Players["eltigrechino"] = {
	id=127794,
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=45171,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=44, [150]=18, [160]=10, [170]=18, [180]=8, [190]=3, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5482,
	lifetime_jp = 0,
}

ECS.Players["tommoda"] = {
	id=132032,
	isupper=false,
	country="United Kingdom",
	level=59,
	exp=103706,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=84, [170]=36, [180]=12, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 999,
	lifetime_jp = 0,
}

ECS.Players["felipeils"] = {
	id=35566,
	isupper=false,
	country="Chile",
	level=55,
	exp=71248,
	relics = {
		{name="Bronze Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=84, [140]=63, [150]=53, [160]=74, [170]=22, [180]=7, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=45, ep=146, rp=0, ap=10},
	lifetime_song_gold = 4384,
	lifetime_jp = 0,
}

ECS.Players["HOT TAKE"] = {
	id=66784,
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=48269,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=81, [140]=34, [150]=27, [160]=19, [170]=33, [180]=5, [190]=1, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3987,
	lifetime_jp = 0,
}

ECS.Players["ITGRyan"] = {
	id=77581,
	isupper=false,
	country="U.S.A.",
	level=48,
	exp=39051,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=52, [150]=24, [160]=31, [170]=12, [180]=5, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7800,
	lifetime_jp = 0,
}

ECS.Players["Nato"] = {
	id=66765,
	isupper=false,
	country="U.S.A.",
	level=58,
	exp=98048,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=94, [150]=98, [160]=81, [170]=37, [180]=15, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2796,
	lifetime_jp = 0,
}

ECS.Players["Gloves"] = {
	id=135481,
	isupper=false,
	country="U.S.A.",
	level=45,
	exp=31213,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=3, [140]=22, [150]=29, [160]=13, [170]=15, [180]=2, [190]=4, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4654,
	lifetime_jp = 0,
}

ECS.Players["implode"] = {
	id=66760,
	isupper=false,
	country="U.S.A.",
	level=51,
	exp=52540,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=30, [150]=30, [160]=52, [170]=29, [180]=1, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3805,
	lifetime_jp = 0,
}

ECS.Players["tororo_kelp"] = {
	id=75784,
	isupper=false,
	country="Unspecified",
	level=55,
	exp=75496,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=67, [140]=51, [150]=67, [160]=28, [170]=26, [180]=13, [190]=13, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12718,
	lifetime_jp = 0,
}

ECS.Players["FwAnkY_BouY"] = {
	id=6314,
	isupper=false,
	country="Canada",
	level=62,
	exp=130421,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
		{name="Stamina Potion",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=68, [170]=37, [180]=20, [190]=10, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=124, ep=50, rp=0, ap=100},
	lifetime_song_gold = 17089,
	lifetime_jp = 0,
}

ECS.Players["DoomLord76 "] = {
	id=72331,
	isupper=false,
	country="Unspecified",
	level=50,
	exp=45799,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=24, [150]=44, [160]=35, [170]=7, [180]=6, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=25, ep=70, rp=25, ap=21},
	lifetime_song_gold = 757,
	lifetime_jp = 0,
}

ECS.Players["Funsize Twix"] = {
	id=6284,
	isupper=false,
	country="U.S.A.",
	level=53,
	exp=60643,
	relics = {
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=17, [150]=44, [160]=21, [170]=31, [180]=11, [190]=6, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9154,
	lifetime_jp = 0,
}

ECS.Players["midge"] = {
	id=127783,
	isupper=false,
	country="U.S.A.",
	level=59,
	exp=100732,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=89, [150]=68, [160]=63, [170]=35, [180]=14, [190]=6, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3651,
	lifetime_jp = 0,
}

ECS.Players["Senture"] = {
	id=38711,
	isupper=false,
	country="United Kingdom",
	level=52,
	exp=57097,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=56, [140]=51, [150]=38, [160]=15, [170]=21, [180]=5, [190]=4, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6519,
	lifetime_jp = 0,
}

ECS.Players["Zig Steenine"] = {
	id=127850,
	isupper=false,
	country="U.S.A.",
	level=45,
	exp=30209,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=19, [150]=8, [160]=9, [170]=4, [180]=1, [190]=1, [200]=3, [210]=1, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2846,
	lifetime_jp = 1219,
}

ECS.Players["ensypuri"] = {
	id=66782,
	isupper=false,
	country="U.S.A.",
	level=42,
	exp=23440,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=57, [130]=9, [140]=5, [150]=16, [160]=18, [170]=8, [180]=3, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 233,
	lifetime_jp = 0,
}

ECS.Players["Kigha"] = {
	id=7843,
	isupper=false,
	country="U.S.A.",
	level=44,
	exp=28063,
	relics = {
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=3, [140]=5, [150]=1, [160]=4, [170]=10, [180]=1, [190]=1, [200]=2, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 446,
	lifetime_jp = 0,
}

ECS.Players["pie"] = {
	id=66715,
	isupper=false,
	country="U.S.A.",
	level=44,
	exp=27831,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=36, [140]=5, [150]=28, [160]=20, [170]=14, [180]=6, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5060,
	lifetime_jp = 0,
}

ECS.Players["Kyy"] = {
	id=66690,
	isupper=false,
	country="Finland",
	level=56,
	exp=82519,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=67, [140]=39, [150]=44, [160]=32, [170]=25, [180]=15, [190]=11, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=180, ep=38, rp=0, ap=0},
	lifetime_song_gold = 267,
	lifetime_jp = 0,
}

ECS.Players["UMECCY"] = {
	id=128069,
	isupper=false,
	country="Japan",
	level=49,
	exp=42087,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Bronze Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=70, [150]=34, [160]=14, [170]=21, [180]=3, [190]=1, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7994,
	lifetime_jp = 0,
}

ECS.Players["AMBONES"] = {
	id=77316,
	isupper=false,
	country="U.S.A.",
	level=60,
	exp=109016,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=2},
		{name="Bronze Blade",	quantity=1},
		{name="Bronze Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=65, [170]=37, [180]=15, [190]=8, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=55, ep=55, rp=30, ap=87},
	lifetime_song_gold = 14050,
	lifetime_jp = 0,
}

ECS.Players["Valex"] = {
	id=37977,
	isupper=false,
	country="U.S.A.",
	level=54,
	exp=65013,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Steel Wheat Bun",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=41, [140]=44, [150]=51, [160]=26, [170]=28, [180]=12, [190]=5, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1530,
	lifetime_jp = 0,
}

ECS.Players["dlim"] = {
	id=134773,
	isupper=false,
	country="U.S.A.",
	level=55,
	exp=71864,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=64, [170]=18, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5986,
	lifetime_jp = 0,
}

ECS.Players["ItsBrittney"] = {
	id=66749,
	isupper=false,
	country="U.S.A.",
	level=54,
	exp=69336,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=56, [170]=13, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3449,
	lifetime_jp = 0,
}

ECS.Players["DF.Dark Xuxa"] = {
	id=2643,
	isupper=false,
	country="U.S.A.",
	level=48,
	exp=40256,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=37, [150]=16, [160]=11, [170]=8, [180]=5, [190]=4, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6323,
	lifetime_jp = 0,
}

ECS.Players["KU-KI"] = {
	id=133775,
	isupper=false,
	country="Japan",
	level=43,
	exp=23729,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=57, [130]=1, [140]=7, [150]=9, [160]=9, [170]=18, [180]=7, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2371,
	lifetime_jp = 0,
}

ECS.Players["plasmaaa"] = {
	id=78677,
	isupper=false,
	country="U.S.A.",
	level=54,
	exp=67817,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=54, [170]=13, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=201, rp=0, ap=0},
	lifetime_song_gold = 1044,
	lifetime_jp = 0,
}

ECS.Players["Telperion"] = {
	id=34196,
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=48061,
	relics = {
		{name="Astral Earring",	quantity=1},
		{name="Silver Stopwatch",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=31, [140]=31, [150]=65, [160]=31, [170]=15, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=100, rp=0, ap=69},
	lifetime_song_gold = 7148,
	lifetime_jp = 0,
}

ECS.Players["Exsight"] = {
	id=66729,
	isupper=false,
	country="France",
	level=48,
	exp=39702,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=45, [140]=37, [150]=18, [160]=22, [170]=22, [180]=10, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6494,
	lifetime_jp = 0,
}

ECS.Players["sangyule"] = {
	id=77631,
	isupper=false,
	country="U.S.A.",
	level=53,
	exp=59585,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=62, [150]=87, [160]=45, [170]=19, [180]=6, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4923,
	lifetime_jp = 0,
}

ECS.Players["Sal!"] = {
	id=8459,
	isupper=false,
	country="U.S.A.",
	level=52,
	exp=53992,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=89, [150]=65, [160]=26, [170]=14, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7155,
	lifetime_jp = 0,
}

ECS.Players["FURYU"] = {
	id=75689,
	isupper=false,
	country="Japan",
	level=47,
	exp=34757,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=73, [140]=49, [150]=31, [160]=29, [170]=17, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7345,
	lifetime_jp = 0,
}

ECS.Players["DarwynHyena"] = {
	id=129324,
	isupper=false,
	country="U.S.A.",
	level=43,
	exp=25939,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=7, [140]=1, [150]=1, [160]=8, [170]=9, [180]=2, [190]=1, [200]=1, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1437,
	lifetime_jp = 0,
}

ECS.Players["Scooter"] = {
	id=66797,
	isupper=false,
	country="U.S.A.",
	level=52,
	exp=57950,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=55, [140]=61, [150]=45, [160]=28, [170]=19, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1982,
	lifetime_jp = 0,
}

ECS.Players["GreatDameCygnus"] = {
	id=128280,
	isupper=false,
	country="U.S.A.",
	level=55,
	exp=72068,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=38, [170]=24, [180]=9, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=5, ep=10, rp=5, ap=128},
	lifetime_song_gold = 8497,
	lifetime_jp = 0,
}

ECS.Players["Amoo"] = {
	id=132065,
	isupper=false,
	country="U.S.A.",
	level=56,
	exp=81752,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Samosek",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=35, [170]=26, [180]=10, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=40, ep=100, rp=28, ap=50},
	lifetime_song_gold = 4888,
	lifetime_jp = 0,
}

ECS.Players["Yakid20"] = {
	id=136924,
	isupper=false,
	country="U.S.A.",
	level=38,
	exp=15898,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=4, [140]=10, [150]=12, [160]=2, [170]=11, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 465,
	lifetime_jp = 0,
}

ECS.Players["PRKrono"] = {
	id=75974,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=17308,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=16, [160]=7, [170]=6, [180]=4, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2743,
	lifetime_jp = 0,
}

ECS.Players["dancingmaractus"] = {
	id=127797,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=17761,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=1, [140]=15, [150]=13, [160]=9, [170]=10, [180]=4, [190]=4, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2474,
	lifetime_jp = 0,
}

ECS.Players["LordOmega"] = {
	id=66555,
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=44962,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=63, [150]=45, [160]=26, [170]=15, [180]=4, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1195,
	lifetime_jp = 0,
}

ECS.Players["mrtong96"] = {
	id=137853,
	isupper=false,
	country="U.S.A.",
	level=47,
	exp=37017,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=60, [140]=65, [150]=50, [160]=28, [170]=10, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=148, rp=0, ap=0},
	lifetime_song_gold = 1958,
	lifetime_jp = 0,
}

ECS.Players["Stamina Warrior"] = {
	id=75801,
	isupper=false,
	country="Finland",
	level=45,
	exp=30624,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=46, [140]=13, [150]=27, [160]=17, [170]=21, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 940,
	lifetime_jp = 0,
}

ECS.Players["wrsw"] = {
	id=128704,
	isupper=false,
	country="Canada",
	level=46,
	exp=33720,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=37, [150]=19, [160]=13, [170]=9, [180]=6, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2952,
	lifetime_jp = 0,
}

ECS.Players["dimo2020"] = {
	id=87476,
	isupper=false,
	country="U.S.A.",
	level=45,
	exp=30938,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=59, [150]=30, [160]=22, [170]=11, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6382,
	lifetime_jp = 0,
}

ECS.Players["JAEke"] = {
	id=128528,
	isupper=false,
	country="U.S.A.",
	level=54,
	exp=66549,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Zweihander",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=91, [150]=95, [160]=38, [170]=21, [180]=10, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5130,
	lifetime_jp = 0,
}

ECS.Players["natano"] = {
	id=82526,
	isupper=false,
	country="Austria",
	level=53,
	exp=62548,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=92, [160]=38, [170]=16, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=193, rp=0, ap=0},
	lifetime_song_gold = 2742,
	lifetime_jp = 0,
}

ECS.Players["EmanSaur"] = {
	id=77599,
	isupper=false,
	country="Australia",
	level=49,
	exp=42043,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=11},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=36, [150]=55, [160]=31, [170]=11, [180]=6, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=134, rp=0, ap=0},
	lifetime_song_gold = 4026,
	lifetime_jp = 0,
}

ECS.Players["hollowaytape"] = {
	id=80140,
	isupper=false,
	country="U.S.A.",
	level=52,
	exp=56796,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Tiger Fangs",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=95, [160]=36, [170]=13, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=60, ep=90, rp=35, ap=0},
	lifetime_song_gold = 416,
	lifetime_jp = 0,
}

ECS.Players["Rangifer"] = {
	id=4819,
	isupper=false,
	country="Finland",
	level=44,
	exp=27321,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=48, [140]=52, [150]=45, [160]=14, [170]=6, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1749,
	lifetime_jp = 0,
}

ECS.Players["LilK1rby"] = {
	id=124444,
	isupper=false,
	country="U.S.A.",
	level=38,
	exp=15288,
	relics = {
		{name="Spike Knuckles",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=10, [140]=29, [150]=18, [160]=15, [170]=5, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2439,
	lifetime_jp = 0,
}

ECS.Players["Zoraxe"] = {
	id=128734,
	isupper=false,
	country="U.S.A.",
	level=35,
	exp=11453,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=1, [140]=3, [150]=13, [160]=1, [170]=7, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 454,
	lifetime_jp = 0,
}

ECS.Players["AXB"] = {
	id=66717,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=16656,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=18, [140]=1, [150]=8, [160]=10, [170]=8, [180]=6, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1433,
	lifetime_jp = 0,
}

ECS.Players["orutan"] = {
	id=66636,
	isupper=false,
	country="Japan",
	level=31,
	exp=7576,
	relics = {
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Catz"] = {
	id=6791,
	isupper=false,
	country="France",
	level=48,
	exp=39122,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=89, [140]=50, [150]=54, [160]=21, [170]=13, [180]=1, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6543,
	lifetime_jp = 0,
}

ECS.Players["alt_unyv"] = {
	id=135061,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=19234,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=35, [140]=8, [150]=34, [160]=11, [170]=3, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 304,
	lifetime_jp = 0,
}

ECS.Players["stormpegy"] = {
	id=127499,
	isupper=false,
	country="Australia",
	level=44,
	exp=26330,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=63, [140]=44, [150]=55, [160]=19, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=50, ep=65, rp=0, ap=0},
	lifetime_song_gold = 302,
	lifetime_jp = 0,
}

ECS.Players["dashark"] = {
	id=124751,
	isupper=false,
	country="U.S.A.",
	level=49,
	exp=41273,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=91, [150]=54, [160]=22, [170]=6, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3857,
	lifetime_jp = 0,
}

ECS.Players["caruku"] = {
	id=77909,
	isupper=false,
	country="Japan",
	level=47,
	exp=37097,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=66, [150]=38, [160]=24, [170]=10, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2160,
	lifetime_jp = 0,
}

ECS.Players["ouran"] = {
	id=66757,
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=46970,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=83, [160]=30, [170]=8, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4455,
	lifetime_jp = 0,
}

ECS.Players["drc84"] = {
	id=66785,
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=47175,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=72, [150]=66, [160]=25, [170]=17, [180]=7, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7256,
	lifetime_jp = 0,
}

ECS.Players["Ray"] = {
	id=132051,
	isupper=false,
	country="Canada",
	level=50,
	exp=45609,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Barbed Lariat",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=56, [150]=66, [160]=27, [170]=19, [180]=5, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4504,
	lifetime_jp = 0,
}

ECS.Players["Zylos"] = {
	id=133770,
	isupper=false,
	country="U.S.A.",
	level=47,
	exp=36818,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Bronze Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=84, [150]=62, [160]=20, [170]=7, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=148, rp=0, ap=0},
	lifetime_song_gold = 1458,
	lifetime_jp = 0,
}

ECS.Players["neyoru"] = {
	id=132471,
	isupper=false,
	country="Poland",
	level=43,
	exp=24081,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=35, [140]=28, [150]=28, [160]=16, [170]=10, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=25, ep=30, rp=20, ap=40},
	lifetime_song_gold = 3554,
	lifetime_jp = 0,
}

ECS.Players["Struz"] = {
	id=77433,
	isupper=false,
	country="Australia",
	level=46,
	exp=33528,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=80, [150]=54, [160]=22, [170]=7, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 526,
	lifetime_jp = 0,
}

ECS.Players["undrcontrol"] = {
	id=75667,
	isupper=false,
	country="Canada",
	level=46,
	exp=33705,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=76, [140]=74, [150]=36, [160]=17, [170]=9, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1517,
	lifetime_jp = 0,
}

ECS.Players["Mango"] = {
	id=108801,
	isupper=false,
	country="Canada",
	level=50,
	exp=44992,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Skull Ring",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=74, [150]=74, [160]=24, [170]=15, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=40, ep=50, rp=45, ap=34},
	lifetime_song_gold = 717,
	lifetime_jp = 0,
}

ECS.Players["senstin1"] = {
	id=135450,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=17167,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=10, [150]=2, [160]=9, [170]=3, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["QUICKER"] = {
	id=133806,
	isupper=false,
	country="Japan",
	level=32,
	exp=8415,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=2, [150]=3, [160]=10, [170]=6, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1521,
	lifetime_jp = 0,
}

ECS.Players["MoistBruh"] = {
	id=128002,
	isupper=false,
	country="U.S.A.",
	level=44,
	exp=28083,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=47, [160]=15, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3361,
	lifetime_jp = 0,
}

ECS.Players["babyalan"] = {
	id=128004,
	isupper=false,
	country="U.S.A.",
	level=44,
	exp=28462,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=25, [150]=29, [160]=20, [170]=7, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 872,
	lifetime_jp = 0,
}

ECS.Players["Sk8mag"] = {
	id=5749,
	isupper=false,
	country="U.S.A.",
	level=33,
	exp=9323,
	relics = {
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=33, [150]=8, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1074,
	lifetime_jp = 0,
}

ECS.Players["Flash2020"] = {
	id=132054,
	isupper=false,
	country="U.S.A.",
	level=31,
	exp=7362,
	relics = {
	},
	tier_skill = {[120]=64, [130]=4, [140]=15, [150]=7, [160]=1, [170]=8, [180]=1, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1440,
	lifetime_jp = 0,
}

ECS.Players["antec"] = {
	id=75621,
	isupper=false,
	country="Australia",
	level=44,
	exp=28021,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=57, [140]=40, [150]=39, [160]=18, [170]=16, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 710,
	lifetime_jp = 0,
}

ECS.Players["Lugea"] = {
	id=84583,
	isupper=false,
	country="Uruguay",
	level=40,
	exp=19508,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=46, [140]=14, [150]=9, [160]=21, [170]=10, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=27, rp=0, ap=50},
	lifetime_song_gold = 2933,
	lifetime_jp = 0,
}

ECS.Players["5739SO-!"] = {
	id=132115,
	isupper=false,
	country="Japan",
	level=35,
	exp=11625,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=79, [130]=19, [140]=19, [150]=22, [160]=8, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1973,
	lifetime_jp = 0,
}

ECS.Players["squatz.zexyu"] = {
	id=4681,
	isupper=false,
	country="U.S.A.",
	level=43,
	exp=23929,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=46, [150]=19, [160]=19, [170]=10, [180]=4, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3349,
	lifetime_jp = 0,
}

ECS.Players["Zaelyx"] = {
	id=80039,
	isupper=false,
	country="U.S.A.",
	level=48,
	exp=38758,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=72, [150]=64, [160]=23, [170]=13, [180]=7, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6764,
	lifetime_jp = 0,
}

ECS.Players["AV6"] = {
	id=66387,
	isupper=false,
	country="France",
	level=38,
	exp=15857,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=71, [140]=36, [150]=35, [160]=8, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 989,
	lifetime_jp = 0,
}

ECS.Players["Staphf"] = {
	id=66670,
	isupper=false,
	country="U.S.A.",
	level=37,
	exp=14159,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=3, [150]=1, [160]=1, [170]=4, [180]=1, [190]=2, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 457,
	lifetime_jp = 248,
}

ECS.Players["Hamaon"] = {
	id=127780,
	isupper=false,
	country="U.S.A.",
	level=48,
	exp=40375,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=72, [160]=25, [170]=12, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=145, rp=10, ap=0},
	lifetime_song_gold = 233,
	lifetime_jp = 0,
}

ECS.Players["FabSab44"] = {
	id=66610,
	isupper=false,
	country="Canada",
	level=38,
	exp=16166,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=43, [150]=32, [160]=12, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=20, rp=20, ap=3},
	lifetime_song_gold = 554,
	lifetime_jp = 0,
}

ECS.Players["Alhe"] = {
	id=66703,
	isupper=false,
	country="Finland",
	level=40,
	exp=18999,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=79, [130]=58, [140]=64, [150]=46, [160]=6, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2314,
	lifetime_jp = 0,
}

ECS.Players["Narei"] = {
	id=134296,
	isupper=false,
	country="U.S.A.",
	level=48,
	exp=40179,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=72, [150]=66, [160]=22, [170]=18, [180]=7, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4695,
	lifetime_jp = 0,
}

ECS.Players["mirin"] = {
	id=127939,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=16321,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=31, [150]=25, [160]=13, [170]=8, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1100,
	lifetime_jp = 0,
}

ECS.Players["TheTruck"] = {
	id=4793,
	isupper=false,
	country="U.S.A.",
	level=32,
	exp=8418,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=9, [160]=6, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=2, ep=2, rp=2, ap=2},
	lifetime_song_gold = 1272,
	lifetime_jp = 0,
}

ECS.Players["gomana2"] = {
	id=128620,
	isupper=false,
	country="Japan",
	level=31,
	exp=7783,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=1, [140]=14, [150]=1, [160]=7, [170]=1, [180]=1, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 423,
	lifetime_jp = 0,
}

ECS.Players["frosty"] = {
	id=128011,
	isupper=false,
	country="U.S.A.",
	level=32,
	exp=8613,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Bronze Trophy",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=9, [140]=1, [150]=1, [160]=1, [170]=3, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 612,
	lifetime_jp = 0,
}

ECS.Players["nerdnim"] = {
	id=76196,
	isupper=false,
	country="U.S.A.",
	level=43,
	exp=24895,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=31, [140]=24, [150]=32, [160]=21, [170]=10, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=15, ep=15, rp=4, ap=3},
	lifetime_song_gold = 77,
	lifetime_jp = 0,
}

ECS.Players["Alto"] = {
	id=66756,
	isupper=false,
	country="Russian Federation",
	level=39,
	exp=16756,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=15, [150]=23, [160]=14, [170]=11, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1239,
	lifetime_jp = 0,
}

ECS.Players["Thebeatmaniac"] = {
	id=66798,
	isupper=false,
	country="U.S.A.",
	level=37,
	exp=13554,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=16, [140]=19, [150]=28, [160]=11, [170]=5, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=18, ep=45, rp=10, ap=4},
	lifetime_song_gold = 870,
	lifetime_jp = 0,
}

ECS.Players["BigC"] = {
	id=127810,
	isupper=false,
	country="U.S.A.",
	level=42,
	exp=23109,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=81, [140]=42, [150]=31, [160]=12, [170]=9, [180]=4, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5910,
	lifetime_jp = 0,
}

ECS.Players["alecksaur"] = {
	id=66794,
	isupper=false,
	country="U.S.A.",
	level=43,
	exp=25751,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=85, [150]=52, [160]=15, [170]=5, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6365,
	lifetime_jp = 0,
}

ECS.Players["Johahn"] = {
	id=78193,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=18773,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=18, [150]=29, [160]=11, [170]=8, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 332,
	lifetime_jp = 0,
}

ECS.Players["Namidael"] = {
	id=8107,
	isupper=false,
	country="France",
	level=44,
	exp=26178,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Cat's Claws",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=53, [160]=16, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5956,
	lifetime_jp = 0,
}

ECS.Players["dbK"] = {
	id=75542,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=19014,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=83, [140]=37, [150]=36, [160]=12, [170]=7, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 649,
	lifetime_jp = 0,
}

ECS.Players["SPVLABS"] = {
	id=127827,
	isupper=false,
	country="U.S.A.",
	level=46,
	exp=33055,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=91, [150]=48, [160]=22, [170]=10, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6401,
	lifetime_jp = 0,
}

ECS.Players["Stefe"] = {
	id=80607,
	isupper=false,
	country="Poland",
	level=36,
	exp=12358,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=16, [140]=16, [150]=13, [160]=7, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=22, ep=25, rp=25, ap=10},
	lifetime_song_gold = 271,
	lifetime_jp = 0,
}

ECS.Players["Jafar"] = {
	id=4989,
	isupper=false,
	country="U.S.A.",
	level=37,
	exp=14055,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=22, [140]=9, [150]=19, [160]=5, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=13, ep=13, rp=13, ap=12},
	lifetime_song_gold = 2363,
	lifetime_jp = 0,
}

ECS.Players["NUWGET"] = {
	id=66517,
	isupper=false,
	country="U.S.A.",
	level=41,
	exp=21297,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=41, [140]=13, [150]=23, [160]=12, [170]=5, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=27, ep=28, rp=27, ap=27},
	lifetime_song_gold = 259,
	lifetime_jp = 0,
}

ECS.Players["Concubidated"] = {
	id=5638,
	isupper=false,
	country="U.S.A.",
	level=41,
	exp=19847,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=37, [150]=34, [160]=11, [170]=4, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=30, rp=0, ap=42},
	lifetime_song_gold = 5147,
	lifetime_jp = 0,
}

ECS.Players["Hiiro"] = {
	id=127596,
	isupper=false,
	country="France",
	level=44,
	exp=27339,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=80, [140]=60, [150]=23, [160]=14, [170]=11, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 427,
	lifetime_jp = 0,
}

ECS.Players["harujun"] = {
	id=135041,
	isupper=false,
	country="U.S.A.",
	level=31,
	exp=7791,
	relics = {
		{name="Stone Blade",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=11, [140]=1, [150]=7, [160]=6, [170]=2, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1187,
	lifetime_jp = 0,
}

ECS.Players["Level9Chao"] = {
	id=76182,
	isupper=false,
	country="U.S.A.",
	level=38,
	exp=16020,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=71, [140]=28, [150]=9, [160]=7, [170]=6, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 446,
	lifetime_jp = 0,
}

ECS.Players["Vagabond"] = {
	id=2910,
	isupper=false,
	country="U.S.A.",
	level=37,
	exp=13937,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=67, [140]=22, [150]=17, [160]=9, [170]=6, [180]=3, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=23, ep=23, rp=10, ap=7},
	lifetime_song_gold = 2499,
	lifetime_jp = 0,
}

ECS.Players["DJNidra"] = {
	id=127988,
	isupper=false,
	country="U.S.A.",
	level=35,
	exp=11645,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=81, [140]=27, [150]=17, [160]=5, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=7, ep=9, rp=8, ap=7},
	lifetime_song_gold = 1470,
	lifetime_jp = 0,
}

ECS.Players["MrMeatloaf"] = {
	id=5314,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=17896,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=61, [140]=37, [150]=24, [160]=12, [170]=9, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3882,
	lifetime_jp = 0,
}

ECS.Players["PenguinMessiah"] = {
	id=3116,
	isupper=false,
	country="U.S.A.",
	level=46,
	exp=31825,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=63, [150]=49, [160]=19, [170]=10, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["dgraham"] = {
	id=98817,
	isupper=false,
	country="U.S.A.",
	level=44,
	exp=26227,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=42, [140]=45, [150]=44, [160]=19, [170]=10, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5474,
	lifetime_jp = 0,
}

ECS.Players["VERTEX KIO"] = {
	id=35405,
	isupper=false,
	country="Colombia",
	level=27,
	exp=5095,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=9, [150]=2, [160]=10, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 825,
	lifetime_jp = 0,
}

ECS.Players["asellus"] = {
	id=127865,
	isupper=false,
	country="South Korea",
	level=41,
	exp=20983,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=45, [150]=40, [160]=16, [170]=6, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=13, ep=12, rp=15, ap=15},
	lifetime_song_gold = 4532,
	lifetime_jp = 0,
}

ECS.Players["Robbumon"] = {
	id=73473,
	isupper=false,
	country="U.S.A.",
	level=45,
	exp=29859,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=72, [150]=51, [160]=17, [170]=9, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=10, ep=10, rp=10, ap=7},
	lifetime_song_gold = 2833,
	lifetime_jp = 0,
}

ECS.Players["Vestrel"] = {
	id=76078,
	isupper=false,
	country="Canada",
	level=39,
	exp=17693,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=31, [150]=36, [160]=13, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 640,
	lifetime_jp = 0,
}

ECS.Players["tomnobar"] = {
	id=2517,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=16533,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=91, [150]=20, [160]=7, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 898,
	lifetime_jp = 0,
}

ECS.Players["Gumbygum"] = {
	id=135314,
	isupper=false,
	country="U.S.A.",
	level=33,
	exp=9817,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=85, [140]=30, [150]=7, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1382,
	lifetime_jp = 0,
}

ECS.Players["Lokovodo"] = {
	id=76621,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=18009,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=55, [150]=27, [160]=13, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=20, ep=20, rp=20, ap=20},
	lifetime_song_gold = 720,
	lifetime_jp = 0,
}

ECS.Players["naterizzle"] = {
	id=66799,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=17919,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Slime Badge",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=21, [150]=8, [160]=14, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 820,
	lifetime_jp = 0,
}

ECS.Players["Darkuo "] = {
	id=78689,
	isupper=false,
	country="U.S.A.",
	level=34,
	exp=10650,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=20, [150]=15, [160]=6, [170]=6, [180]=2, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3338,
	lifetime_jp = 0,
}

ECS.Players["Palitroque"] = {
	id=131754,
	isupper=false,
	country="Chile",
	level=31,
	exp=7971,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=59, [140]=18, [150]=6, [160]=6, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1794,
	lifetime_jp = 0,
}

ECS.Players["(305STARS) Gooby"] = {
	id=127820,
	isupper=false,
	country="U.S.A.",
	level=30,
	exp=7249,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=28, [150]=11, [160]=3, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=2, rp=0, ap=3},
	lifetime_song_gold = 2037,
	lifetime_jp = 0,
}

ECS.Players["mastamaxx"] = {
	id=75812,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=17427,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=82, [150]=34, [160]=9, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=15, rp=0, ap=40},
	lifetime_song_gold = 2650,
	lifetime_jp = 0,
}

ECS.Players["werdwerdus"] = {
	id=6555,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=19098,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=59, [150]=34, [160]=12, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1363,
	lifetime_jp = 0,
}

ECS.Players["Zeo"] = {
	id=118191,
	isupper=false,
	country="U.S.A.",
	level=38,
	exp=15208,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=42, [150]=17, [160]=11, [170]=7, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3671,
	lifetime_jp = 0,
}

ECS.Players["SMYD"] = {
	id=129904,
	isupper=false,
	country="U.S.A.",
	level=41,
	exp=20561,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=48, [150]=33, [160]=14, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 824,
	lifetime_jp = 0,
}

ECS.Players["djMHT"] = {
	id=5589,
	isupper=false,
	country="U.S.A.",
	level=35,
	exp=12087,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=35, [140]=41, [150]=29, [160]=7, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=8, ep=8, rp=2, ap=16},
	lifetime_song_gold = 2449,
	lifetime_jp = 0,
}

ECS.Players["QooMA"] = {
	id=66582,
	isupper=false,
	country="Japan",
	level=36,
	exp=12826,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=79, [150]=8, [160]=6, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 484,
	lifetime_jp = 0,
}

ECS.Players["palacebeast"] = {
	id=132528,
	isupper=false,
	country="U.S.A.",
	level=39,
	exp=17812,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=33, [150]=24, [160]=10, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=4, ep=69, rp=2, ap=0},
	lifetime_song_gold = 1781,
	lifetime_jp = 0,
}

ECS.Players["Mad RobNoBarKid"] = {
	id=3242,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=18819,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Bronze Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=75, [150]=30, [160]=10, [170]=4, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=46, rp=0, ap=41},
	lifetime_song_gold = 4365,
	lifetime_jp = 0,
}

ECS.Players["Maniacal"] = {
	id=1432,
	isupper=false,
	country="U.S.A.",
	level=44,
	exp=28251,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Shashka",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=63, [150]=42, [160]=17, [170]=9, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=27, rp=0, ap=100},
	lifetime_song_gold = 2572,
	lifetime_jp = 0,
}

ECS.Players["MaxPainNL"] = {
	id=78598,
	isupper=false,
	country="Netherlands",
	level=39,
	exp=17225,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=63, [150]=28, [160]=12, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 149,
	lifetime_jp = 0,
}

ECS.Players["samross"] = {
	id=78188,
	isupper=false,
	country="U.S.A.",
	level=32,
	exp=8341,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=47, [150]=12, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2728,
	lifetime_jp = 0,
}

ECS.Players["keekster"] = {
	id=127785,
	isupper=false,
	country="U.S.A.",
	level=40,
	exp=17971,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=36, [150]=23, [160]=15, [170]=9, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2416,
	lifetime_jp = 0,
}

ECS.Players["mld"] = {
	id=130783,
	isupper=false,
	country="U.S.A.",
	level=36,
	exp=12630,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=57, [140]=37, [150]=30, [160]=15, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 458,
	lifetime_jp = 0,
}

ECS.Players["Roujo"] = {
	id=91184,
	isupper=false,
	country="Canada",
	level=36,
	exp=12261,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=44, [150]=23, [160]=9, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 822,
	lifetime_jp = 0,
}

ECS.Players["SleepBAAA"] = {
	id=75724,
	isupper=false,
	country="Spain",
	level=37,
	exp=14173,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=39, [150]=27, [160]=14, [170]=4, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2054,
	lifetime_jp = 0,
}

ECS.Players["SSmantis"] = {
	id=80222,
	isupper=false,
	country="Spain",
	level=31,
	exp=7766,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=17, [150]=19, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 481,
	lifetime_jp = 0,
}

ECS.Players["VivaLaMoo"] = {
	id=4362,
	isupper=false,
	country="U.S.A.",
	level=24,
	exp=3521,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=7, [140]=6, [150]=1, [160]=2, [170]=4, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 952,
	lifetime_jp = 0,
}

ECS.Players["ddrsarah"] = {
	id=114980,
	isupper=false,
	country="U.S.A.",
	level=32,
	exp=8822,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=10, [150]=8, [160]=4, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2162,
	lifetime_jp = 0,
}

ECS.Players["Mekki"] = {
	id=6703,
	isupper=false,
	country="Finland",
	level=29,
	exp=6383,
	relics = {
		{name="Baguette",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=10, [140]=16, [150]=1, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 904,
	lifetime_jp = 0,
}

ECS.Players["help"] = {
	id=75729,
	isupper=false,
	country="U.S.A.",
	level=37,
	exp=13708,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=63, [150]=15, [160]=8, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 98,
	lifetime_jp = 0,
}

ECS.Players["Jhennyinthecup "] = {
	id=128840,
	isupper=false,
	country="U.S.A.",
	level=27,
	exp=5209,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=47, [140]=7, [150]=9, [160]=1, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1436,
	lifetime_jp = 0,
}

ECS.Players["inbredbearz"] = {
	id=127957,
	isupper=false,
	country="U.S.A.",
	level=31,
	exp=7737,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=50, [140]=9, [150]=12, [160]=5, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1373,
	lifetime_jp = 0,
}

ECS.Players["Hiloshi"] = {
	id=129604,
	isupper=false,
	country="Japan",
	level=29,
	exp=6233,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=10, [150]=12, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 609,
	lifetime_jp = 0,
}

ECS.Players["GoP-Demon"] = {
	id=4629,
	isupper=false,
	country="Canada",
	level=26,
	exp=4467,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=4, [140]=5, [150]=7, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 352,
	lifetime_jp = 0,
}

ECS.Players["Xylex"] = {
	id=133778,
	isupper=false,
	country="U.S.A.",
	level=31,
	exp=7403,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=61, [140]=24, [150]=12, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1560,
	lifetime_jp = 0,
}

ECS.Players["larksford"] = {
	id=75662,
	isupper=false,
	country="U.S.A.",
	level=32,
	exp=8639,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=39, [140]=12, [150]=8, [160]=6, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=20, ep=18, rp=5, ap=20},
	lifetime_song_gold = 920,
	lifetime_jp = 0,
}

ECS.Players["toppomeranian"] = {
	id=115896,
	isupper=false,
	country="U.S.A.",
	level=27,
	exp=5156,
	relics = {
		{name="Dirk",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=37, [140]=12, [150]=7, [160]=7, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1333,
	lifetime_jp = 0,
}

ECS.Players["Schlong$"] = {
	id=129498,
	isupper=false,
	country="U.S.A.",
	level=23,
	exp=3310,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=44, [130]=7, [140]=9, [150]=5, [160]=2, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1043,
	lifetime_jp = 0,
}

ECS.Players["Pluto-chan"] = {
	id=66394,
	isupper=false,
	country="Russian Federation",
	level=33,
	exp=9382,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=78, [140]=21, [150]=19, [160]=9, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1042,
	lifetime_jp = 0,
}

ECS.Players["talkion"] = {
	id=128047,
	isupper=false,
	country="U.S.A.",
	level=23,
	exp=3308,
	relics = {
		{name="Baguette",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=1, [140]=7, [150]=2, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 171,
	lifetime_jp = 0,
}

ECS.Players["vehnae"] = {
	id=6028,
	isupper=false,
	country="Finland",
	level=31,
	exp=7380,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=70, [140]=23, [150]=12, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1676,
	lifetime_jp = 0,
}

ECS.Players["MY BRAND"] = {
	id=129649,
	isupper=false,
	country="U.S.A.",
	level=31,
	exp=7927,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=81, [140]=16, [150]=15, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1918,
	lifetime_jp = 0,
}

ECS.Players["migz"] = {
	id=132144,
	isupper=false,
	country="Canada",
	level=26,
	exp=4432,
	relics = {
		{name="Stone Knife",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=15, [140]=4, [150]=16, [160]=5, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 254,
	lifetime_jp = 0,
}

ECS.Players["Rabar0209"] = {
	id=93327,
	isupper=false,
	country="Japan",
	level=29,
	exp=6002,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=5, [150]=6, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=7, ep=13, rp=0, ap=0},
	lifetime_song_gold = 27,
	lifetime_jp = 0,
}

ECS.Players["scientificRex"] = {
	id=127796,
	isupper=false,
	country="U.S.A.",
	level=30,
	exp=6749,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=16, [150]=15, [160]=5, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 232,
	lifetime_jp = 0,
}

ECS.Players["limitin"] = {
	id=66443,
	isupper=false,
	country="U.S.A.",
	level=33,
	exp=9143,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Zorlin Shape",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=31, [150]=8, [160]=7, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3220,
	lifetime_jp = 0,
}

ECS.Players["Quesadilla"] = {
	id=128893,
	isupper=false,
	country="U.S.A.",
	level=29,
	exp=5992,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=27, [140]=4, [150]=8, [160]=7, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 716,
	lifetime_jp = 0,
}

ECS.Players["andy457"] = {
	id=982,
	isupper=false,
	country="U.S.A.",
	level=26,
	exp=4555,
	relics = {
	},
	tier_skill = {[120]=64, [130]=6, [140]=6, [150]=21, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1438,
	lifetime_jp = 0,
}

ECS.Players["REDOILY"] = {
	id=133575,
	isupper=false,
	country="Japan",
	level=20,
	exp=2428,
	relics = {
	},
	tier_skill = {[120]=22, [130]=1, [140]=8, [150]=8, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["SoupP"] = {
	id=6713,
	isupper=false,
	country="U.S.A.",
	level=32,
	exp=8146,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=73, [140]=25, [150]=19, [160]=9, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 685,
	lifetime_jp = 0,
}

ECS.Players["Androo"] = {
	id=907,
	isupper=false,
	country="U.S.A.",
	level=29,
	exp=6328,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=69, [140]=20, [150]=8, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2527,
	lifetime_jp = 0,
}

ECS.Players["Zeipher_NoBar"] = {
	id=133395,
	isupper=false,
	country="U.S.A.",
	level=24,
	exp=3856,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=35, [130]=11, [140]=23, [150]=6, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 289,
	lifetime_jp = 0,
}

ECS.Players["angelXboy"] = {
	id=134389,
	isupper=false,
	country="U.S.A.",
	level=28,
	exp=5397,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=23, [130]=42, [140]=1, [150]=5, [160]=3, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 378,
	lifetime_jp = 0,
}

ECS.Players["KyleTT"] = {
	id=129120,
	isupper=false,
	country="U.S.A.",
	level=29,
	exp=6502,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=13, [150]=18, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=7, ep=20, rp=0, ap=20},
	lifetime_song_gold = 298,
	lifetime_jp = 0,
}

ECS.Players["Astriferous"] = {
	id=127930,
	isupper=false,
	country="U.S.A.",
	level=30,
	exp=7040,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=39, [140]=11, [150]=12, [160]=7, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1451,
	lifetime_jp = 0,
}

ECS.Players["NDGO"] = {
	id=134656,
	isupper=false,
	country="U.S.A.",
	level=29,
	exp=6331,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=61, [140]=36, [150]=11, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2606,
	lifetime_jp = 0,
}

ECS.Players["gabbyjay"] = {
	id=128742,
	isupper=false,
	country="U.S.A.",
	level=28,
	exp=5767,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=9},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=73, [140]=19, [150]=9, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1315,
	lifetime_jp = 0,
}

ECS.Players["Alkene777"] = {
	id=128732,
	isupper=false,
	country="U.S.A.",
	level=29,
	exp=6580,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=63, [140]=23, [150]=15, [160]=6, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 572,
	lifetime_jp = 0,
}

ECS.Players["ClenonWolf"] = {
	id=133033,
	isupper=false,
	country="Germany",
	level=28,
	exp=5937,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=20, [150]=17, [160]=7, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 80,
	lifetime_jp = 0,
}

ECS.Players["Kashy"] = {
	id=128109,
	isupper=false,
	country="Australia",
	level=25,
	exp=4308,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=57, [140]=12, [150]=1, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=5, ep=5, rp=5, ap=19},
	lifetime_song_gold = 663,
	lifetime_jp = 0,
}

ECS.Players["Snil4"] = {
	id=94283,
	isupper=false,
	country="Unspecified",
	level=29,
	exp=6529,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=63, [140]=22, [150]=10, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=14, ep=14, rp=12, ap=11},
	lifetime_song_gold = 302,
	lifetime_jp = 0,
}

ECS.Players["Kirituin"] = {
	id=66694,
	isupper=false,
	country="Netherlands",
	level=31,
	exp=7723,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=25, [150]=14, [160]=7, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=43},
	lifetime_song_gold = 1473,
	lifetime_jp = 0,
}

ECS.Players["ChubbyThePhat"] = {
	id=6170,
	isupper=false,
	country="Canada",
	level=28,
	exp=5472,
	relics = {
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=18, [140]=18, [150]=8, [160]=3, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Honey02U"] = {
	id=129553,
	isupper=false,
	country="Unspecified",
	level=26,
	exp=4377,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=16, [150]=8, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1795,
	lifetime_jp = 0,
}

ECS.Players["mxl100"] = {
	id=136487,
	isupper=false,
	country="U.S.A.",
	level=27,
	exp=5085,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=7},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=22, [150]=8, [160]=7, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=5, ep=5, rp=5, ap=28},
	lifetime_song_gold = 1575,
	lifetime_jp = 0,
}

ECS.Players["meowtastic"] = {
	id=66641,
	isupper=false,
	country="U.S.A.",
	level=28,
	exp=5574,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=59, [140]=7, [150]=9, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 141,
	lifetime_jp = 0,
}

ECS.Players["Dance4Fun"] = {
	id=129948,
	isupper=false,
	country="U.S.A.",
	level=23,
	exp=3099,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=41, [140]=16, [150]=4, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1054,
	lifetime_jp = 0,
}

ECS.Players["AllEnvy"] = {
	id=7861,
	isupper=false,
	country="U.S.A.",
	level=23,
	exp=3279,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=25, [140]=16, [150]=2, [160]=5, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 296,
	lifetime_jp = 0,
}

ECS.Players["Tanooki Joe"] = {
	id=132073,
	isupper=false,
	country="U.S.A.",
	level=24,
	exp=3647,
	relics = {
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=22, [140]=5, [150]=2, [160]=1, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1034,
	lifetime_jp = 0,
}

ECS.Players["zackCOOL"] = {
	id=140896,
	isupper=false,
	country="U.S.A.",
	level=25,
	exp=4073,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=10, [150]=7, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 131,
	lifetime_jp = 0,
}

ECS.Players["Halogen-"] = {
	id=5362,
	isupper=false,
	country="U.S.A.",
	level=24,
	exp=3824,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=13, [150]=6, [160]=5, [170]=3, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 926,
	lifetime_jp = 0,
}

ECS.Players["emcat"] = {
	id=127790,
	isupper=false,
	country="U.S.A.",
	level=24,
	exp=3626,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=43, [140]=18, [150]=8, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1653,
	lifetime_jp = 0,
}

ECS.Players["OMGasm"] = {
	id=73550,
	isupper=false,
	country="Australia",
	level=18,
	exp=1857,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=3, [150]=5, [160]=3, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 66,
	lifetime_jp = 0,
}

ECS.Players["Corgi"] = {
	id=127815,
	isupper=false,
	country="U.S.A.",
	level=22,
	exp=2947,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=26, [140]=15, [150]=6, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1052,
	lifetime_jp = 0,
}

ECS.Players["beeabay"] = {
	id=66777,
	isupper=false,
	country="Finland",
	level=27,
	exp=5107,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=13, [150]=9, [160]=7, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 376,
	lifetime_jp = 0,
}

ECS.Players["Snowball"] = {
	id=66741,
	isupper=false,
	country="France",
	level=18,
	exp=1719,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=15, [140]=7, [150]=7, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 207,
	lifetime_jp = 0,
}

ECS.Players["mafuyu765"] = {
	id=134753,
	isupper=false,
	country="Japan",
	level=17,
	exp=1578,
	relics = {
	},
	tier_skill = {[120]=1, [130]=4, [140]=7, [150]=5, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7,
	lifetime_jp = 0,
}

ECS.Players["Teperoo"] = {
	id=76238,
	isupper=false,
	country="United Kingdom",
	level=11,
	exp=621,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 159,
	lifetime_jp = 0,
}

ECS.Players["JeffreyATW"] = {
	id=77862,
	isupper=false,
	country="U.S.A.",
	level=17,
	exp=1494,
	relics = {
	},
	tier_skill = {[120]=35, [130]=11, [140]=7, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 272,
	lifetime_jp = 0,
}

ECS.Players["026@Tokyo"] = {
	id=66397,
	isupper=false,
	country="Japan",
	level=21,
	exp=2587,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=10, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 191,
	lifetime_jp = 0,
}

ECS.Players["CarterTheQ"] = {
	id=128275,
	isupper=false,
	country="U.S.A.",
	level=21,
	exp=2613,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=16, [140]=17, [150]=1, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=8, ep=0, rp=0, ap=0},
	lifetime_song_gold = 559,
	lifetime_jp = 0,
}

ECS.Players["lfkingdom"] = {
	id=128724,
	isupper=false,
	country="Unspecified",
	level=25,
	exp=3991,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=8, [150]=9, [160]=3, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=14},
	lifetime_song_gold = 700,
	lifetime_jp = 0,
}

ECS.Players["DanPeriod"] = {
	id=256,
	isupper=false,
	country="U.S.A.",
	level=24,
	exp=3527,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=16, [150]=8, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=2, ep=7, rp=2, ap=7},
	lifetime_song_gold = 798,
	lifetime_jp = 0,
}

ECS.Players["mqp"] = {
	id=131942,
	isupper=false,
	country="U.S.A.",
	level=21,
	exp=2727,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=16, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=1, ep=3, rp=1, ap=3},
	lifetime_song_gold = 129,
	lifetime_jp = 0,
}

ECS.Players["NekoMithos"] = {
	id=55445,
	isupper=false,
	country="Netherlands",
	level=18,
	exp=1796,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=12, [140]=15, [150]=1, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 75,
	lifetime_jp = 0,
}

ECS.Players["ManeMan8"] = {
	id=128292,
	isupper=false,
	country="U.S.A.",
	level=22,
	exp=2990,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=7, [150]=9, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=3, ep=7, rp=2, ap=13},
	lifetime_song_gold = 633,
	lifetime_jp = 0,
}

ECS.Players["GoldenMagikarp1020"] = {
	id=134651,
	isupper=false,
	country="U.S.A.",
	level=25,
	exp=4167,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Spike Knuckles",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=25, [150]=4, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=10, ep=11, rp=7, ap=6},
	lifetime_song_gold = 309,
	lifetime_jp = 0,
}

ECS.Players["SirDippingsauce"] = {
	id=66496,
	isupper=false,
	country="U.S.A.",
	level=22,
	exp=2949,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=52, [140]=22, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1295,
	lifetime_jp = 0,
}

ECS.Players["Zannzabar"] = {
	id=78688,
	isupper=false,
	country="U.S.A.",
	level=20,
	exp=2210,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=27, [140]=5, [150]=1, [160]=2, [170]=1, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 372,
	lifetime_jp = 0,
}

ECS.Players["Twans"] = {
	id=81056,
	isupper=false,
	country="U.S.A.",
	level=22,
	exp=2995,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 758,
	lifetime_jp = 0,
}

ECS.Players["MrCrete"] = {
	id=127812,
	isupper=false,
	country="U.S.A.",
	level=20,
	exp=2292,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=13, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=2, ap=5},
	lifetime_song_gold = 689,
	lifetime_jp = 0,
}

ECS.Players["Catastrophe"] = {
	id=135491,
	isupper=false,
	country="U.S.A.",
	level=19,
	exp=2159,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=10, [150]=3, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 713,
	lifetime_jp = 0,
}

ECS.Players["Yabya"] = {
	id=5483,
	isupper=false,
	country="U.S.A.",
	level=22,
	exp=2938,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=16, [150]=6, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1578,
	lifetime_jp = 0,
}

ECS.Players["DevilJin"] = {
	id=129364,
	isupper=false,
	country="U.S.A.",
	level=20,
	exp=2372,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=8, [150]=1, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1215,
	lifetime_jp = 0,
}

ECS.Players["KevinDGAF"] = {
	id=66748,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1306,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=35, [130]=6, [140]=3, [150]=5, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 311,
	lifetime_jp = 0,
}

ECS.Players["Jaeil"] = {
	id=132223,
	isupper=false,
	country="U.S.A.",
	level=21,
	exp=2503,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=58, [130]=32, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 50,
	lifetime_jp = 0,
}

ECS.Players["nuki"] = {
	id=130786,
	isupper=false,
	country="U.S.A.",
	level=20,
	exp=2409,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=43, [140]=13, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 308,
	lifetime_jp = 0,
}

ECS.Players["Aura"] = {
	id=66553,
	isupper=false,
	country="U.S.A.",
	level=20,
	exp=2308,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=16, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 998,
	lifetime_jp = 0,
}

ECS.Players["SpaghettiSnail"] = {
	id=129633,
	isupper=false,
	country="U.S.A.",
	level=19,
	exp=2069,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=37, [140]=9, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 626,
	lifetime_jp = 0,
}

ECS.Players["Fingy"] = {
	id=132280,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1385,
	relics = {
	},
	tier_skill = {[120]=20, [130]=10, [140]=5, [150]=5, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 332,
	lifetime_jp = 0,
}

ECS.Players["slime"] = {
	id=131910,
	isupper=false,
	country="U.S.A.",
	level=21,
	exp=2743,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=31, [140]=16, [150]=4, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 442,
	lifetime_jp = 0,
}

ECS.Players["kyle"] = {
	id=127791,
	isupper=false,
	country="U.S.A.",
	level=20,
	exp=2412,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=13, [150]=4, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=4, ep=4, rp=4, ap=4},
	lifetime_song_gold = 1335,
	lifetime_jp = 0,
}

ECS.Players["Jester"] = {
	id=1090,
	isupper=false,
	country="United Kingdom",
	level=21,
	exp=2738,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=42, [130]=7, [140]=5, [150]=1, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 359,
	lifetime_jp = 0,
}

ECS.Players["Opartyjesper"] = {
	id=132119,
	isupper=false,
	country="Sweden",
	level=20,
	exp=2397,
	relics = {
	},
	tier_skill = {[120]=42, [130]=23, [140]=2, [150]=6, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 556,
	lifetime_jp = 0,
}

ECS.Players["hegza"] = {
	id=75719,
	isupper=false,
	country="Finland",
	level=20,
	exp=2250,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=22, [130]=12, [140]=3, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 16,
	lifetime_jp = 0,
}

ECS.Players["Not Matt"] = {
	id=62987,
	isupper=false,
	country="U.S.A.",
	level=25,
	exp=3978,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=23, [130]=6, [140]=5, [150]=3, [160]=2, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 612,
	lifetime_jp = 0,
}

ECS.Players["Dims."] = {
	id=139170,
	isupper=false,
	country="U.S.A.",
	level=19,
	exp=2120,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=43, [140]=8, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=10, rp=0, ap=10},
	lifetime_song_gold = 1064,
	lifetime_jp = 0,
}

ECS.Players["xopher"] = {
	id=66699,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1371,
	relics = {
	},
	tier_skill = {[120]=20, [130]=23, [140]=1, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 510,
	lifetime_jp = 0,
}

ECS.Players["jv"] = {
	id=127793,
	isupper=false,
	country="U.S.A.",
	level=18,
	exp=1827,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=22, [140]=10, [150]=2, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 528,
	lifetime_jp = 0,
}

ECS.Players["Hunter"] = {
	id=129655,
	isupper=false,
	country="Canada",
	level=18,
	exp=1896,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=37, [140]=8, [150]=5, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=3, ep=0, rp=3, ap=10},
	lifetime_song_gold = 682,
	lifetime_jp = 0,
}

ECS.Players["Lyricalnyu"] = {
	id=135703,
	isupper=false,
	country="U.S.A.",
	level=18,
	exp=1695,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=5, [150]=3, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 192,
	lifetime_jp = 0,
}

ECS.Players["aidama"] = {
	id=129520,
	isupper=false,
	country="U.S.A.",
	level=17,
	exp=1624,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 445,
	lifetime_jp = 0,
}

ECS.Players["AzleKayn"] = {
	id=7721,
	isupper=false,
	country="U.S.A.",
	level=18,
	exp=1901,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Stone Knife",	quantity=1},
		{name="Stone Axe",	quantity=1},
		{name="Stone Arrow",	quantity=1},
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 817,
	lifetime_jp = 0,
}

ECS.Players["figgies"] = {
	id=8602,
	isupper=false,
	country="U.S.A.",
	level=14,
	exp=1079,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=22, [140]=1, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 537,
	lifetime_jp = 0,
}

ECS.Players["M.Rappold"] = {
	id=128881,
	isupper=false,
	country="U.S.A.",
	level=21,
	exp=2573,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=8, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 190,
	lifetime_jp = 0,
}

ECS.Players["sakurai"] = {
	id=136386,
	isupper=false,
	country="Japan",
	level=17,
	exp=1675,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=26, [140]=8, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 524,
	lifetime_jp = 0,
}

ECS.Players["Ruan"] = {
	id=128207,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1381,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=31, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=1, ep=4, rp=1, ap=8},
	lifetime_song_gold = 535,
	lifetime_jp = 0,
}

ECS.Players["The Synthromancer"] = {
	id=128003,
	isupper=false,
	country="U.S.A.",
	level=22,
	exp=2778,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Mandragora Lettuce",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4,
	lifetime_jp = 0,
}

ECS.Players["itsjusowl1"] = {
	id=128740,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=690,
	relics = {
	},
	tier_skill = {[120]=1, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 81,
	lifetime_jp = 0,
}

ECS.Players["tetrisben"] = {
	id=66770,
	isupper=false,
	country="U.S.A.",
	level=14,
	exp=1081,
	relics = {
	},
	tier_skill = {[120]=77, [130]=20, [140]=4, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 291,
	lifetime_jp = 0,
}

ECS.Players["wermi"] = {
	id=134276,
	isupper=false,
	country="Poland",
	level=17,
	exp=1491,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=5, [150]=2, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 23,
	lifetime_jp = 0,
}

ECS.Players["Lumi"] = {
	id=128187,
	isupper=false,
	country="U.S.A.",
	level=17,
	exp=1509,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=11, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 60,
	lifetime_jp = 0,
}

ECS.Players["Wormi"] = {
	id=76821,
	isupper=false,
	country="France",
	level=13,
	exp=866,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=10, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5,
	lifetime_jp = 0,
}

ECS.Players["Rebm88"] = {
	id=131955,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1476,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=5, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=7},
	lifetime_song_gold = 433,
	lifetime_jp = 0,
}

ECS.Players["Tarben"] = {
	id=84813,
	isupper=false,
	country="Canada",
	level=17,
	exp=1566,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=5, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 452,
	lifetime_jp = 0,
}

ECS.Players["RazonITG"] = {
	id=128809,
	isupper=false,
	country="Chile",
	level=13,
	exp=949,
	relics = {
	},
	tier_skill = {[120]=58, [130]=1, [140]=1, [150]=5, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 353,
	lifetime_jp = 0,
}

ECS.Players["KOUNT"] = {
	id=66795,
	isupper=false,
	country="U.S.A.",
	level=18,
	exp=1838,
	relics = {
		{name="Dirk",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=34, [140]=6, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 42,
	lifetime_jp = 0,
}

ECS.Players["akirasendou"] = {
	id=66681,
	isupper=false,
	country="Australia",
	level=14,
	exp=1024,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=7, [150]=1, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 16,
	lifetime_jp = 0,
}

ECS.Players["ZEBON"] = {
	id=128849,
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=898,
	relics = {
	},
	tier_skill = {[120]=57, [130]=1, [140]=1, [150]=7, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 320,
	lifetime_jp = 0,
}

ECS.Players["Rarily"] = {
	id=75846,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1428,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=10, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 54,
	lifetime_jp = 0,
}

ECS.Players["Paige"] = {
	id=52996,
	isupper=false,
	country="U.S.A.",
	level=15,
	exp=1207,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=5, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 642,
	lifetime_jp = 0,
}

ECS.Players["mute"] = {
	id=1232,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1351,
	relics = {
		{name="Dirk",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 633,
	lifetime_jp = 0,
}

ECS.Players["NaoHikari"] = {
	id=134767,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1321,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=2, rp=0, ap=0},
	lifetime_song_gold = 44,
	lifetime_jp = 0,
}

ECS.Players["hintz"] = {
	id=135228,
	isupper=false,
	country="U.S.A.",
	level=16,
	exp=1301,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=9, [140]=8, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 572,
	lifetime_jp = 0,
}

ECS.Players["LaplaceFox"] = {
	id=128847,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=635,
	relics = {
		{name="Stone Axe",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=10, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=1, ep=0, rp=0, ap=1},
	lifetime_song_gold = 272,
	lifetime_jp = 0,
}

ECS.Players["laoloser"] = {
	id=76012,
	isupper=false,
	country="U.S.A.",
	level=17,
	exp=1611,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=24, [140]=8, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 236,
	lifetime_jp = 0,
}

ECS.Players["moty"] = {
	id=131226,
	isupper=false,
	country="Spain",
	level=15,
	exp=1171,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=5, [150]=4, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 20,
	lifetime_jp = 0,
}

ECS.Players["Grievous Lad"] = {
	id=130989,
	isupper=false,
	country="Unspecified",
	level=12,
	exp=834,
	relics = {
	},
	tier_skill = {[120]=64, [130]=1, [140]=2, [150]=2, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 299,
	lifetime_jp = 0,
}

ECS.Players["chroma"] = {
	id=127868,
	isupper=false,
	country="U.S.A.",
	level=15,
	exp=1180,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=6, [150]=4, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 16,
	lifetime_jp = 0,
}

ECS.Players["Nurse_Joy"] = {
	id=131702,
	isupper=false,
	country="U.S.A.",
	level=15,
	exp=1167,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=3, ep=5, rp=0, ap=2},
	lifetime_song_gold = 45,
	lifetime_jp = 0,
}

ECS.Players["Sbuxsurg"] = {
	id=135709,
	isupper=false,
	country="U.S.A.",
	level=15,
	exp=1248,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 187,
	lifetime_jp = 0,
}

ECS.Players["ZOM"] = {
	id=128892,
	isupper=false,
	country="U.S.A.",
	level=14,
	exp=1070,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=11, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=4, ep=0, rp=0, ap=6},
	lifetime_song_gold = 493,
	lifetime_jp = 0,
}

ECS.Players["expandbanana"] = {
	id=103230,
	isupper=false,
	country="Canada",
	level=12,
	exp=832,
	relics = {
	},
	tier_skill = {[120]=1, [130]=14, [140]=1, [150]=5, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 118,
	lifetime_jp = 0,
}

ECS.Players["heatblaze"] = {
	id=128489,
	isupper=false,
	country="U.S.A.",
	level=12,
	exp=803,
	relics = {
		{name="Buster Sword",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=6, [140]=6, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 71,
	lifetime_jp = 0,
}

ECS.Players["arcwil"] = {
	id=6634,
	isupper=false,
	country="Canada",
	level=16,
	exp=1387,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 144,
	lifetime_jp = 0,
}

ECS.Players["ZarinahBBM"] = {
	id=134219,
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=971,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=5, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 252,
	lifetime_jp = 0,
}

ECS.Players["Dream"] = {
	id=49818,
	isupper=false,
	country="Unspecified",
	level=14,
	exp=981,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 435,
	lifetime_jp = 0,
}

ECS.Players["Dangerskew"] = {
	id=66790,
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=960,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 555,
	lifetime_jp = 0,
}

ECS.Players["Exschwasion"] = {
	id=128698,
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=906,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 233,
	lifetime_jp = 0,
}

ECS.Players["No-bar Ben"] = {
	id=130929,
	isupper=false,
	country="U.S.A.",
	level=12,
	exp=759,
	relics = {
		{name="Stone Blade",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=6, [140]=4, [150]=4, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 618,
	lifetime_jp = 0,
}

ECS.Players["YOSHI"] = {
	id=128949,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=715,
	relics = {
	},
	tier_skill = {[120]=42, [130]=9, [140]=6, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=2, rp=0, ap=2},
	lifetime_song_gold = 377,
	lifetime_jp = 0,
}

ECS.Players["Daikyi"] = {
	id=136928,
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=867,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 366,
	lifetime_jp = 0,
}

ECS.Players["sumikk0"] = {
	id=139333,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=703,
	relics = {
		{name="Tizona",	quantity=1},
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=9, [140]=5, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 419,
	lifetime_jp = 0,
}

ECS.Players["Ryzilen"] = {
	id=74194,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=511,
	relics = {
	},
	tier_skill = {[120]=23, [130]=1, [140]=1, [150]=1, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10,
	lifetime_jp = 0,
}

ECS.Players["Sega_JEANAsis"] = {
	id=129014,
	isupper=false,
	country="Colombia",
	level=12,
	exp=834,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=1, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 287,
	lifetime_jp = 0,
}

ECS.Players["SteakBeef"] = {
	id=134291,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=534,
	relics = {
		{name="Stone Knife",	quantity=1},
	},
	tier_skill = {[120]=20, [130]=1, [140]=4, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 207,
	lifetime_jp = 0,
}

ECS.Players["Wari"] = {
	id=127967,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=664,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=64, [130]=6, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 372,
	lifetime_jp = 0,
}

ECS.Players["inerzha"] = {
	id=66714,
	isupper=false,
	country="U.S.A.",
	level=12,
	exp=820,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=8, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 385,
	lifetime_jp = 0,
}

ECS.Players["JONBUDDY"] = {
	id=127823,
	isupper=false,
	country="U.S.A.",
	level=12,
	exp=758,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 323,
	lifetime_jp = 0,
}

ECS.Players["LilliePadd"] = {
	id=128390,
	isupper=false,
	country="Netherlands",
	level=11,
	exp=667,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["The_v Boab Oyedivuth"] = {
	id=75623,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=684,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=9, [140]=8, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4,
	lifetime_jp = 0,
}

ECS.Players["sp0kes"] = {
	id=66654,
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=880,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 76,
	lifetime_jp = 0,
}

ECS.Players["AiDev23"] = {
	id=127956,
	isupper=false,
	country="U.S.A.",
	level=12,
	exp=731,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 116,
	lifetime_jp = 0,
}

ECS.Players["nabinabiboi"] = {
	id=130553,
	isupper=false,
	country="U.S.A.",
	level=12,
	exp=731,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=1, rp=0, ap=0},
	lifetime_song_gold = 147,
	lifetime_jp = 0,
}

ECS.Players["nihilazo"] = {
	id=75730,
	isupper=false,
	country="United Kingdom",
	level=12,
	exp=731,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=7, rp=0, ap=0},
	lifetime_song_gold = 45,
	lifetime_jp = 0,
}

ECS.Players["nock"] = {
	id=128260,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=686,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 313,
	lifetime_jp = 0,
}

ECS.Players["addem"] = {
	id=129493,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=612,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=16, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 276,
	lifetime_jp = 0,
}

ECS.Players["InternalScreams"] = {
	id=131760,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=470,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=9, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 193,
	lifetime_jp = 0,
}

ECS.Players["DJPandaga"] = {
	id=134541,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=558,
	relics = {
	},
	tier_skill = {[120]=77, [130]=14, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10,
	lifetime_jp = 0,
}

ECS.Players["Yorupoko"] = {
	id=127974,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=453,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=9, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 201,
	lifetime_jp = 0,
}

ECS.Players["PCBoyGames"] = {
	id=66556,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=593,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=11, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 61,
	lifetime_jp = 0,
}

ECS.Players["Yserii"] = {
	id=128783,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=537,
	relics = {
		{name="Dire Kangaroo Patty",	quantity=1},
	},
	tier_skill = {[120]=77, [130]=10, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 45,
	lifetime_jp = 0,
}

ECS.Players["morozVSRG"] = {
	id=135431,
	isupper=false,
	country="U.S.A.",
	level=11,
	exp=677,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 99,
	lifetime_jp = 0,
}

ECS.Players["Xyzar"] = {
	id=128177,
	isupper=false,
	country="Sweden",
	level=6,
	exp=261,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=4, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["Chrizux"] = {
	id=128906,
	isupper=false,
	country="Finland",
	level=10,
	exp=563,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 14,
	lifetime_jp = 0,
}

ECS.Players["Illuzionz"] = {
	id=131612,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=575,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 229,
	lifetime_jp = 0,
}

ECS.Players["DC"] = {
	id=75620,
	isupper=false,
	country="Australia",
	level=7,
	exp=311,
	relics = {
	},
	tier_skill = {[120]=55, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 33,
	lifetime_jp = 0,
}

ECS.Players["asterism"] = {
	id=132443,
	isupper=false,
	country="U.S.A.",
	level=7,
	exp=293,
	relics = {
	},
	tier_skill = {[120]=44, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12,
	lifetime_jp = 0,
}

ECS.Players["quietly-turning"] = {
	id=52595,
	isupper=false,
	country="U.S.A.",
	level=6,
	exp=265,
	relics = {
	},
	tier_skill = {[120]=42, [130]=1, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 20,
	lifetime_jp = 0,
}

ECS.Players["NicholasNRG"] = {
	id=139329,
	isupper=false,
	country="U.S.A.",
	level=6,
	exp=229,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 176,
	lifetime_jp = 0,
}

ECS.Players["Tung"] = {
	id=127814,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=579,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=3, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 188,
	lifetime_jp = 0,
}

ECS.Players["Tristan97"] = {
	id=79488,
	isupper=false,
	country="U.S.A.",
	level=5,
	exp=199,
	relics = {
	},
	tier_skill = {[120]=79, [130]=1, [140]=3, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6,
	lifetime_jp = 0,
}

ECS.Players["xyhavix"] = {
	id=52382,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=497,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=1, ep=1, rp=1, ap=1},
	lifetime_song_gold = 329,
	lifetime_jp = 0,
}

ECS.Players["VEEBOT"] = {
	id=128785,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=497,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 186,
	lifetime_jp = 0,
}

ECS.Players["Eldrek"] = {
	id=128795,
	isupper=false,
	country="U.S.A.",
	level=10,
	exp=597,
	relics = {
		{name="Stone Knife",	quantity=1},
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 132,
	lifetime_jp = 0,
}

ECS.Players["Thumbsy"] = {
	id=131549,
	isupper=false,
	country="Netherlands",
	level=9,
	exp=497,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 195,
	lifetime_jp = 0,
}

ECS.Players["Samuelio"] = {
	id=132030,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=497,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 36,
	lifetime_jp = 0,
}

ECS.Players["zwarkestcher"] = {
	id=132878,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=497,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 25,
	lifetime_jp = 0,
}

ECS.Players["Pearly"] = {
	id=134186,
	isupper=false,
	country="France",
	level=9,
	exp=497,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 26,
	lifetime_jp = 0,
}

ECS.Players["@@ (RIP 9/2015)"] = {
	id=53075,
	isupper=false,
	country="U.S.A.",
	level=5,
	exp=186,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["JonSan89"] = {
	id=128255,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=434,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 233,
	lifetime_jp = 0,
}

ECS.Players["Dayr3on"] = {
	id=128474,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=452,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 219,
	lifetime_jp = 0,
}

ECS.Players["305STARS WhoDaFuhhh"] = {
	id=128962,
	isupper=false,
	country="U.S.A.",
	level=9,
	exp=432,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 283,
	lifetime_jp = 0,
}

ECS.Players["CHAN"] = {
	id=129063,
	isupper=false,
	country="U.S.A.",
	level=8,
	exp=406,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 177,
	lifetime_jp = 0,
}

ECS.Players["emi_roche"] = {
	id=80617,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=148,
	relics = {
	},
	tier_skill = {[120]=35, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 92,
	lifetime_jp = 0,
}

ECS.Players["fastboy"] = {
	id=118539,
	isupper=false,
	country="U.S.A.",
	level=8,
	exp=387,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 54,
	lifetime_jp = 0,
}

ECS.Players["Johnnyiidx"] = {
	id=127629,
	isupper=false,
	country="U.S.A.",
	level=8,
	exp=405,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=10, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=1},
	lifetime_song_gold = 109,
	lifetime_jp = 0,
}

ECS.Players["defekTiVE"] = {
	id=94191,
	isupper=false,
	country="U.S.A.",
	level=8,
	exp=387,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 77,
	lifetime_jp = 0,
}

ECS.Players["kaosddr"] = {
	id=134350,
	isupper=false,
	country="U.S.A.",
	level=8,
	exp=417,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 172,
	lifetime_jp = 0,
}

ECS.Players["bhyper573"] = {
	id=133661,
	isupper=false,
	country="U.S.A.",
	level=7,
	exp=341,
	relics = {
		{name="Stone Knife",	quantity=1},
	},
	tier_skill = {[120]=79, [130]=7, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 116,
	lifetime_jp = 0,
}

ECS.Players["SawBo"] = {
	id=136228,
	isupper=false,
	country="U.S.A.",
	level=8,
	exp=355,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=7, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 25,
	lifetime_jp = 0,
}

ECS.Players["GenesisRapshodos"] = {
	id=66380,
	isupper=false,
	country="Colombia",
	level=7,
	exp=322,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=9, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 209,
	lifetime_jp = 0,
}

ECS.Players["sh_ggy"] = {
	id=73715,
	isupper=false,
	country="Australia",
	level=3,
	exp=90,
	relics = {
	},
	tier_skill = {[120]=42, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2,
	lifetime_jp = 0,
}

ECS.Players["choppyblue"] = {
	id=132441,
	isupper=false,
	country="Canada",
	level=6,
	exp=252,
	relics = {
	},
	tier_skill = {[120]=55, [130]=9, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 56,
	lifetime_jp = 0,
}

ECS.Players["Goatgarien"] = {
	id=139180,
	isupper=false,
	country="U.S.A.",
	level=6,
	exp=235,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 56,
	lifetime_jp = 0,
}

ECS.Players["DaveGS"] = {
	id=66637,
	isupper=false,
	country="U.S.A.",
	level=6,
	exp=223,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 71,
	lifetime_jp = 0,
}

ECS.Players["makisoba"] = {
	id=128848,
	isupper=false,
	country="U.S.A.",
	level=7,
	exp=282,
	relics = {
	},
	tier_skill = {[120]=64, [130]=7, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 138,
	lifetime_jp = 0,
}

ECS.Players["Coneja"] = {
	id=128890,
	isupper=false,
	country="Chile",
	level=7,
	exp=289,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=6, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 107,
	lifetime_jp = 0,
}

ECS.Players["ONE27"] = {
	id=131712,
	isupper=false,
	country="U.S.A.",
	level=5,
	exp=167,
	relics = {
	},
	tier_skill = {[120]=77, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 107,
	lifetime_jp = 0,
}

ECS.Players["Penguinfreek5"] = {
	id=75631,
	isupper=false,
	country="U.S.A.",
	level=2,
	exp=42,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 44,
	lifetime_jp = 0,
}

ECS.Players["Silver Fox"] = {
	id=124527,
	isupper=false,
	country="Unspecified",
	level=6,
	exp=253,
	relics = {
	},
	tier_skill = {[120]=77, [130]=6, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 214,
	lifetime_jp = 0,
}

ECS.Players["Thebadin"] = {
	id=134396,
	isupper=false,
	country="U.S.A.",
	level=7,
	exp=316,
	relics = {
	},
	tier_skill = {[120]=77, [130]=6, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["al!ce"] = {
	id=66646,
	isupper=false,
	country="United Kingdom",
	level=5,
	exp=168,
	relics = {
	},
	tier_skill = {[120]=77, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 39,
	lifetime_jp = 0,
}

ECS.Players["OverKlockD"] = {
	id=66737,
	isupper=false,
	country="Australia",
	level=5,
	exp=188,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 45,
	lifetime_jp = 0,
}

ECS.Players["305STARS Zulrah"] = {
	id=129033,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=160,
	relics = {
		{name="Tizona",	quantity=1},
	},
	tier_skill = {[120]=99, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 94,
	lifetime_jp = 0,
}

ECS.Players["Nypholis"] = {
	id=66493,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=140,
	relics = {
	},
	tier_skill = {[120]=64, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 57,
	lifetime_jp = 0,
}

ECS.Players["Azeria"] = {
	id=80626,
	isupper=false,
	country="Canada",
	level=4,
	exp=129,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2,
	lifetime_jp = 0,
}

ECS.Players["Akihiro"] = {
	id=61362,
	isupper=false,
	country="France",
	level=5,
	exp=191,
	relics = {
	},
	tier_skill = {[120]=77, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8,
	lifetime_jp = 0,
}

ECS.Players["Wastum"] = {
	id=8011,
	isupper=false,
	country="Netherlands",
	level=3,
	exp=100,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 71,
	lifetime_jp = 0,
}

ECS.Players["Cecilia"] = {
	id=78050,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=100,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 27,
	lifetime_jp = 0,
}

ECS.Players["stankyblt"] = {
	id=128215,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=100,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7,
	lifetime_jp = 0,
}

ECS.Players["tertu"] = {
	id=128319,
	isupper=false,
	country="U.S.A.",
	level=5,
	exp=190,
	relics = {
	},
	tier_skill = {[120]=64, [130]=4, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8,
	lifetime_jp = 0,
}

ECS.Players["Anfesave"] = {
	id=116344,
	isupper=false,
	country="Chile",
	level=5,
	exp=166,
	relics = {
	},
	tier_skill = {[120]=77, [130]=3, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 42,
	lifetime_jp = 0,
}

ECS.Players["markletron"] = {
	id=128960,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=86,
	relics = {
	},
	tier_skill = {[120]=57, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 45,
	lifetime_jp = 0,
}

ECS.Players["rogerclark"] = {
	id=193,
	isupper=false,
	country="Unspecified",
	level=5,
	exp=170,
	relics = {
	},
	tier_skill = {[120]=20, [130]=7, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 71,
	lifetime_jp = 0,
}

ECS.Players["ItachiX3"] = {
	id=131134,
	isupper=false,
	country="Chile",
	level=3,
	exp=100,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 49,
	lifetime_jp = 0,
}

ECS.Players["soler98012"] = {
	id=109985,
	isupper=false,
	country="Spain",
	level=5,
	exp=202,
	relics = {
	},
	tier_skill = {[120]=64, [130]=6, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12,
	lifetime_jp = 0,
}

ECS.Players["Catoxis"] = {
	id=66634,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=100,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 25,
	lifetime_jp = 0,
}

ECS.Players["Kotairo"] = {
	id=132873,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=86,
	relics = {
	},
	tier_skill = {[120]=57, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 43,
	lifetime_jp = 0,
}

ECS.Players["Arkitev"] = {
	id=132162,
	isupper=false,
	country="Poland",
	level=4,
	exp=123,
	relics = {
	},
	tier_skill = {[120]=58, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 29,
	lifetime_jp = 0,
}

ECS.Players["Fen1more"] = {
	id=78919,
	isupper=false,
	country="Russian Federation",
	level=3,
	exp=100,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12,
	lifetime_jp = 0,
}

ECS.Players["Largah"] = {
	id=89945,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=102,
	relics = {
	},
	tier_skill = {[120]=77, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 20,
	lifetime_jp = 0,
}

ECS.Players["RAKKII-san"] = {
	id=127813,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=73,
	relics = {
	},
	tier_skill = {[120]=64, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 38,
	lifetime_jp = 0,
}

ECS.Players["tsubasa kazanari"] = {
	id=127835,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=89,
	relics = {
	},
	tier_skill = {[120]=35, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 23,
	lifetime_jp = 0,
}

ECS.Players["ARedHat"] = {
	id=80833,
	isupper=false,
	country="U.S.A.",
	level=2,
	exp=61,
	relics = {
	},
	tier_skill = {[120]=35, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Oryan"] = {
	id=229,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=148,
	relics = {
	},
	tier_skill = {[120]=20, [130]=4, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 134,
	lifetime_jp = 0,
}

ECS.Players["dobster"] = {
	id=128792,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=128,
	relics = {
	},
	tier_skill = {[120]=42, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 27,
	lifetime_jp = 0,
}

ECS.Players["FruityEnLoops"] = {
	id=67221,
	isupper=false,
	country="France",
	level=3,
	exp=75,
	relics = {
	},
	tier_skill = {[120]=55, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7,
	lifetime_jp = 0,
}

ECS.Players["Yaboitrix"] = {
	id=132048,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=125,
	relics = {
	},
	tier_skill = {[120]=35, [130]=3, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 44,
	lifetime_jp = 0,
}

ECS.Players["Ch1ppy"] = {
	id=108650,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=75,
	relics = {
	},
	tier_skill = {[120]=55, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8,
	lifetime_jp = 0,
}

ECS.Players["Phrozenwun"] = {
	id=133428,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=75,
	relics = {
	},
	tier_skill = {[120]=55, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Muddybanks90"] = {
	id=5030,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=149,
	relics = {
	},
	tier_skill = {[120]=42, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 72,
	lifetime_jp = 0,
}

ECS.Players["Viper"] = {
	id=133783,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=117,
	relics = {
	},
	tier_skill = {[120]=23, [130]=3, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 107,
	lifetime_jp = 0,
}

ECS.Players["KeepItSimple"] = {
	id=135479,
	isupper=false,
	country="Unspecified",
	level=2,
	exp=61,
	relics = {
	},
	tier_skill = {[120]=35, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 38,
	lifetime_jp = 0,
}

ECS.Players["JohnnyPlease"] = {
	id=133503,
	isupper=false,
	country="U.S.A.",
	level=3,
	exp=75,
	relics = {
	},
	tier_skill = {[120]=55, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["RizGod"] = {
	id=114726,
	isupper=false,
	country="U.S.A.",
	level=1,
	exp=25,
	relics = {
	},
	tier_skill = {[120]=22, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["SLIME52353"] = {
	id=130255,
	isupper=false,
	country="Japan",
	level=2,
	exp=39,
	relics = {
	},
	tier_skill = {[120]=42, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["TheBrightest"] = {
	id=132074,
	isupper=false,
	country="U.S.A.",
	level=2,
	exp=36,
	relics = {
	},
	tier_skill = {[120]=23, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 44,
	lifetime_jp = 0,
}

ECS.Players["rhythmoid"] = {
	id=132458,
	isupper=false,
	country="U.S.A.",
	level=2,
	exp=41,
	relics = {
	},
	tier_skill = {[120]=42, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 41,
	lifetime_jp = 0,
}

ECS.Players["silentblackcat"] = {
	id=133533,
	isupper=false,
	country="Unspecified",
	level=2,
	exp=48,
	relics = {
	},
	tier_skill = {[120]=42, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["hong10"] = {
	id=136103,
	isupper=false,
	country="Japan",
	level=2,
	exp=39,
	relics = {
	},
	tier_skill = {[120]=42, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["NOVA_"] = {
	id=138699,
	isupper=false,
	country="U.S.A.",
	level=4,
	exp=115,
	relics = {
	},
	tier_skill = {[120]=20, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 50,
	lifetime_jp = 0,
}

InitializeECS()


-- -----------------------------------------------------------------------
-- Helper Functions

-- Determines if the current loaded player is in Upper division or not.
PlayerIsUpper = function()
	local mpn = GAMESTATE:GetMasterPlayerNumber()
	local profile_name = PROFILEMAN:GetPlayerName(mpn)
	if profile_name and ECS.Players[profile_name] and ECS.Players[profile_name].isupper ~= nil then
		return ECS.Players[profile_name].isupper
	end
	return nil
end

-- ------------------------------------------------------
-- Score Calculations

FindEcsSong = function(song_name, SongInfo)
	for data in ivalues(SongInfo.Songs) do
		if data.name == song_name then
			return data
		end
	end
	return nil
end

CalculateScoreForSong = function(ecs_player, song_name, score, relics_used, failed)
	if ecs_player == nil then SM("NO ECS PLAYER") return 0,nil end
	if song_name == nil then SM("NO SONG NAME") return 0,nil end
	if score == nil then SM("NO SCORE") return 0,nil end
	if relics_used == nil then SM("NO RELICS USED") return 0,nil end
	if failed == nil then SM("NO FAILED") return 0,nil end

	local AP = function(score)
		return math.ceil((score^4) * 1000)
	end

	local BP = function(ecs_player, song_info, song_data, relics_used, ap)
		local bp = 0
		-- Handle relics first
		for relic in ivalues(relics_used) do
			if relic.name ~= "(nothing)" then
				bp = bp + relic.score(ecs_player, song_info, song_data, relics_used, ap)
			end
		end

		-- Then affinities
		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
		bp = bp + math.floor((ecs_player.affinities.dp/2000)*dp +
						 (ecs_player.affinities.ep/2000)*ep +
						 (ecs_player.affinities.ap/2000)*ap +
						 (rp/(max_division_rp/1000)*(ecs_player.affinities.rp/2000)))
		return bp
	end

	local FailedScore = function(ecs_player, song_data, song_info, score)
		local tier_skill = ecs_player.tier_skill[song_data.bpm_tier]
		if not tier_skill then tier_skill = 1 end

		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local ap = AP(score)

		if song_data.length < 8 then
			return math.floor(((dp + ep + rp + ap) * (tier_skill / 99) * score) * ((song_data.length - song_info.MinLength + 0.1) / ( 8 - (song_info.MinLength))))
		else
			return math.floor((dp + ep + rp + ap) * (tier_skill / 99) * score)
		end
	end

	local song_info = PlayerIsUpper() and ECS.SongInfo.Upper or ECS.SongInfo.Lower
	local song_data = FindEcsSong(song_name, song_info)
	if song_data == nil then return 0, nil end

	if failed then
		return FailedScore(ecs_player, song_data, song_info, score), song_data
	else
		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local ap = AP(score)
		local bp = BP(ecs_player, song_info, song_data, relics_used, ap)
		return (dp + ep + rp + ap + bp), song_data
	end

	return 0, song_data
end

AddPlayedSong = function(ecs_player, song_name, score, relics_used, failed)
	local points, song_data = CalculateScoreForSong(ecs_player, song_name, score, relics_used, failed)
	if song_data == nil then return end

	local index = #ECS.Player.SongsPlayed + 1
	for i=1,#ECS.Player.SongsPlayed do
		if ECS.Player.SongsPlayed[i].name == song_name then
			if points > ECS.Player.SongsPlayed[i].points then
				index = i
			end
		end
	end

	ECS.Player.SongsPlayed[index] = {
		name=song_data.name,
		points=points,
		steps=song_data.steps,
		bpm=song_data.bpm,
		bpm_tier=song_data.bpm_tier,
		failed=failed,
	}
	local SortByPointsDesc = function(a, b)
		return a.points > b.points
	end

	table.sort(ECS.Player.SongsPlayed, SortByPointsDesc)
end
