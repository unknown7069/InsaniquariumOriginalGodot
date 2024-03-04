class_name Guppy extends Fish

func get_class_name() -> String:
	return 'Guppy'

# STATES
func setup_states():
	var gup_tiny_size = {'sprite': $tiny, 'speed': 130, 
	'dead_image': 'res://dead_fish/images/guppy_tiny_dead.png'}
	var gup_small_size = {'sprite': $small, 'drop_value': 10, 'drop_rate': 8, 'speed': 120, 
	 'dead_image': 'res://dead_fish/images/guppy_small_dead.png'}
	var gup_small_medium = {'sprite': $medium, 'drop_value': 30, 'drop_rate': 8, 'speed': 110, 
	 'dead_image': 'res://dead_fish/images/guppy_medium_dead.png'}
	var gup_small_large = {'sprite': $large, 'drop_value': 50, 'drop_rate': 8, 'speed': 100,  
	'dead_image': 'res://dead_fish/images/guppy_large_dead.png'}
	self.states += [gup_tiny_size, gup_small_size, gup_small_medium, gup_small_large]

func _ready():
	self.setup_states()
	self.eat_sound = "slurp"
	$hunger_timer.connect("timeout", Callable(self, "died"))
	$hunger_timer.start(self.would_eat_length + self.hunger_length + 2)
	$drop_timer.connect("timeout", Callable(self, "drop_item"))
	self.update_state(0)

func _process(delta):
	self.base_fish_process(delta)
