class_name Bullet extends Area2D

var damage: int = 1

## Bullet's velocity
@export_range(1.0, 50.0, 0.1) var velocity: float = 5.0

## Velocity of the thing that fired the bullet
var velocity_offset : Vector2

@onready var ricochet_scene = preload("res://items/ricochet.tscn")


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= transform.y.normalized() * velocity * 100 * delta
	global_position += velocity_offset * delta


## Bullet collided with an asteroid
func _on_collision(body: Node2D) -> void:
	if not body is Hazard and not body is Ship:
		return

	var exp : CPUParticles2D = ricochet_scene.instantiate()
	exp.finished.connect(exp.queue_free)
	add_sibling(exp)
	exp.global_position = global_position
	exp.global_rotation = global_rotation
	exp.emitting = true
	body.damage(damage)
	queue_free()


## Bullet reached end of its lifetime
func _on_lifetime_timeout():
	queue_free()
