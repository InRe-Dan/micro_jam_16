class_name Bullet extends Area2D

## Bullet's damage
@export_range(0, 10, 1) var damage: int = 1

## Bullet's velocity
@export_range(1.0, 10.0, 0.1) var velocity: float = 5.0


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= transform.y.normalized() * velocity * 100 * delta


## Bullet collided with an asteroid
func _on_collision(body: PhysicsBody2D) -> void:
	if not body is Asteroid:
		return
	
	body.damage(damage)
	queue_free()


## Bullet reached end of its lifetime
func _on_lifetime_timeout():
	queue_free()
