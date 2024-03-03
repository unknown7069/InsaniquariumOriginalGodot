class_name Crab extends Fish

# CONSTANTS
const CLASS_NAME = "Crab"
const LEVEL = "2-3"

var damage = 40

func _ready():
	self.speed = 80 
	$punch.connect("timeout", self, "punch")
	$punch.start(1)
	self.position.y = get_viewport().size.y - Globals.BOTTOM_BOARDER  # bottom of tank

func snap():
	for fish in get_node('/root/main/fish_container').get_children():
		if self.position.distance_to(fish.position) < 80:
			if fish.hungry == false:
				fish.current_v = Vector2(0, -2 * fish.weight) # bounce

func find_closest_food():
	var target = null
	var min_distance = 10000
	for A in get_node('/root/main/alien_container').get_children():
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
	return target 

func punch():
	self.snap()
	var closest = self.find_closest_food()
	if closest == null:
		return 
	var dist = self.position.distance_to(closest.position)
	if dist < 20:
		closest.health -= self.damage 

func _process(delta):
	var target = find_closest_food()
	if target == null:
		return 
	self.target_v = (target.position - self.position).normalized()
	self.update_velocity(delta)
	self.move_and_slide(self.current_v * speed)

