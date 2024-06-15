# Player controlled ship
class_name Ship extends RigidBody2D

## Rate at which the ship gains velocity while thrusting
@export_range(1, 100, 1) var acceleration: int = 50

## Rate at which the ship gains rotational velocity while turning
@export_range(0.1, 10, 0.1) var torque: float = 4.0

## Maximum velocity the ship is able to reach
@export_range(0.1, 5, 0.1) var terminal_velocity: float = 2.0

## Maximum rotational velocity the ship is able to reach
@export_range(0.1, 1, 0.1) var terminal_rotational_velocity: float = 0.8

## Ship's current rotational velocity
var rotational_velocity: float = 0.0

@onready var camera: Camera2D = $Camera2D


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Check for thrust
	if Input.is_action_pressed("thrust"):
		var direction: Vector2 = -transform.y.normalized()
		linear_velocity += (direction * acceleration) * delta
	
	# Check for spin
	var rotation_input = Input.get_axis("rotate_left", "rotate_right")
	angular_velocity += (rotation_input * torque) * delta
	
	
## Returns the current viewport
func get_view() -> Rect2:
	return Rect2(position, camera.get_viewport().get_visible_rect().size)
