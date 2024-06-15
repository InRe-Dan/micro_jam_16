## Asteroid class
class_name Asteroid extends RigidBody2D

## Health of the asteroid
@export_range(1, 10, 1) var health: int = 3
## Distance at which the asteroid cleans up
@export var despawn_distance: int = 6000
@export var matter_spawn_distribution : Curve

var ship: Ship
var matter_scene : PackedScene = preload("res://asteroid/matter_fragment.tscn")

signal cleanup

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
	for i in range(matter_spawn_distribution.sample(randf())):
		var matter : MatterFragment = matter_scene.instantiate()
		add_sibling(matter)
		var direction = Vector2.from_angle(TAU * randf())
		matter.global_position = global_position + direction * (30 + randf() * 60)
		matter.rotation = randf() * TAU
		matter.velocity = direction * (30 + randf() * 50)
		matter.angular_velocity = (randf() - 0.5) * 0.5
	clean()


## Removes this asteroid
func clean() -> void:
	cleanup.emit()
	queue_free()
