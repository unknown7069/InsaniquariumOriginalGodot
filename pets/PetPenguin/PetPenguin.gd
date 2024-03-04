class_name Penguin extends Fish

# CONSTANTS
const CLASS_NAME = "Penguin"
const LEVEL = "3-2"

var sing_delay = 8

func _ready():
	self.update_state_sprite($sprite)
	$sing.connect("timeout", Callable(self, "song"))
	$sing.start(sing_delay)

func song():
	for shell in self.get_node('/root/main/loot_container').get_children():
		shell.freeze()
	$sing.start(sing_delay)

func _process(delta):
	self.wander(delta)
