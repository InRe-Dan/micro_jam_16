class_name Bullet extends Area2D

var damage: int = 1

## Bullet's velocity
@export_range(1.0, 50.0, 0.1) var velocity: float = 5.0

## Velocity of the thing that fired the bullet
var velocity_offset : Vector2


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= transform.y.normalized() * velocity * 100 * delta
	global_position += velocity_offset * delta


## Bullet collided with an asteroid
func _on_collision(body: PhysicsBody2D) -> void:
	if not body is Asteroid:
		return
	
	body.damage(damage)
	queue_free()


## Bullet reached end of its lifetime
func _on_lifetime_timeout():
	queue_free()
