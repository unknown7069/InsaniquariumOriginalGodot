class_name Movement

static func update_velocity(obj):
	if abs(obj.current_v.x - obj.target_v.x) <= obj.weight:
		obj.current_v.x = obj.target_v.x
	elif obj.current_v.x > obj.target_v.x:
		obj.current_v.x -= obj.weight
	elif obj.current_v.x < obj.target_v.x:
		obj.current_v.x += obj.weight
	#
	if abs(obj.current_v.y - obj.target_v.y) <= obj.weight:
		obj.current_v.y = obj.target_v.y
	elif obj.current_v.y > obj.target_v.y:
		obj.current_v.y -= obj.weight
	elif obj.current_v.y < obj.target_v.y:
		obj.current_v.y += obj.weight

static func check_hit_ground(obj, fade_length, sprite):
	if obj.get_node('fade_timer').is_stopped() and Util.check_bottom_of_tank(obj, sprite.texture):
		obj.get_node('fade_timer').start(fade_length)
		obj.current_v = Vector2()
		obj.target_v = Vector2()
