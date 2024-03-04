class_name SwordFish extends Fish

# CONSTANTS
const CLASS_NAME = "Swordfish"
const LEVEL = "1-3"

var damage = 20

func _ready():
	self.update_state_sprite($sprite)
	self.speed = 130 
	self.drop_value = 10  
	self.drop_rate = 5  
	$punch.connect("timeout", Callable(self, "punch"))
	$punch.start(1)
	$drop.connect("timeout", Callable(self, "drop"))
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
	self.set_velocity(self.current_v * speed)
	self.move_and_slide()
	self.velocity
