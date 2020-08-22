ECS = {}

-- call this to (re)initialize per-player settings
InitializeECS = function()
	ECS.Mode = "Warmup"
	ECS.BreakTimer=(13 * 60)

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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_bow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap) 
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_bow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_bow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.Competitive.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.Competitive.TimingWindowSecondsW3)
			end
		end,
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		--TODO(teejusb)
		end,
		score=function(ecs_player, song_data, relics_used, ap)
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
			-- TODO(teejusb): Handle MP
			return 0
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
		score=function(ecs_player, song_data, relics_used, ap)
			-- Determine Rank 1 gold by checking every player
			local all_gold_amounts = {}
			for name, player in ECS.Players do
				all_gold_amounts[#all_gold_amounts + 1] = ecs_player.lifetime_song_gold
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_bow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_arrow = false
			for _, relic in relics_used do
				local name = relic.name
				if (name == "Stone Arrow" or name == "Bronze Arrow" or name == "Mythril Arrow") then
					has_arrow = true
				end
			end
			if has_arrow then
				-- TODO(teejusb): need max rp for division or max block level for division
				return math.floor(song_data.rp/(max_rp_for_division/1000)*0.5)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			-- Determine Rank 1 JP by checking every player
			local all_jp_amounts = {}
			for name, player in ECS.Players do
				all_jp_amounts[#all_jp_amounts + 1] = ecs_player.lifetime_jp
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_arrow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_laevitas = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_arrow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 250 then
				bp = bp + 100
			end
			bp = bp + math.floor(song_data.ep * 0.5)
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_leavitas = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local has_arrow = false
			for _, relic in relics_used do
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			local bp = 0
			if song_data.bpm_tier == 250 then
				bp = bp + 200
			end
			bp = bp + math.floor(song_data.ep * 0.5)
			for _, relic in relics_used do
				local name = relic.name
				if name == "Gae Buide" then
					bp = bp + math.floor(song_data.rp * 0.1)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			return 200 + math.floor(song_data.rp * 0.4)
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
		score=function(ecs_player, song_data, relics_used, ap)
			if song_data.pack:lower():find("baguettestreamz") ~= nil or song_data.pack:lower():find("french coast stamina") then
				return math.floor(song_data.rp * 0.4)
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap)
			return math.floor(song_data.ep * 0.1) + math.floor(song_data.dp * 0.1) + math.floor(song_data.rp * 0.1) + math.floor(ap * 0.1)
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			return math.floor(rp * 0.6)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
			-- TODO(teejusb): Handle MP
			return 0
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.Competitive.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.Competitive.TimingWindowSecondsW3)
			end
		end,
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap)
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		--TODO(teejusb)
		end,
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap)
			-- Determine Rank 1 EXP by checking every player
			local all_exp_amounts = {}
			for name, player in ECS.Players do
				all_exp_amounts[#all_exp_amounts + 1] = ecs_player.exp
			end
			table.sort(all_exp_amounts)

			local max_exp = all_exp_amounts[#all_exp_amounts]
			if max_exp == nil then return 0 end

			-- We need the 2nd highest as well for those that weren't rank 1
			local second_highest = nil
			for i = #all_exp_amounts, 1, -1 do
				if all_exp_amounts[i] < max_exp then
					second_highest = all_exp_amounts[i]
					break
				end
			end

			if max_exp == ecs_player.exp then
				return 600
			else
				local second_highest = all_exp_amounts[#all_exp_amounts-1]
				if second_highest == nil then return 0 end
				return math.floor(400*(ecs_player.exp / second_highest))
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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
		score=function(ecs_player, song_data, relics_used, ap)
			return math.floor(rp * 0.6)
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
		score=function(ecs_player, song_data, relics_used, ap) return 0 end
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

ECS.Players["Rust"] = {
	isupper=true,
	country="U.S.A.",
	level=100,
	exp=4501575,
	relics = {},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["teejusb"] = {
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=90,
	relics = {
		{name="GUNgnir",	quantity=1},
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
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

local CalculateScoreForSong = function(ecs_player, song_name, score, relics_used, failed)
	if ecs_player == nil then SM("NO ECS PLAYER") return 0,nil end
	if song_name == nil then SM("NO SONG NAME") return 0,nil end
	if score == nil then SM("NO SCORE") return 0,nil end
	if relics_used == nil then SM("NO RELICS USED") return 0,nil end
	if failed == nil then SM("NO FAILED") return 0,nil end

	local AP = function(score)
		return math.ceil((score^4) * 1000)
	end

	local BP = function(ecs_player, song_data, relics_used, ap, song_info)
		local bp = 0
		-- Handle relics first
		for relic in ivalues(relics_used) do
			bp = bp + relic.score(ecs_player, song_data, relics_used, ap)()
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
			return ((dp + ep + rp + ap) * (tier_skill / 99) * score) * ((song_data.length - song_info.MinLength + 0.1) / ( 8 - (song_info.MinLength)))
		else
			return (dp + ep + rp + ap) * (tier_skill / 99) * score
		end
	end

	local song_info = PlayerIsUpper() and ECS.SongInfo.Upper or ECS.SongInfo.Lower
	local song_data = FindEcsSong(song_name, song_info)
	if song_data == nil then return 0, nil end

	if failed then
		return FailedScore(ecs_player, song_data, song_info, score)
	else
		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local ap = AP(score)
		local bp = BP(ecs_player, song_data, relics_used, ap, song_info)
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
			if score > ECS.Player.SongsPlayed[i].score then
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