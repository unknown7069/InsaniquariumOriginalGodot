class_name Snail extends KinematicBody2D

# CONSTANTS
const CLASS_NAME = "Snail"
const LEVEL = "1-1"

var speed = 30
var collect_range = 15

func _ready():
	self.position.y = get_viewport().size.y - Globals.BOTTOM_BOARDER  # bottom of tank

func find_closest_loot():
	var target = null
	var min_distance = 10000
	for A in get_node('/root/main/loot_container').get_children():
		var dist = self.position.distance_to(A.position)
		if dist < min_distance:
			target = A 
			min_distance = dist 
		if dist < self.collect_range:
			A.pet_collect()
	return target 

func _process(delta):
	var target_loot = self.find_closest_loot()
	if target_loot:
		if target_loot.position.x > self.position.x:
			self.move_and_slide(Vector2(self.speed, 0))
		elif target_loot.position.x < self.position.x:
			self.move_and_slide(Vector2(-self.speed, 0))
