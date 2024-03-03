class_name Ray extends Fish

# CONSTANTS
const CLASS_NAME = "Ray"
const LEVEL = "4-2"

var collect_range = 50

func _ready():
	self.position.y = get_viewport().size.y - Globals.BOTTOM_BOARDER 

func find_food_or_loot():
	var target = null
	var min_distance = 10000
	for A in (get_node('/root/main/loot_container').get_children() + get_node('/root/main/food_container').get_children()):
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
		if dist < self.collect_range:
			A.current_v = Vector2(0, -45 * A.weight)  # bounce 
	return target 

func _process(delta):
	self.find_food_or_loot()

