class_name Missile extends Bullet

@onready var tracker : Area2D = $Tracker

var vel_v : Vector2
var acceleration : float = 2000

func _ready() -> void:
	# super()
	vel_v = velocity_offset - transform.y.normalized() * velocity * 100

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var targets : Array = tracker.get_overlapping_bodies()
	if targets:
		vel_v += acceleration * global_position.direction_to(targets.front().global_position) * delta

	global_position += vel_v * delta
	global_rotation = vel_v.angle() + PI / 2

func _on_collision(body: Node2D) -> void:
	if not body is Hazard and not body is Ship:
		return
	
	body.damage(damage)
	queue_free()
