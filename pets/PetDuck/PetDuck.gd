class_name Duck extends Fish

# CONSTANTS
const CLASS_NAME = "Duck"
const LEVEL = "1-4"

var guppy_scene = load("res://fish/guppy/Guppy.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var baby_timer = 20
var pregnant_sprite_time_min = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	$baby_timer.connect("timeout", Callable(self, "hatch"))
	$baby_timer.start(2)

func hatch():
	var gup = guppy_scene.instantiate() 
	# todo set timer to a lower value 
	gup.position = self.position
	self.get_node('/root/main/fish_container').add_child(gup)

func _process(delta):
	pass # self.wander(delta)
