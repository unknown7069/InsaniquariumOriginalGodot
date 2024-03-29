extends Node

var STORY_LEVEL

const LOCKED = 0
const READY = 1
const PASSED = 2

func _ready():
	self.load_game()

func load_init():
	""" The initial game state """ 
	# 0=locked, 1=ready, 2=passed
	STORY_LEVEL = {}
	for x in range(1, 7):  # tanks 
		for y in range(1, 6):  # levels 
			STORY_LEVEL["%s-%s" % [x, y]] = READY # LOCKED
	STORY_LEVEL["1-1"] = 1  # ready first level
	
func save_game():
	""" Write the game data to the save file """
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line(JSON.new().stringify(STORY_LEVEL))
	save_game.close()

func load_game():
	""" Load the saved game if it exists """
	self.load_init()
	if not FileAccess.file_exists("user://savegame.save"):
		self.save_game()
	# read data 
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	# STORY_LEVEL = parse_json(save_game.get_line())
	# var save_nodes = get_tree().get_nodes_in_group("Persist")
	save_game.close()

