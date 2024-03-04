extends AnimatedSprite2D

var animation_queue = []
var previous_animation = "swim"

func queue(animation_to_queue):
	animation_queue.append(animation_to_queue)

func _ready():
	self.connect("animation_finished", Callable(self, "play_next"))
	self.play()

func play_next():
	if previous_animation == "turn":
		self.flip_h = not self.flip_h
	var next_animation = "swim"
	if animation_queue.size() >= 1:
		next_animation = animation_queue.pop_front()
	self.play()
	self.sprite_frames.set_animation_loop(next_animation, false)
	previous_animation = next_animation
