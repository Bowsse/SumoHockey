extends Button
var action: String

func _init():
	toggle_mode = true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	action = name
	set_process_unhandled_input(false)
	update_key_text()
	pass # Replace with function body.


func _unhandled_input(event):
	print(event)
	if (
		event is InputEventKey || 
		event is InputEventMouseButton ||
		event is InputEventJoypadButton || 
		(event is InputEventJoypadMotion && (event.axis_value > 0.2 || event.axis_value < -0.2))
		):
		InputMap.action_erase_events(str(action) + str($"../../../..".currentlyEditingControl))
		InputMap.action_add_event(str(action) + str($"../../../..".currentlyEditingControl), event)
		button_pressed = false
		
func update_key_text():
	print(str(action) + str($"../../../..".currentlyEditingControl))
	text = "%s" % InputMap.action_get_events(str(action) + str($"../../../..".currentlyEditingControl))[0].as_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	print(button_pressed)
	if button_pressed:
		text = "...."
		release_focus()
	else:
		update_key_text()
		grab_focus()
	pass # Replace with function body.


func _on_edit_controls_list_item_selected(index):
	update_key_text()
	pass # Replace with function body.
