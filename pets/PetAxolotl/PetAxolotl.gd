class_name Axolotl extends Fish

# CONSTANTS
const CLASS_NAME = "Axolotl"
const LEVEL = "4-4"

func _ready():
	self.update_state_sprite($sprite)
	self.wander_speed = 30
	# self.drop_value = 10  
	# self.drop_rate = 5  
	# $drop.connect("timeout", self, "drop")
	# $drop.start(self.drop_rate)

func _process(delta):
	self.wander(delta)
	if self.get_node('/root/main/alien_container').get_child_count() > 0:
		self.suck_up_fish()

func suck_up_fish():
	for f in self.get_node('/root/main/fish_container').get_children():
		self.point_to_me(f)
	# TODO should have something to disable them? and hide them?

func point_to_me(other, move_speed = 150):
	target_v = (self.position - other.position).normalized()
	other.set_velocity(target_v * move_speed)
	other.move_and_slide()
	other.velocity
