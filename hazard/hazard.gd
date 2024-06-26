## Hazard class
class_name Hazard extends RigidBody2D

## Health of the hazard
@export_range(1, 1000, 1) var health: int = 3

## Distance at which the hazard cleans up
var despawn_distance: float = 3e7

signal cleaned


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HazardManager.cleanup.connect(_on_cleanup_check)


func _process(delta: float) -> void:
	if not modulate == Color.WHITE:
		modulate = modulate.lerp(Color.WHITE, 50.0 * delta)


## Called every clean-up cycle
func _on_cleanup_check() -> void:
	if is_in_group("objective"):
		return

	var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
	if not ship or not is_instance_valid(ship):
		return
	
	if position.distance_squared_to(ship.position) > despawn_distance:
		clean()


## Hazard took damage
func damage(dmg: int) -> void:
	if health > 0:
		modulate = Color(25500, 25500, 25500)
		health -= dmg
		if health <= 0:
			destroy()


## Destroys the hazard
func destroy() -> void:
	clean()


## Removes this hazard
func clean() -> void:
	cleaned.emit()
	queue_free()
