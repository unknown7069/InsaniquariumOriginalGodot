class_name Skull extends Fish

# CONSTANTS
const CLASS_NAME = "Skull"
const LEVEL = "2-1"

var pet_name = "skull"

# rate is 5s in web version

func _ready():
	self.drop_rate = 6
	self.drop_value = 50
	self.wander_speed = 50
	$drop_timer.connect("timeout", Callable(self, "drop_item"))
	$drop_timer.start(self.drop_rate)

func _process(delta):
	self.wander(delta)
