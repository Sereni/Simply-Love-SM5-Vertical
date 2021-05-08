-- This script needs to be loaded before other scripts that use it.

local PlayerDefaults = {
	__index = {
		initialize = function(self)
			self.ActiveModifiers = {
				SpeedModType = "X",
				SpeedMod = 1.00,
				JudgmentGraphic = "Love 2x6.png",
				ComboFont = "Wendy",
				HoldJudgment = "Love 1x2.png",
				NoteSkin = nil,
				Mini = "0%",
				BackgroundFilter = "Off",

				HideTargets = false,
				HideSongBG = false,
				HideCombo = false,
				HideLifebar = false,
				HideScore = false,
				HideDanger = false,
				HideComboExplosions = false,

				ColumnFlashOnMiss = false,
				SubtractiveScoring = false,
				MeasureCounter = "None",
				MeasureCounterLeft = true,
				MeasureCounterUp = false,
				TargetScore = 11,
				ActionOnMissedTarget = "Nothing",
				Pacemaker = false,
				LifeMeterType = "Standard",
				MissBecauseHeld = false,
				NPSGraphAtTop = false,
				DoNotJudgeMe = false,
			}
			self.Streams = {
				SongDir = nil,
				StepsType = nil,
				Difficulty = nil,
				Measures = nil,
			}
			self.HighScores = {
				EnteringName = false,
				Name = ""
			}
			self.Stages = {
				Stats = {}
			}
			self.PlayerOptionsString = nil
			-- The Groovestats API key loaded for this player
			self.ApiKey = ""
		end
	}
}

local GlobalDefaults = {
	__index = {

		-- since the initialize() function is called every game cycle, the idea
		-- is to define variables we want to reset every game cycle inside
		initialize = function(self)
			self.ActiveModifiers = {
				MusicRate = 1.0,
				TimingWindows = {true, true, true, true, true},
				GlobalOffsetDelta = 0,
			}
			self.Stages = {
				PlayedThisGame = 0,
				Remaining = PREFSMAN:GetPreference("SongsPerPlay"),
				Stats = {}
			}
			self.ScreenAfter = {
				PlayAgain = "ScreenEvaluationSummary",
				PlayerOptions  = "ScreenGameplay",
				PlayerOptions2 = "ScreenGameplay",
			}
			self.ContinuesRemaining = ThemePrefs.Get("NumberOfContinuesAllowed") or 0
			self.GameMode = ThemePrefs.Get("DefaultGameMode") or "ITG"
			self.ScreenshotTexture = nil
			self.MenuTimer = {
				ScreenSelectMusic = ThemePrefs.Get("ScreenSelectMusicMenuTimer"),
				ScreenPlayerOptions = ThemePrefs.Get("ScreenPlayerOptionsMenuTimer"),
				ScreenEvaluation = ThemePrefs.Get("ScreenEvaluationMenuTimer"),
				ScreenEvaluationSummary = ThemePrefs.Get("ScreenEvaluationSummaryMenuTimer"),
				ScreenNameEntry = ThemePrefs.Get("ScreenNameEntryMenuTimer"),
			}
			self.TimeAtSessionStart = nil

			self.GameplayReloadCheck = false
		end,

		-- These values outside initialize() won't be reset each game cycle,
		-- but are rather manipulated as needed by the theme.
		ActiveColorIndex = ThemePrefs.Get("SimplyLoveColor") or 1,
		-- Default Global Offset. Restore this value before every credit, to reset
		-- the temporary offset chosen via Advanced Options.
		DefaultGlobalOffsetSeconds = ThemePrefs.Get("DefaultGlobalOffsetSeconds")
	}
}

-- "SL" is a general-purpose table that can be accessed from anywhere
-- within the theme and stores info that needs to be passed between screens
SL = {
	P1 = setmetatable( {}, PlayerDefaults),
	P2 = setmetatable( {}, PlayerDefaults),
	Global = setmetatable( {}, GlobalDefaults),

	-- Colors that Simply Love's background can be
	-- These colors are used for text on dark backgrounds and backgrounds containing dark text:
	Colors = {
		"#FF5D47",
		"#FF577E",
		"#FF47B3",
		"#DD57FF",
		"#8885ff",
		"#3D94FF",
		"#00B8CC",
		"#5CE087",
		"#AEFA44",
		"#FFFF00",
		"#FFBE00",
		"#FF7D00",
	},
	-- These are the original SL colors. They're used for decorative (non-text) elements, like the background hearts:
	DecorativeColors = {
		"#FF3C23",
		"#FF003C",
		"#C1006F",
		"#8200A1",
		"#413AD0",
		"#0073FF",
		"#00ADC0",
		"#5CE087",
		"#AEFA44",
		"#FFFF00",
		"#FFBE00",
		"#FF7D00"
	},
	-- These judgment colors are used for text & numbers on dark backgrounds:
	JudgmentColors = {
		ITG = {
			color("#21CCE8"),	-- blue
			color("#e29c18"),	-- gold
			color("#66c955"),	-- green
			color("#b45cff"),	-- purple (greatly lightened)
			color("#c9855e"),	-- peach?
			color("#ff3030")	-- red (slightly lightened)
		},
		["FA+"] = {
			color("#21CCE8"),	-- blue
			color("#ffffff"),	-- white
			color("#e29c18"),	-- gold
			color("#66c955"),	-- green
			color("#b45cff"),	-- purple (greatly lightened)
			color("#ff3030")	-- red (slightly lightened)
		},
		ECFA = {
                        color("#FF00BE"),       -- fuschia
                        color("#FFFF00"),       -- yellow
                        color("#00c800"),       -- green
                        color("#0080FF"),       -- blue
                        color("#808080"),       -- gray
                        color("#ff3030")        -- red (slightly lightened)
                },
	},
	Preferences = {
		ITG = {
			TimingWindowAdd=0.0015,
			RegenComboAfterMiss=5,
			MaxRegenComboAfterMiss=10,
			MinTNSToHideNotes="TapNoteScore_W3",
			HarshHotLifePenalty=true,

			PercentageScoring=true,
			AllowW1="AllowW1_Everywhere",
			SubSortByNumSteps=true,

			TimingWindowSecondsW1=0.021500,
			TimingWindowSecondsW2=0.043000,
			TimingWindowSecondsW3=0.102000,
			TimingWindowSecondsW4=0.135000,
			TimingWindowSecondsW5=0.180000,
			TimingWindowSecondsHold=0.320000,
			TimingWindowSecondsMine=0.070000,
			TimingWindowSecondsRoll=0.350000,
		},
		["FA+"] = {
			TimingWindowAdd=0.0015,
			RegenComboAfterMiss=5,
			MaxRegenComboAfterMiss=10,
			MinTNSToHideNotes="TapNoteScore_W4",
			HarshHotLifePenalty=true,

			PercentageScoring=true,
			AllowW1="AllowW1_Everywhere",
			SubSortByNumSteps=true,

			TimingWindowSecondsW1=0.011000,
			TimingWindowSecondsW2=0.021500,
			TimingWindowSecondsW3=0.043000,
			TimingWindowSecondsW4=0.102000,
			TimingWindowSecondsW5=0.135000,
			TimingWindowSecondsHold=0.320000,
			TimingWindowSecondsMine=0.065000,
			TimingWindowSecondsRoll=0.350000,
		},
		ECFA = {
                        TimingWindowAdd=0.0000,
                        TimingWindowScale=1,
                        RegenComboAfterMiss=5,
                        MaxRegenComboAfterMiss=5,
                        MinTNSToHideNotes="TapNoteScore_W4",
                        HarshHotLifePenalty=0,

                        PercentageScoring=1,
                        AllowW1="AllowW1_Everywhere",
                        SubSortByNumSteps=1,

                        TimingWindowSecondsW1=0.015000,
                        TimingWindowSecondsW2=0.03000,
                        TimingWindowSecondsW3=0.050000,
                        TimingWindowSecondsW4=0.100000,
                        TimingWindowSecondsW5=0.160000,
                        TimingWindowSecondsHold=0.300000,
                        TimingWindowSecondsMine=0.050000,
                        TimingWindowSecondsRoll=0.350000,
                }
	},
	Metrics = {
		ITG = {
			PercentScoreWeightW1=5,
			PercentScoreWeightW2=4,
			PercentScoreWeightW3=2,
			PercentScoreWeightW4=0,
			PercentScoreWeightW5=-6,
			PercentScoreWeightMiss=-12,
			PercentScoreWeightLetGo=0,
			PercentScoreWeightHeld=5,
			PercentScoreWeightHitMine=-6,

			GradeWeightW1=5,
			GradeWeightW2=4,
			GradeWeightW3=2,
			GradeWeightW4=0,
			GradeWeightW5=-6,
			GradeWeightMiss=-12,
			GradeWeightLetGo=0,
			GradeWeightHeld=5,
			GradeWeightHitMine=-6,

			LifePercentChangeW1=0.008,
			LifePercentChangeW2=0.008,
			LifePercentChangeW3=0.004,
			LifePercentChangeW4=0.000,
			LifePercentChangeW5=-0.050,
			LifePercentChangeMiss=-0.100,
			LifePercentChangeLetGo=IsGame("pump") and 0.000 or -0.080,
			LifePercentChangeHeld=IsGame("pump") and 0.000 or 0.008,
			LifePercentChangeHitMine=-0.050,
		},
		["FA+"] = {
			PercentScoreWeightW1=5,
			PercentScoreWeightW2=5,
			PercentScoreWeightW3=4,
			PercentScoreWeightW4=2,
			PercentScoreWeightW5=0,
			PercentScoreWeightMiss=-12,
			PercentScoreWeightLetGo=0,
			PercentScoreWeightHeld=5,
			PercentScoreWeightHitMine=-6,

			GradeWeightW1=5,
			GradeWeightW2=5,
			GradeWeightW3=4,
			GradeWeightW4=2,
			GradeWeightW5=0,
			GradeWeightMiss=-12,
			GradeWeightLetGo=0,
			GradeWeightHeld=5,
			GradeWeightHitMine=-6,

			LifePercentChangeW1=0.008,
			LifePercentChangeW2=0.008,
			LifePercentChangeW3=0.008,
			LifePercentChangeW4=0.004,
			LifePercentChangeW5=0,
			LifePercentChangeMiss=-0.1,
			LifePercentChangeLetGo=-0.08,
			LifePercentChangeHeld=0.008,
			LifePercentChangeHitMine=-0.05,
		},
		ECFA = {
                        PercentScoreWeightW1=10,
                        PercentScoreWeightW2=9,
                        PercentScoreWeightW3=6,
                        PercentScoreWeightW4=3,
                        PercentScoreWeightW5=0,
                        PercentScoreWeightMiss=0,
                        PercentScoreWeightLetGo=0,
                        PercentScoreWeightHeld=6,
                        PercentScoreWeightHitMine=-3,

                        GradeWeightW1=10,
                        GradeWeightW2=9,
                        GradeWeightW3=6,
                        GradeWeightW4=3,
                        GradeWeightW5=0,
                        GradeWeightMiss=0,
                        GradeWeightLetGo=0,
                        GradeWeightHeld=6,
                        GradeWeightHitMine=-3,

                        LifePercentChangeW1=0.010,
                        LifePercentChangeW2=0.010,
                        LifePercentChangeW3=0.010,
                        LifePercentChangeW4=0.005,
                        LifePercentChangeW5=-0.050,
                        LifePercentChangeMiss=-0.1,
                        LifePercentChangeLetGo=-0.1,
                        LifePercentChangeHeld=0.010,
                        LifePercentChangeHitMine=-0.05,
                },
	},

	-- Fields used to determine the existence of the launcher and the
	-- available GrooveStats services.
	GrooveStats = {
		-- Whether we're launching StepMania with a launcher.
		-- Determined once on boot in ScreenSystemLayer.
		Launcher = false,

		-- Available GrooveStats services. Subject to change while
		-- StepMania is running.
		GetScores = false,
		Leaderboard = false,
		AutoSubmit = false,

		-- ************* CURRENT QR VERSION *************
		-- * Update whenever we change relevant QR code *
		-- *  and when GrooveStats backend is also      *
		-- *   updated to properly consume this value.  *
		-- **********************************************
		ChartHashVersion = 3
	}
}


-- Initialize preferences by calling this method.  We typically do
-- this from ./BGAnimations/ScreenTitleMenu underlay/default.lua
-- so that preferences reset between each game cycle.

function InitializeSimplyLove()
	SL.P1:initialize()
	SL.P2:initialize()
	SL.Global:initialize()

	-- - - - - - - - - - - - - - - - - - - - -
	-- Reset global offset to a pre-stored value.
	if string.format("%.3f", SL.Global.DefaultGlobalOffsetSeconds) ~= string.format("%.3f", PREFSMAN:GetPreference("GlobalOffsetSeconds")) then
		PREFSMAN:SetPreference("GlobalOffsetSeconds", SL.Global.DefaultGlobalOffsetSeconds)
		SM("Offset has been reset to machine standard. (".. string.format("%.3f" ,PREFSMAN:GetPreference("GlobalOffsetSeconds")) .. ")")
	end
end

InitializeSimplyLove()
