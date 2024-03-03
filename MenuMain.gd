extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$story.connect("button_down", self, "goto_level_select")


func goto_level_select():
	get_tree().change_scene("res://MenuLevelSelection.tscn")

