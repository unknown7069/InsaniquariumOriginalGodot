class_name Carn extends Fish

func get_class_name():
	return "Carn"

func _ready():
	self.setup_states()
	self.update_state(0)

func setup_states():
	var carn_tiny_size = {'sprite': $AnimatedSprite2D, 'drop_value': 150, 'drop_rate': 2,
	 'dead_image': 'res://dead_fish/images/carnivore_small_dead.png'}
	var carn_small_size = {'sprite': $AnimatedSprite2, 'drop_value': 150, 'drop_rate': 2,
	 'dead_image': 'res://dead_fish/images/carnivore_large_dead.png'}
	self.states += [carn_tiny_size, carn_small_size]

func eat(other_node):
	total_food += 12
	$hunger_timer.start(hunger_length + would_eat_length + 12)
	self.active_sprite.queue('eat')
	other_node.crunch()
	self.update_state(self.current_state + 1)

func find_closest_food():
	var target = null
	var min_distance = 10000
	for A in get_node('/root/main/fish_container').get_children():
		# todo small size
		if A.get_class_name() != "Guppy":
			continue
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
	if min_distance < self.size_of_sprite:
		self.eat(target)
		return null
	return target 

func _process(delta):
	self.base_fish_process(delta)
