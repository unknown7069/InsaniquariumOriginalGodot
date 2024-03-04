extends Node2D


func _ready():
	$Timer.connect("timeout", Callable(self, "queue_free"))
	$Timer.start(0.1)
	GlobalAudio.get_node("crunch").play(0)
