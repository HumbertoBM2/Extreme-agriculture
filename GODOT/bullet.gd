extends Area2D
class_name Bullet

enum {
	PLAYER,
	MOBS
}

var who_shoot

var speed = 750
@onready var hit_sound = get_tree().root.get_child(0).get_node("HitSound")
#@onready var lose_sound = get_tree().root.get_child(0).get_node("LoseSound")

func _on_ready():
	set_as_top_level(true)

func _physics_process(delta):
	position += transform.x * speed * delta
	#set_rotation( - atan2(position.y, position.x) ) 

func with_data(data_) -> Bullet:
	who_shoot = data_
	return self

func _on_body_entered(body):
	
	if body.is_in_group("mobs") and who_shoot == PLAYER:
		hit_sound.play()
		body.queue_free()
		queue_free()
	elif body.is_in_group("player") and who_shoot == MOBS:
		hit_sound.play()
		body.hit()
		queue_free()
