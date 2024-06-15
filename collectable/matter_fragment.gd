class_name MatterFragment extends Area2D

@export var despawn_distance: float = 6e7

var velocity : Vector2
var angular_velocity : float

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MatterCleanupTimer.matter_clean.connect(check_cleanup)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += velocity * delta
	velocity = velocity / (1 + 0.3 * delta)
	rotation += angular_velocity * delta


## Fragment collected by player
func pickup() -> void:
	clean()
	

## Clean up this fragment
func clean() -> void:
	queue_free()


## Checks for clean up
func check_cleanup() -> void:
	var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
	if not ship or not is_instance_valid(ship):
		return
		
	if position.distance_squared_to(ship.position) > despawn_distance:
		clean()
