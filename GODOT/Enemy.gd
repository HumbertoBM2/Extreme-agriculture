extends CharacterBody2D

const SPEED = 80.0
const ROTATION_SPEED = 1.5
const carrot_atlas_pos = Vector2i(1, 2)

var tactic_timer = Timer.new()
var randomnum

@onready var bullet_scene = preload("res://bullet.tscn")
@onready var player = get_node("../Tractor")
@onready var parent = get_parent()
@onready var shoot_sound = get_tree().root.get_child(0).get_node("ShootSound")
@onready var root = get_tree().root

var rng = RandomNumberGenerator.new()
var shoot_sum = 0

enum {
	SURROUND,
	AWAY
}

enum {
	PLAYER,
	MOBS
}

var state = SURROUND

func _ready():
	parent = get_parent()

	rng.randomize()
	randomnum = rng.randf()

	#tactic_timer.connect("timeout", change_tactic)
	#tactic_timer.wait_time = rng.randi_range(0, 5)
	#tactic_timer.one_shot = false
	#add_child(tactic_timer)
	#tactic_timer.start()
	
func change_tactic():
	
	#match state:
		#SURROUND:
			#state = AWAY
		#AWAY:
			#state = SURROUND 
	
	tactic_timer.start( rng.randi_range(0, 5) )

func lerp(a, b, t):
	return a + (b - a) * t

func _physics_process(delta):
	
	var af = 0
	
	if rotation < 0:
		af = lerp(0, 39, (rotation / PI))
	else:
		af = lerp(77, 39, (rotation / PI))
	
	af = round(abs(af))
	
	$AnimatedSprite2D.set_frame(af)
	
	if shoot_sum > 3:
		shoot()
		shoot_sum = 0
	
	var v = get_circle_position()
	
	move(v, delta)
	shoot_sum += delta
			
		#AWAY:
			#var new_rand_pos = player.global_position
			#
			#new_rand_pos.x + rng.randi_range(-10, 10)
			#new_rand_pos.y + rng.randi_range(-10, 10)
			#
			#move(new_rand_pos, delta)

func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering

	rotation = atan2( target.y, target.x )# + rng.randf_range(-PI, PI)
	
	move_and_slide()

func get_circle_position():
	var kill_circle_centre = player.global_position
	var radius = 40
	
	var angle = 0.5 * PI * 2
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;
	
	return Vector2(x, y)

func shoot():
	var b = bullet_scene.instantiate().with_data(MOBS)
	root.add_child(b)
	shoot_sound.play()
	
	b.global_transform = global_transform

func _on_start_button_button_down():
	visible = true
