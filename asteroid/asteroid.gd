## Asteroid class
class_name Asteroid extends RigidBody2D

## Health of the asteroid
@export_range(1, 10, 1) var health: int = 3

## Distance at which the asteroid cleans up
var despawn_distance: int = 6000

signal cleanup

var ship: Ship


## Called every clean-up cycle
func _on_cleanup_check() -> void:

	if get_viewport().get_camera_2d().global_position.distance_to(global_position) > despawn_distance:
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
