extends CharacterBody2D

const SPEED = 400.0
const ROTATION_SPEED = 1.5

const carrot_atlas_pos = Vector2i(1, 2)
var parent

enum {
	PLAYER,
	MOBS
}

var carrot_indicators = {}
var start_btn_state = false

@export var TOTAL_CARROTS = 1
@onready var bullet_scene = preload("res://bullet.tscn")
@onready var shoot_sound = get_tree().root.get_child(0).get_node("ShootSound")
@onready var root = get_tree().root

func _ready():
	parent = get_parent()
	
	for i in $Overlay/Control/HBoxContainer.get_children():
		carrot_indicators[ int(i.name.split("_")[1]) ] = i

func lerp(a, b, t):
	return a + (b - a) * t

func _physics_process(delta):
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if !start_btn_state:
		return
	
	var move_input = Input.get_axis("ui_down", "ui_up")
	var rotation_direction = Input.get_axis("ui_left", "ui_right")
	
	velocity = transform.x * move_input * SPEED
	rotation += rotation_direction * ROTATION_SPEED * delta
	
	var af = 0
	
	if rotation < 0:
		af = lerp(0, 39, (rotation / PI))
	else:
		af = lerp(77, 39, (rotation / PI))
	
	af = round(abs(af))
	
	$AnimatedSprite2D.set_frame(af)
	
	var current_tile = parent.local_to_map(position)
	var left_tile = parent.local_to_map(position) - Vector2i(1, 0)
	var right_tile = parent.local_to_map(position) + Vector2i(1, 0)
	var up_tile = parent.local_to_map(position) + Vector2i(0, 1)
	var down_tile = parent.local_to_map(position) - Vector2i(0, 1)
	
	if parent.get_cell_atlas_coords(0, current_tile) == carrot_atlas_pos:
		carrot_detect(current_tile)
		
	if parent.get_cell_atlas_coords(0, left_tile) == carrot_atlas_pos:
		carrot_detect(left_tile)
		
	if parent.get_cell_atlas_coords(0, right_tile) == carrot_atlas_pos:
		carrot_detect(right_tile)
		
	if parent.get_cell_atlas_coords(0, up_tile) == carrot_atlas_pos:
		carrot_detect(up_tile)
		
	if parent.get_cell_atlas_coords(0, down_tile) == carrot_atlas_pos:
		carrot_detect(down_tile)
	
	move_and_slide()

func shoot():
	var b = bullet_scene.instantiate().with_data(PLAYER)
	root.add_child(b)
	shoot_sound.play()
	
	b.global_transform = global_transform
	
func carrot_detect(pos):
	if TOTAL_CARROTS < 7:
		TOTAL_CARROTS += 1
	
	get_parent().timer.start(30)
	
	var t = Vector2i(1, 0)
	parent.set_cell( 0, pos, 4, t)
	
	for i in range(TOTAL_CARROTS):
		carrot_indicators[i + 1].visible = true

func get_carrots() -> int:
	return TOTAL_CARROTS

func hit():
	if TOTAL_CARROTS-1 == 0:
		TOTAL_CARROTS -= 1
		get_tree().change_scene_to_file("res://gameover.tscn")
	
	TOTAL_CARROTS -= 1
	
	for i in range(7):
		carrot_indicators[i + 1].visible = false
		
	for i in range(TOTAL_CARROTS):
		carrot_indicators[i + 1].visible = true

func _on_start_button_pressed():
	start_btn_state = true
