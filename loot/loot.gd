extends KinematicBody2D

var value = 0
var weight = 0.1
var current_v = Vector2()
var target_v = Vector2(0, 1)

var ice_sprite = load("res://loot/images/ice.png")

func _ready():
	$fade_timer.connect("timeout", self, "queue_free")
	$freeze_timer.connect("timeout", self, "stop_freeze")

func set_value(value):
	if value == 10:
		$loot_penny.texture = load("res://loot/images/shell_penny.png")
	elif value == 30:
		$loot_penny.texture = load("res://loot/images/shell_silver.png")
	elif value == 50:
		$loot_penny.texture = load("res://loot/images/shell_gold.png")
	elif value == 150:
		$loot_penny.texture = load("res://loot/images/loot_spiral.png")
	elif value == 250:
		$loot_penny.texture = load("res://loot/images/loot_spike.png")
	elif value == 500:
		$loot_penny.texture = load("res://loot/images/loot_fat.png")
	elif value == 800:
		$loot_penny.texture = load("res://loot/images/loot_con.png")
	elif value == 2000:
		$loot_penny.texture = load("res://loot/images/loot_pearl.png")
	elif value == 5000:
		$loot_penny.texture = load("res://loot/images/loot_pearl_pink.png")
	self.value = value 

func _process(delta):
	Movement.update_velocity(self)
	if $freeze_timer.time_left <= 0:
		self.move_and_slide(current_v * Globals.FALL_SPEED)
	Movement.check_hit_ground(self, Globals.LOOT_FADE_LENGTH, $loot_penny)
	# fade 
	if not $fade_timer.is_stopped():
		$loot_penny.modulate = Color(1, 1, 1, ($fade_timer.time_left/Globals.LOOT_FADE_LENGTH))

func on_click():
	self.get_node('/root/main').update_money(self.value)
	self.queue_free()

func pet_collect():
	self.get_node('/root/main').update_money(self.value)
	self.queue_free()

func freeze():
	# TODO apply frozen sprite
	var spr = Sprite.new()
	spr.texture = ice_sprite
	spr.name = "ice"
	# TODO resize the for the sprite 
	self.add_child(spr)
	$freeze_timer.start(5)

func stop_freeze():
	$freeze_timer.stop()
	self.get_node("ice").queue_free()
