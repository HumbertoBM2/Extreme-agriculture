extends TileMap

const boundary_atlas_pos = Vector2i(0, 3)
const rocket_atlas_pos = Vector2i(5, 0)
const carrot_atlas_pos = Vector2i(1, 2)
const tall_grass_atlas_pos = Vector2i(1, 0)
const main_source = 4

var tween : Tween
var timer = Timer.new()
var plant_timer = Timer.new()
var enemy_timer = Timer.new()
var time_left = 0

var enemy = preload("res://enemy.tscn")

func _ready() -> void:
	place_boundaries()

func place_boundaries():
	var offsets = [
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(1, 0),
		Vector2i(-1, 0),
	]
	
	var used = get_used_cells(0)
	
	for spot in used:
		for offset in offsets:
			var current_spot = spot + offset
			if get_cell_source_id(0, current_spot) == -1:
				set_cell(0, current_spot, main_source, boundary_atlas_pos)
				set_cell(1, spot, main_source, rocket_atlas_pos)

func _process(delta):
	time_left = round(timer.time_left * pow(1.0, 1)) / pow(1.0, 1)
	$Tractor/Overlay/CountdownLabel.text = str( time_left )
	
	$Tractor/Overlay/TotalLabel.text = str( $Tractor.TOTAL_CARROTS )
	
	pass
	
func first_transition():
	$Tractor.position = map_to_local( Vector2i(2, 7) )
	
	var title_camera = get_parent().get_node("TitleCamera")
	title_camera.enabled = false
	
	var tractor_camera = $Tractor.get_node("TractorCamera")
	tractor_camera.enabled = true
	
	var camera_tween = create_tween()
	camera_tween.tween_property(tractor_camera, "position", Vector2(0, 0), 1.0)
	camera_tween.connect("finished", second_transition)
	
func second_transition():
	$Tractor/Overlay.visible = true
	
	timer.connect("timeout", times_up)
	timer.wait_time = 30
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	plant_timer.connect("timeout", spawn_time)
	plant_timer.wait_time = 2
	plant_timer.one_shot = false
	add_child(plant_timer)
	plant_timer.start()
	
	enemy_timer.connect("timeout", spawn_enemy)
	enemy_timer.wait_time = 5
	enemy_timer.one_shot = false
	add_child(enemy_timer)
	enemy_timer.start()

func times_up():
	get_tree().change_scene_to_file("res://gameover.tscn")
	print("times up!")

func spawn_time():
	var used = get_used_cells_by_id(0, -1, tall_grass_atlas_pos)
	
	set_cell(0, used.pick_random(), main_source, carrot_atlas_pos)
	
	plant_timer.start()

func spawn_enemy():
	var instance = enemy.instantiate()
	
	instance.position.x = 0
	instance.position.y = 0
	
	add_child(instance)

func _on_start_button_pressed():
	tween = create_tween()
	
	tween.tween_property(self, "position:y", -100, 5.0)
	tween.connect("finished", first_transition)
	
func get_time_left():
	return time_left
