class_name Clam extends KinematicBody2D

# CONSTANTS
const CLASS_NAME = "Clam"
const LEVEL = "2-2"


var other_scene_loot = load("res://loot/loot.tscn")
var drop_rate = 45

func _ready():
	self.position.y = get_viewport().size.y - 10  # bottom of tank
	$drop_timer.connect("timeout", self, "drop_item")
	$drop_timer.start(self.drop_rate)

func drop_item():
	var coin = other_scene_loot.instance() 
	coin.position.x = self.position.x
	coin.position.y = self.position.y - 30
	coin.set_value(400)
	self.get_node('/root/main/loot_container').add_child(coin)
	$drop_timer.start(self.drop_rate)

func _process(delta):
	pass  # 
