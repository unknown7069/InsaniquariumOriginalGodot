class_name Mermaid extends Fish

# CONSTANTS
const CLASS_NAME = "Mermaid"
const LEVEL = "5-1"

var sing_delay = 65  # 35s in web 

func _ready():
	self.update_state_sprite($sprite)
	$sing.connect("timeout", self, "song")
	$sing.start(sing_delay)

func song():
	for x in range(3):
		var t = Timer.new()
		t.set_one_shot(true)
		add_child(t)
		t.start(0.5)
		yield(t, "timeout")
		self.sing()
		t.queue_free()

func sing():
	for fish in get_node('/root/main/fish_container').get_children():
		if fish.get_class_name() == "Guppy":
			fish.drop_item()

func _process(delta):
	self.wander(delta)
