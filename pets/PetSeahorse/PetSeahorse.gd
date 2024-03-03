class_name Seahorse extends Fish

# CONSTANTS
const CLASS_NAME = "Seahorse"
const LEVEL = "1-2"

var food_scene = load("res://food/food.tscn")
var pet_name = "Zorf"

# 22 seconds for next feeding = 22/1.5=15 fish kept alive 

func _ready():
	self.speed = 30
	self.update_state_sprite($sprite)
	$food_counter.connect("timeout", self, "check_hungry")
	$food_counter.start(1.5)

func check_hungry():
	for gup in get_node('/root/main/fish_container').get_children():
		# if gup.name != "Guppy":  # check what it eats
		# 	continue
		if gup.hungry:
			self.create_food() 
			return

func create_food():
	var new_food = food_scene.instance() 
	new_food.set_level(3)
	new_food.position = self.position
	new_food.player_created = false 
	new_food.current_v = Vector2(2 if self.direction == 'right' else -2, 0)
	get_node('/root/main/food_container').add_child(new_food)

func _process(delta):
	self.wander(delta)
