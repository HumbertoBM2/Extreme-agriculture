extends Control

@onready var lose_sound = get_tree().root.get_child(0).get_node("LoseSound")

func _ready():
	lose_sound.play()

func _on_play_again_label_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file("res://game.tscn")
