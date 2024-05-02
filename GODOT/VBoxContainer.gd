extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	$StartButton.visible = false
	$CreditsButton.visible = false
	$ExitButton.visible = false


func _on_exit_button_pressed():
	get_tree().quit()
