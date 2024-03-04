extends AnimatedSprite2D

var distance = 40  # hmmm 

func _ready():
	GlobalAudio.get_node("zap").play(0)
	self.hit_aliens()
	self.connect("animation_finished", Callable(self, "finished_animation"))
	self.play()

func hit_aliens():
	for A in get_node('/root/main/alien_container').get_children():
		# get sprite rectange and check if point is inside 
		var dist = self.position.distance_to(A.position)
		if dist < distance:
			A.health -= Globals.WEAPON_POWER * Globals.WEAPON_LEVEL
			A.current_v += (A.position - self.position).normalized() * A.speed/30
			# print(A.current_v.length())
			A.current_v = A.current_v.normalized() * 0.9  # limit push

func finished_animation():
	self.queue_free()
