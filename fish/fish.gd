class_name Fish extends CharacterBody2D

# STATES
var states = []
var current_state
 
# MOVING
var speed = 100
var weight = 1
var current_v = Vector2()
var target_v = Vector2()

# EATING DROPPING
var eat_sound
var hungry = false
var hunger_length = 8
var would_eat_length = 4
var total_food = 0
var drop_value 
var drop_rate 

# ANIMATION
@onready var active_sprite
@onready var active_sprite_texture 
var size_of_sprite = 8
var direction = 'left'

var other_scene_dead = load("res://dead_fish/dead_fish.tscn")
var other_scene_crunch = load("res://dead_fish/crunch.tscn")
var other_scene_loot = load("res://loot/loot.tscn")

func _ready():
	get_sprite_size()

func update_hunger():
	if $hunger_timer.get_time_left() < hunger_length + would_eat_length:
		hungry = true 
		if $hunger_timer.get_time_left() < hunger_length:
			pass  # change sprite to hungry mask 
	else:
		hungry = false 

func crunch():
	var new_crunch = other_scene_crunch.instantiate()
	new_crunch.position = self.position
	self.get_node('/root/main/').add_child(new_crunch)
	self.queue_free()

func died():
	var corpse = other_scene_dead.instantiate()
	corpse.position = self.position
	corpse.set_direction(self.direction)
	corpse.set_details(self.states[self.current_state]['dead_image'], self.total_food)
	corpse.velocity = self.current_v * speed 
	self.get_node('/root/main/dead_container').add_child(corpse)
	self.queue_free()

func eat(other_node):
	if self.eat_sound != null:
		GlobalAudio.get_node(self.eat_sound).play()
	self.total_food += other_node.calories
	$hunger_timer.start(hunger_length + would_eat_length + other_node.calories)
	self.active_sprite.queue('eat')
	other_node.queue_free()
	self.update_state(self.current_state + 1)
	self.wander_counter = 0

func find_closest_food():
	var target = null
	var min_distance = 10000
	for A in get_node('/root/main/food_container').get_children():
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
		if min_distance < self.size_of_sprite:
			self.eat(target)
			return null
	return target 

func drop_item():
	# create loot 
	var coin = other_scene_loot.instantiate() 
	coin.position = self.position
	coin.set_value(self.drop_value)
	self.get_node('/root/main/loot_container').add_child(coin)

func check_state():
	if self.states.size() > self.current_state:
		pass

func update_state(new_size):
	if self.states.size() <= new_size:
		return 
	self.current_state = new_size
	if 'drop_rate' in self.states[new_size]:
		self.drop_rate = self.states[new_size]['drop_rate']
		$drop_timer.start(self.drop_rate)
		self.drop_value = self.states[new_size]['drop_value']
	else:
		self.drop_value = 0
		self.drop_rate = -1
		$drop_timer.stop()
	if 'speed' in self.states[new_size]:
		self.speed = self.states[new_size]['speed']
	self.update_state_sprite(self.states[new_size]['sprite'])

func update_state_sprite(target_sprite):
	# set all other images to false 
	for x in self.get_children():
		if x is AnimatedSprite2D:
			x.visible = false 
	self.active_sprite = target_sprite
	if self.direction == 'right':
		self.active_sprite.flip_h = true 
	self.active_sprite.visible = true 
	self.get_sprite_size()
	
func get_sprite_size():
	self.active_sprite_texture = self.active_sprite.sprite_frames.get_frame_texture(self.active_sprite.get_animation(), self.active_sprite.frame)
	if self.active_sprite_texture == null:
		self.size_of_sprite = 32  # grrr
		return
	elif self.active_sprite_texture is CompressedTexture2D:
		self.size_of_sprite = 32
		return 
	var current_frame = self.active_sprite_texture.get_region()
	self.size_of_sprite = max(current_frame.size.x, current_frame.size.y)  # todo needs adjusting 

var wander_counter = 0
var wander_speed = speed
func wander(delta):
	if wander_counter < 0:
		self.target_v = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		self.wander_speed = randf_range(speed*0.05, speed*0.6)
		wander_counter = 5
	else:
		wander_counter -= delta 
	self.move_self(self.wander_speed, delta)

func move_self(move_speed, delta, target=null):
	if target != null:
		self.target_v = (target.position - self.position).normalized()
	self.update_velocity(delta)
	self.update_facing_direction()
	if Util.check_bottom_of_tank(self, self.active_sprite_texture):
		self.current_v.y = min(self.current_v.y, 0)
	if Util.check_top_of_tank(self, self.active_sprite_texture):
		self.current_v.y = max(self.current_v.y, 0)
	if Util.check_left_side_of_tank(self, self.active_sprite_texture):
		self.current_v.x = max(self.current_v.x, 0)
	if Util.check_right_side_of_tank(self, self.active_sprite_texture):
		self.current_v.x = min(self.current_v.x, 0)
	self.set_velocity(self.current_v * move_speed)
	self.move_and_slide()

func update_velocity(delta):
	if abs(self.current_v.x - self.target_v.x) <= self.weight:
		self.current_v.x = self.target_v.x
	elif self.current_v.x > self.target_v.x:
		self.current_v.x -= self.weight * delta
	elif self.current_v.x < self.target_v.x:
		self.current_v.x += self.weight * delta
	#
	if abs(self.current_v.y - self.target_v.y) <= self.weight:
		self.current_v.y = self.target_v.y
	elif self.current_v.y > self.target_v.y:
		self.current_v.y -= self.weight * delta
	elif self.current_v.y < self.target_v.y:
		self.current_v.y += self.weight * delta

func update_facing_direction():
	if self.target_v.x > 0:
		if self.direction == 'left':
			self.active_sprite.queue('turn')
			self.direction = 'right'
	elif self.target_v.x < 0:
		if self.direction == 'right':
			self.active_sprite.queue('turn')
			self.direction = 'left'

# STEP 
func _process(delta):
	pass 

func base_fish_process(delta):
	self.update_hunger()
	if hungry:
		var target = self.find_closest_food()
		if target == null:
			self.wander(delta)
			return 
		self.move_self(self.speed, delta, target)
	else:
		self.wander(delta)

