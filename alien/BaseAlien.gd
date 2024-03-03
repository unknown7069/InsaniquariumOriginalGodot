class_name BaseAlien extends Fish

var health = 100

func _ready():
	speed = 60 
	size_of_sprite = 20 # wtf 
	self.update_state_sprite($sprite)
	$initial_drop.start(1)
	pass  # create portal effects 

func eat(other_node):
	if $initial_drop.get_time_left() > 0:
		return  # prevent spawn kills 
	# self.active_sprite.queue('eat')
	other_node.crunch()  # eat

func find_closest_food():
	var target = null
	var min_distance = 10000
	for A in get_node('/root/main/fish_container').get_children():
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
	if min_distance < self.size_of_sprite:
		self.eat(target)
		return null
	return target 

func died():
	# drop loot 
	# explode 
	self.queue_free()

func _process(delta):
	$health_bar.value = self.health 
	if health < 0:
		self.died()
	var target = self.find_closest_food()
	if target == null:
		self.wander(delta)
		# self.move_self(self.speed/2, delta)
		return 
	self.move_self(self.speed, delta, target)
