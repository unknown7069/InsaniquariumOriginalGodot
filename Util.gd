class_name Util


# BOUNDARIES
static func get_sprite_region(s):
	if s == null:
		return Vector2(20, 20)  # should not be in game
	if s is CompressedTexture2D or s is AnimatedSprite2D:
		return s.get_size()
	else:
		return s.get_region().size

static func check_bottom_of_tank(s, sprite):
	var region = get_sprite_region(sprite)
	if (s.position.y + region.y/2) > (Globals.WINDOW_HEIGHT - Globals.BOTTOM_BOARDER):
		return true
	return false 

static func check_top_of_tank(s, sprite):
	var region = get_sprite_region(sprite)
	if (s.position.y - region.y/2) < Globals.TOP_BOARDER:
		return true
	return false 

static func check_side_of_tank(s, sprite):
	return check_right_side_of_tank(s, sprite) or check_left_side_of_tank(s, sprite)

static func check_right_side_of_tank(s, sprite):
	var region = get_sprite_region(sprite)
	if (s.position.x + region.x/2) > (Globals.WINDOW_WIDTH - Globals.SIDE_BOARDER):
		return true
	return false 

static func check_left_side_of_tank(s, sprite):
	var region = get_sprite_region(sprite)
	if (s.position.x - region.x/2) < Globals.SIDE_BOARDER:
		return true
	return false 
