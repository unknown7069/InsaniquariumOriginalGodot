extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$story.connect("button_down", Callable(self, "goto_level_select"))
	goto_level_select()  # faster debug 


func goto_level_select():
	get_tree().change_scene_to_file("res://MenuLevelSelection.tscn")

