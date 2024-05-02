extends Control

var initial_pos

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	var parent_rotation = get_parent().rotation
	set_rotation(- parent_rotation )
	
	var tcam = get_parent().get_node("TractorCamera")
	
	global_position.x = tcam.get_screen_center_position().x - 800
	global_position.y = tcam.get_screen_center_position().y - 440

func _on_pause_label_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$Opaque.show()
		$ResumeLabel.show()
		$PauseLabel.hide()
		get_tree().paused = true


func _on_resume_label_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		$Opaque.hide()
		$ResumeLabel.hide()
		$PauseLabel.show()
