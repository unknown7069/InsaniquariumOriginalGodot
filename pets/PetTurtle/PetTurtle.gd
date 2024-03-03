class_name Turtle extends Fish

# CONSTANTS
const CLASS_NAME = "Turtle"
const LEVEL = "4-1"

func _ready():
	self.update_state_sprite($sprite)
	Globals.FALL_SPEED = 50  # this works 

func _process(delta):
	self.wander(delta)
