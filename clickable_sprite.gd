extends Sprite

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var click_area = Rect2(self.get_parent().position - self.texture.get_size()/2, self.texture.get_size())
		if click_area.has_point(event.position): 
			self.get_parent().on_click()
			Globals.CLICK_COUNTER += 1
			if Globals.CLICK_COUNTER >= Globals.CLICK_RESET:
				get_tree().set_input_as_handled()  # remove future clicks 
				Globals.CLICK_COUNTER = 0
