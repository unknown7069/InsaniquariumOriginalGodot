extends KinematicBody2D

var velocity = Vector2(0, Globals.FALL_SPEED)
var direction = 'left'
var image
var total_calories = 0

func set_direction(new_direction):
	if new_direction != self.direction:
		$Sprite.flip_h = $Sprite.flip_h

func set_details(image, total_calories):
	self.total_calories = total_calories
	$Sprite.texture = load(image)

func _process(delta):
	self.approach()
	self.position += self.velocity * delta 

func approach():
	if self.velocity.y > Globals.FALL_SPEED:
		 self.velocity.y -= 1
	elif self.velocity.y < Globals.FALL_SPEED:
		self.velocity.y += 1
	if self.velocity.x > 0:
		 self.velocity.x -= 1
	elif self.velocity.x < 0:
		self.velocity.x += 1

func on_click():
	pass 
