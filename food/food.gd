extends KinematicBody2D

var velocity = Vector2(0, Globals.FALL_SPEED)
var calories = Globals.BASE_FOOD_CALORIES
var player_created = true 

var weight = 0.06
var current_v = Vector2(0, 0.06)
var target_v = Vector2(0, 1)

func _ready():
	$fade_timer.connect("timeout", self, "queue_free")
	
func set_level(target_level=null):
	var food_level = Globals.FOOD_LEVEL
	if target_level:
		food_level = target_level
	$food_sprite.texture = load("food/images/food%s.png" % min(food_level, 5))
	self.calories += food_level * 2

func _process(delta):
	Movement.update_velocity(self)
	self.move_and_slide(current_v * Globals.FALL_SPEED)
	Movement.check_hit_ground(self, Globals.FOOD_FADE_LENGTH, $food_sprite)
	if not $fade_timer.is_stopped():
		$food_sprite.modulate = Color(1, 1, 1, ($fade_timer.time_left/Globals.FOOD_FADE_LENGTH))
