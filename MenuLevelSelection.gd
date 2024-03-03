extends Node2D

func _ready():
	$Control/next.connect("button_down", self, "goto_level_select")
	$Control/back.connect("button_down", self, "goto_main_menu")
	self.update_options()

func update_options():
	for x in SaveState.STORY_LEVEL:
		var btn = CheckBox.new()
		btn.text = x
		if SaveState.STORY_LEVEL[x] == SaveState.LOCKED:
			btn.disabled = true
		elif SaveState.STORY_LEVEL[x] == SaveState.PASSED:
			pass  # need a completed identity 
		btn.connect("pressed", self, "set_level", [btn, x])
		$Control/GridContainer.add_child(btn) 

func set_level(btn, level):
	Globals.LEVEL_SELECTION = level
	$background.texture = load("res://backgrounds/bk_tank" + str(Globals.LEVEL_SELECTION[0]) + ".png")
	self._on_toggled(btn)

func _on_toggled(btn):
	# unselect all other buttons 
	$Control/next.disabled = false
	for child in $Control/GridContainer.get_children():
		child.pressed = false
	btn.pressed = true

func goto_level_select():
	get_tree().change_scene("res://MenuPetSelection.tscn")

func goto_main_menu():
	get_tree().change_scene("res://MenuMain.tscn")
