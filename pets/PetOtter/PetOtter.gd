class_name Otter extends Fish

# CONSTANTS
const CLASS_NAME = "Otter"
const LEVEL = "2-4"

func _ready():
	self.update_state_sprite($sprite)
	Globals.LOOT_FADE_LENGTH = 1  # this works 

func _process(delta):
	self.wander(delta)
