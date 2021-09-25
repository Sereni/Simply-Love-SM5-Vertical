import csv

for tier in ["Lower", "Mid", "Upper"]:
	# Song Info
	print(r"""ECS.SongInfo.%s = {""" % tier)
	print(r"""	-- These values will be calculated and set below.""")
	print(r"""	MinBpm = 0,""")
	print(r"""	MaxBpm = 0,""")
	print(r"""	MinScaled16ths = 0,""")
	print(r"""	MaxScaled16ths = 0,""")
	print(r"""	MinBlockLevel = 0,""")
	print(r"""	MaxBlockLevel = 0,""")
	print(r"""	MinLength = 0,""")
	print(r"""	Songs = {""")
	with open('%ssongs.csv' % tier.lower()) as f:
		reader = csv.DictReader(f)
		for row in reader:
			print(r"""		{""")
			print(r"""			id=%s,""" % row['ID'])
			print(r"""			name="[%s] [%s] %s",""" % (row["Rating"], row["BPM"], row["Song"]))
			print(r"""			stepartist="%s",""" % row["Stepartist"])
			print(r"""			pack="%s",""" % row["Pack"])
			print(r"""			difficulty=%s,""" % row["Rating"])
			print(r"""			steps=%s,""" % row["Steps"])
			print(r"""			bpm_tier=%s,""" % row["Tier"])
			print(r"""			measures=%s,""" % row["16ths"])
			print(r"""			adj_stream=%s,""" % row["Adj. % Stream"])
			print(r"""			bpm=%s,""" % row["BPM"])
			print(r"""			length=%s,""" % row["Length"])
			print(r"""			dp=%s, ep=%s, dp_ep=%s, rp=%s,""" % (row["DP"], row["EP"], row["DP/EP"], row["RP"]))
			print(r"""		},""")
	print(r"""	}""")
	print(r"""}""")
	print(r"""""")
