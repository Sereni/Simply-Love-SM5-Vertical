import csv


# Print Relics
print("""ECS.Relics = {""")

with open('relics.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		print(r"""	{""")
		print(r"""		id=%s,""" % row['id'])
		print(r"""		name="%s",""" % row["name"])
		print(r"""		desc="%s",""" % row["description"])
		print(r"""		effect="%s",""" % row["properties"])
		print(r"""		is_consumable=%s,""" % ("false" if row["consumable"] == "0" else "true"))
		print(r"""		is_marathon=%s,""" % ("false" if row["portion"] == "0" else "true"))
		print(r"""		img="%s",""" % row["imageurl"])
		print(r"""		action=function() end,""")
		print(r"""		score=function(ecs_player, song_data, relics_used, dp, ep, rp, ap) end,""")
		print(r"""	},""")
print(r"""}""") 
