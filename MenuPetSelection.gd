extends Node2D

# what has been selected?
var pet_manager = preload("res://AllPets.gd")

func pet_to_be_unlocked():
	""" Lock the pet we are unlocking in this level """
	# loop through all the pets and find a matching code 
	var temp_pets = pet_manager.get_pet_classes()
	for temp_pet in temp_pets:
		for child in $c/GridContainer.get_children():
			if child.text != temp_pet.CLASS_NAME:
				continue
			# this level unlocks this pet 
			if temp_pet.LEVEL == Globals.LEVEL_SELECTION:
				self.on_toggle(child)
				child.disabled = true 
			# can't select pets we haven't unlocked 
			if SaveState.STORY_LEVEL[temp_pet.LEVEL] == SaveState.LOCKED:
				child.disabled = true 
				child.text = "???"

func _ready():
	Globals.PET_SELECTION = []  # reset 
	$background.texture = load("res://backgrounds/bk_tank" + str(Globals.LEVEL_SELECTION[0]) + ".png")
	for x in pet_manager.get_all_pets_unlock_order():
		var btn = CheckBox.new()
		if x != null:
			btn.text = x.CLASS_NAME
		else:
			btn.text = "missing"
		btn.connect("pressed", self, "on_toggle", [btn])
		$c/GridContainer.add_child(btn)
		btn.connect("mouse_entered", self, "display_tooltip", [btn])
		btn.connect("mouse_exited", self, "hide_tooltip", [btn])
	$c/next.connect("button_down", self, "goto_tank")
	$c/back.connect("button_down", self, "goto_level_select")
	self.pet_to_be_unlocked()

func _process(delta):
	var v = get_global_mouse_position()
	v.x+=10
	$c/tooltip.set_position(v)

func display_tooltip(btn):
	$c/tooltip.visible = true 
	
func hide_tooltip(btn):
	$c/tooltip.visible = false 

func on_toggle(btn):
	# limit selection to 3 
	if len(Globals.PET_SELECTION) >= 3:
		if btn.pressed == false :
			pass
		else:
			btn.pressed = false 
			return
	# add 
	if btn.text in Globals.PET_SELECTION:
		Globals.PET_SELECTION.erase(btn.text)
	else:
		Globals.PET_SELECTION.append(btn.text)
	# manage group 
	for child in $c/GridContainer.get_children():
		child.pressed = false
	for child in $c/GridContainer.get_children():
		if child.text in Globals.PET_SELECTION:
			child.pressed = true 

func goto_level_select():
	get_tree().change_scene("res://MenuLevelSelection.tscn")

func goto_tank():
	get_tree().change_scene("res://Tank.tscn")
