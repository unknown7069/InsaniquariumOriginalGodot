extends Node2D

var money = 200000
var in_battle = false 

var guppy_scene = load("res://fish/guppy/Guppy.tscn")
var carn_scene = load("res://fish/carn/carn.tscn")
var tiger_scene = load("res://fish/Tiger/Tiger.tscn")
var food_scene = load("res://food/food.tscn")
var alien_scene = load("res://alien/alien.tscn")
var laser_scene = load("res://laser/laser.tscn")


func _ready():
	# OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	$background.texture = load("res://backgrounds/bk_tank" + str(Globals.LEVEL_SELECTION[0]) + ".png")
	set_process_input(true)
	self.testing()
	self.init_pets()
	$battle_timer.connect("timeout", Callable(self, "start_battle"))
	$battle_timer.start(Globals.BATTLE_TIMER)  
	$click_timer.connect("timeout", Callable(self, "create_food"))

# CLICK
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not self.in_battle:
			self.create_food()
			$click_timer.start(0.2)  # 
		else:
			var new_fire = laser_scene.instantiate()
			new_fire.position = event.position
			$misc_container.add_child(new_fire)
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$click_timer.stop() 
	Globals.CLICK_COUNTER = 0
	get_viewport().set_input_as_handled()  # remove future clicks?

# FOOD 
func create_food():
	if Globals.CLICK_COUNTER > 0:
		return  # prevent pick up and food drop 
	if self.count_player_created_food() >= Globals.FOOD_COUNT:
		return  # limit drops 
	GlobalAudio.get_node("drop_food").play(0)
	var new_food = food_scene.instantiate() 
	new_food.position = get_global_mouse_position() 
	new_food.set_level()  
	$food_container.add_child(new_food)
	self.update_money(Globals.FOOD_COST)

func count_player_created_food():
	var num = 0
	for i in $food_container.get_children():
		if i.player_created:
			num += 1
	return num 

# BATTLE
func start_battle():
	self.in_battle = true
	self.spawn_alien()
	$battle_timer.stop()
	for f in $fish_container.get_children():
		f.get_node('drop_timer').set_paused(true)
		f.get_node('hunger_timer').set_paused(true)

func end_battle():
	self.in_battle = false
	$battle_timer.start(Globals.BATTLE_TIMER)
	# start fish timers 
	for f in $fish_container.get_children():
		f.get_node('drop_timer').set_paused(false)
		f.get_node('hunger_timer').set_paused(false)

func spawn_alien():
	var new_alien = self.alien_scene.instantiate()
	new_alien.position = get_random_location()
	$alien_container.add_child(new_alien)

# STORE
var price_list = {
	'guppy': 100,
	'carn': 1000,
	'ultra': 10000,
	'food_upgrade': 200,
	'food_quantity': 200,
	'collection': 100,
	'weapon': 1000,
	}
var price_to_label = {}  # price list to label to update label text 

func update_prices():
	# loop through the price list and update labels
	for k in price_to_label:
		price_to_label[k].text = str(price_list[k])
		# image updating 
		if k == 'food_upgrade':
			pass 

func can_afford(price):
	# check if we can buy this 
	if price <= self.money:
		GlobalAudio.get_node("purchase").play()
		self.update_money(-price)
		return true
	GlobalAudio.get_node("cannot_afford").play()
	return false 

func update_money(rel_change):
	if rel_change > 0:
		GlobalAudio.get_node("collect_loot").play(0)
	self.money += rel_change
	$gui_container/bank.text = self._human_money(self.money)

func _human_money(monies):
	if monies > 100000:
		return "$ %s %s " % [monies/1000, "k"]
	elif monies > 10000000:
		return "$ %s %s " % [monies/1000000, " M"]
	else:
		return "$ %s " % [monies]

func create_guppy(free=false):
	var price = price_list['guppy'] if not free else 0
	if self.can_afford(price):
		var new_gup = self.guppy_scene.instantiate()
		new_gup.position = get_random_location()
		$fish_container.add_child(new_gup)

func create_carn(free=false):
	var price = price_list['carn'] if not free else 0
	if self.can_afford(price):
		var new_carn = self.carn_scene.instantiate()
		new_carn.position = get_random_location()
		$fish_container.add_child(new_carn)

func create_ultra(free=false):
	var price = price_list['ultra'] if not free else 0
	if self.can_afford(price):
		var new_carn = self.tiger_scene.instantiate()
		new_carn.position = get_random_location()
		$fish_container.add_child(new_carn)

func upgrade_food(free=false):
	var price = price_list['food_upgrade'] if not free else 0
	if self.can_afford(price):
		Globals.FOOD_LEVEL += 1
		price_list['food_upgrade'] = 100 * pow(2, Globals.FOOD_LEVEL)
		self.update_prices() 

func upgrade_food_count(free=false):
	var price = price_list['food_quantity'] if not free else 0
	if self.can_afford(price):
		Globals.FOOD_COUNT += 1
		price_list['food_quantity'] = 100 * Globals.FOOD_COUNT
		self.update_prices()

func upgrade_collection(free=false):
	var price = price_list['collection'] if not free else 0
	if self.can_afford(price):
		Globals.CLICK_RESET += 1
		price_list['collection'] = 100 * Globals.CLICK_RESET
		self.update_prices()

func upgrade_weapon(free=false):
	var price = price_list['weapon'] if not free else 0
	if self.can_afford(price):
		Globals.WEAPON_LEVEL += 1 
		price_list['weapon'] = 1000 * Globals.WEAPON_LEVEL 
		self.update_prices()

func create_random_pet(free=false):
	GlobalAudio.get_node("purchase").play(0)
	# TODO - pick from unlocked 
	# var new_pet = self.ray_scene.instance()
	# new_pet.position = get_random_location()
	# $pet_container.add_child(new_pet)

# OTHER 
func get_random_location():
	return Vector2((randi() % (Globals.WINDOW_WIDTH - Globals.SIDE_BOARDER)) + Globals.SIDE_BOARDER, (randi() % (Globals.WINDOW_HEIGHT - Globals.BOTTOM_BOARDER)) + Globals.TOP_BOARDER)

func testing():
	create_next_button('guppy', "store_icons/guppy_small_icon.png", "create_guppy")
	create_next_button('food_upgrade', "food/images/food2.png", "upgrade_food")
	create_next_button('food_quantity', "food/images/food1.png", "upgrade_food_count")
	create_next_button('collection', "store_icons/collection.png", "upgrade_collection")
	create_next_button('weapon', "laser/weapons/gun1.png", "upgrade_weapon")
	create_next_button('carn', "store_icons/carnivore_small_icon.png", "create_carn")
	create_next_button('ultra', "store_icons/carnivore_small_icon.png", "create_ultra")
	# create_next_button("", "", "pass")
	# create_next_button("", "", "pass")
	self.update_money(0)

var x_offset = 0
var offset_increment = Globals.WINDOW_WIDTH / 11  # 58
var y_offset = 35
func create_next_button(price, icon, func_s):
	# set button
	var btn = Button.new()
	btn.set_position(Vector2(x_offset,0))
	btn.set_size(Vector2(offset_increment, y_offset))
	btn.connect("button_down", Callable(self, func_s))
	# set label
	var lbl = Label.new()
	lbl.text = str(price_list[price])
	# lbl.align = Label.ALIGNMENT_CENTER 
	lbl.set_position(Vector2(0, y_offset-16))
	lbl.set_size(Vector2(offset_increment, 10))
	btn.add_child(lbl)
	price_to_label[price] = lbl
	# set icon 
	var btn_icon = Sprite2D.new()
	btn_icon.texture = load(icon)
	btn_icon.position = Vector2(offset_increment/2, y_offset/2-6)
	btn.add_child(btn_icon)
	$gui_container.add_child(btn)
	x_offset += offset_increment

func init_pets():
	var pet_manager = preload("res://AllPets.gd").get_all_pets()
	for p in Globals.PET_SELECTION:
		var new_pet = load(pet_manager[p][1]).instantiate()
		new_pet.position = get_random_location()
		$pet_container.add_child(new_pet)

func _pass():
	pass

func _process(delta):
	if self.in_battle:
		if $alien_container.get_child_count() == 0:
			self.end_battle()




