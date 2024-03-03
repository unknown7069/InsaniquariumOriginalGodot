class_name Shark extends Fish

# CONSTANTS
const CLASS_NAME = "Shark"
const LEVEL = "5-3"

var damage = 35

func _ready():
	self.speed = 130 
	self.drop_value = 30  
	self.drop_rate = 6
	# need an eating timer 
	$punch.connect("timeout", self, "punch")
	$punch.start(1)
	$drop.connect("timeout", self, "drop")
	$drop.start(self.drop_rate)

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
