extends Resource
class_name LootTable
# The tarble will roll once for every top-level item in the list
# It is not safe to put pacts in loot tables
# I'm kinda unsure why i even implemented that

export var table = [
	[
		{
			"weight": 1,
			"type": "generic",
			"name": "Mundane soul shard",
			"amount_min": 1,
			"amount_max": 1,
		},
		{
			"weight": 1,
			"type": "generic",
			"name": "Unusual soul shard",
			"amount_min": 1,
			"amount_max": 1,
		},
		{
			"weight": 1,
			"type": "generic",
			"name": "Extraordinary soul shard",
			"amount_min": 1,
			"amount_max": 1,
		},
		{
			"weight": 1,
			"type": "money",
			"amount_min": 100,
			"amount_max": 1000,
		},
		{
			"weight": 1,
			"type": "artifact",
			"power_min": 5,
			"power_max": 10,
		},
		{
			"weight": 1,
			"type": "weapon",
			"power_min": 5,
			"power_max": 10,
		},
		#{
		#	"weight": 1,
		#	"type": "pact",
		#	"pact": "res://Placeholders/test_pact3.tres"
		#},
	]
]

# Json takes priority if set
# It's honestly just easier to edit json
export var json_path = ""

func generate():
	if json_path != "":
		table = GUtil.objectify_json(json_path)
	
	var res = []
	
	for i in table:
		var pool = WeightedPool.new()
		for j in i:
			pool.add(j, j["weight"])
		res.append(pool.pick())
	
	return res

func _init():
	pass
