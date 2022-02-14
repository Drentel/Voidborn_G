extends Resource

class_name WeightedPool

var items = []
var tot = 0

func add(itm, weight):
	items.append({"item": itm, "weight": int(round(weight))})
	tot += int(round(weight))

func remove(itm):
	for i in items:
		if i["item"] == itm:
			tot -= i["weight"]
			items.erase(i)
			return

func pick():
	var pick = randi()%tot
	
	var counter = 0
	for i in items:
		counter += i["weight"]
		if counter > pick:
			return i["item"]

func get_prob(itm):
	for i in items:
		if i["item"] == itm:
			return i["weight"]*1.0/tot
	return 0
