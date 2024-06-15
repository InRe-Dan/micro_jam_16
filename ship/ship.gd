# Player controlled ship
extends CharacterBody2D

## Rate at which the ship gains velocity while thrusting
@export_range(0.1, 10, 0.1) var acceleration: float = 10.0

## Rate at which the ship gains rotational velocity while turning
@export_range(0.1, 10, 0.1) var torque: float = 2.0

## Maximum velocity the ship is able to reach
@export_range(1, 100, 1) var terminal_velocity: float = 5.0

## Maximum rotational velocity the ship is able to reach
@export_range(1, 100, 1) var terminal_rotational_velocity: float = 2.0

## Ship's current rotational velocity
var rotational_velocity: float = 0.0


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Check for thrust
	if Input.is_action_pressed("thrust"):
		var direction: Vector2 = -transform.y.normalized()
		velocity += (direction * acceleration) * delta
	
	# Check for spin
	var rotation_input = Input.get_axis("rotate_left", "rotate_right")
	rotational_velocity += (rotation_input * torque) * delta
	
	# Apply velocity
	move_and_slide()
	rotation += rotational_velocity * delta
