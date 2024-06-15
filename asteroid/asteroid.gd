## Asteroid class
class_name Asteroid extends RigidBody2D

## Health of the asteroid
@export_range(1, 10, 1) var health: int = 3

## Distance at which the asteroid cleans up
@export_range(16, 256, 1) var despawn_distance: int = 32

signal cleanup

var ship: Ship


## Called every clean-up cycle
func _on_cleanup_check() -> void:
	if not ship or not is_instance_valid(ship):
		return
	var viewport_rect: Rect2 = ship.get_view()
	
	# Asteroid is far away
	if position.distance_squared_to(viewport_rect.position) > pow(viewport_rect.size.x + viewport_rect.size.y + despawn_distance, 2.0):
		clean()


## Subscribes this asteroid to the manager's clean-up cycle
func subscribe_to_cleanup(timer: Timer) -> void:
	timer.timeout.connect(_on_cleanup_check)


## Asteroid took damage
func damage(dmg: int) -> void:
	health -= dmg
	if health <= 0:
		destroy()


## Destroys the asteroid
func destroy() -> void:
	clean()


## Removes this asteroid
func clean() -> void:
	cleanup.emit()
	queue_free()
