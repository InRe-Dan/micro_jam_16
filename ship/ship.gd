# Player controlled ship
class_name Ship extends RigidBody2D

## Rate at which the ship gains velocity while thrusting
@export_range(1, 100, 1) var acceleration: int = 60
## Rate at which the ship gains rotational velocity while turning
@export_range(0.1, 10.0, 0.1) var torque: float = 1.2
## Maximum velocity the ship is able to reach
@export_range(0.1, 10.0, 0.1) var terminal_velocity: float = 4.0
## Maximum rotational velocity the ship is able to reach
@export_range(0.1, 10.0, 0.1) var terminal_rotational_velocity: float = 4.0
## Braking strength
@export_range(0.0, 1.0, 0.1) var braking_strength: float = 0.5
## Angular braking strength
@export_range(0.0, 10.0, 0.1) var angle_braking_strength: float = 6.0
## Maximum health of the ship
@export_range(1, 1000, 100) var maximum_health: int = 100

## Current health of the ship
@onready var health: float = maximum_health
@onready var camera: Camera2D = $Camera2D
@onready var health_bar : TextureProgressBar = $HealthBar

## Ship's current rotational velocity
var rotational_velocity: float = 0.0

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Check for thrust or brakes
	if Input.is_action_pressed("brake"):
		linear_velocity = linear_velocity.lerp(Vector2.ZERO, braking_strength * delta)
	elif Input.is_action_pressed("thrust"):
		var direction: Vector2 = -transform.y.normalized()
		linear_velocity += (direction * acceleration) * delta
	
	# Check for spin or angle brakes
	if Input.is_action_pressed("angular_brake"):
		angular_velocity = lerpf(angular_velocity, 0.0, angle_braking_strength * delta)
	else:	
		var rotation_input = Input.get_axis("rotate_left", "rotate_right")
		angular_velocity += (rotation_input * torque) * delta
	
	if Input.is_action_just_pressed("fire"):
		$Gun.use()
	
	linear_velocity.limit_length(terminal_velocity)
	angular_velocity = clamp(angular_velocity, -terminal_rotational_velocity, terminal_rotational_velocity)


## Ship dies
func die() -> void:
	print("died!")
	queue_free()


## Makes the ship take damage
func damage(dmg: int) -> void:
	health -= dmg
	if health <= 0:
		die()
	health_bar.value = health / maximum_health

	
## Returns the current viewport
func get_view() -> Rect2:
	return Rect2(position, camera.get_viewport().get_visible_rect().size)


## Ship collided with a body
func _on_collision(body: PhysicsBody2D) -> void:
	if not body is Asteroid:
		return
		
	damage(10)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		camera.zoom += Vector2.ONE * 0.1
	elif event.is_action_pressed("scroll_down"):
		camera.zoom -= Vector2.ONE * 0.1
