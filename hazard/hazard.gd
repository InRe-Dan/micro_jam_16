## Hazard class
class_name Hazard extends Node2D

## Health of the hazard
@export_range(1, 10, 1) var health: int = 3

## Distance at which the hazard cleans up
var despawn_distance: float = 4e7

signal cleanup


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HazardManager.cleanup.connect(_on_cleanup_check)


## Called every clean-up cycle
func _on_cleanup_check() -> void:
	var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
	if not ship or not is_instance_valid(ship):
		return
		
	if position.distance_squared_to(ship.position) > despawn_distance:
		clean()


## Hazard took damage
func damage(dmg: int) -> void:
	health -= dmg
	if health <= 0:
		destroy()


## Destroys the hazard
func destroy() -> void:
	clean()


## Removes this hazard
func clean() -> void:
	cleanup.emit()
	queue_free()
