extends Node

static func get_all_pets_unlock_order():
	var all_pets = get_pet_classes()
	var unlock_order = []
	for x in range(1, 7):
		for y in range(1, 6):
			var p_match = _check_pet_level(all_pets, "%s-%s" % [x, y])
			unlock_order.append(p_match)
	return unlock_order

static func get_pet_classes():
	var all_pets = get_all_pets()
	var pets_loaded = []
	for pk in all_pets:
		pets_loaded.append(load(all_pets[pk][0]))
	return pets_loaded

static func _check_pet_level(all_pets, level_code):
	""" Helper to match up bets """
	for pet in all_pets:
		if pet.LEVEL == level_code:
			return pet 
	return null

static func get_all_pets():
	var pairs = {}
	var dir = DirAccess.open("res://pets/")
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	while (file_name != ""):
		if file_name == "." or file_name == "..":
			pass
		elif dir.current_is_dir():
			var pet_script = "res://pets/" + file_name + "/" + file_name + ".gd"
			var pet_loaded = load(pet_script)
			pairs[pet_loaded.CLASS_NAME] = [pet_script, "res://pets/" + file_name + "/" + file_name + ".tscn"]
		file_name = dir.get_next()
	return pairs
