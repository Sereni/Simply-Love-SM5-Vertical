import csv
import json

def GetDivision(rank):
	mid_overrides = [127780, 132032, 76070, 66545, 7737, 66724]
	upper_overrides = [35619, 66546]

	if rank in mid_overrides:
		return "mid"
	elif rank in upper_overrides:
		return "upper"
	else:
		if rank <= 12:
			return "upper"
		elif rank <= 64:
			return "mid"
		else:
			return "lower"


relics = {}
with open('relics.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		relics[row["id"]] = row["name"]

with open("sqldump.json") as f:
	data = json.load(f)

for player in data:
	print(r"""ECS.Players["%s"] = {""" % player["members_name"])
	print(r"""	id=%s,""" % player["srpg5_entrants_member_id"])
	print(r"""	division="%s",""" % (GetDivision(int(player["TPLP_RANK"]))))
	print(r"""	country="%s",""" % player["COUNTRY"])
	print(r"""	level=%s,""" % player["srpg5_entrants_level"])
	print(r"""	exp=%s,""" % player["srpg5_entrants_exp"])
	print(r"""	relics = {""")
	for i in range(0, len(relics)):
		quantity = int(player["rel_%d_quant" % i])
		if quantity > 0:
			print(r"""		{name="%s", quantity=%d},""" % (relics[str(i)], quantity))
	print(r"""	},""")
	print(r"""	tier_skill = {%s},""" % ", ".join(["[%d]=%s" % (x, player["srpg5_entrants_%dskill" % x]) for x in range(120, 300, 10)])) # [120, 290]
	print(r"""	affinities = {%s},""" % ", ".join("%s=%s" % (name, player["srpg5_entrants_aff%s" % name]) for name in ["dp", "ep", "rp", "ap"]))
	print(r"""	lifetime_song_gold = %s,""" % player["srpg5_entrants_rankgold"])
	print(r"""	lifetime_jp = %s,""" % player["srpg5_entrants_rankjp"])
	print(r"""}""")
	print(r"")
