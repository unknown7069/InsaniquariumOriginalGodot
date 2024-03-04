class_name Jelly extends Fish

# CONSTANTS
const CLASS_NAME = "Jelly"
const LEVEL = "3-4"


func find_closest_food():
	var target = null
	var min_distance = 10000
	for A in get_node('/root/main/loot_container').get_children():
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
	if min_distance < self.size_of_sprite:
		self.collect(target)
	return target 

func collect(target):
	target.pet_collect()

func _ready():
	self.update_state_sprite($sprite)

func _process(delta):
	var target = self.find_closest_food()
	if target == null:
		return 
	self.direction_v = (target.position - self.position).normalized()
	self.set_velocity(self.direction_v * speed)
	self.move_and_slide()
	self.velocity
