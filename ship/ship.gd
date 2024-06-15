# Player controlled ship
class_name Ship extends RigidBody2D

@export_category("Base stats")
## Maximum health of the ship
@export_range(1, 1000, 100) var maximum_health: int = 100

@export_category("Movement")
## Rate at which the ship gains velocity while thrusting
@export_range(1, 500, 1) var acceleration: int = 60
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

@export_category("Fuel Consumption")
@export var max_fuel : float = 100
@export var passive_burn : float = 0.5
@export var thruster_burn : float = 3.0
@export var brake_burn : float = 0.5
@export var rotation_burn : float = 1.0

## Current health of the ship
@onready var health: float = maximum_health
@onready var fuel : float = max_fuel
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

## Ship's current rotational velocity
var rotational_velocity: float = 0.0
var fuel_consumed_this_frame : float = 0
## Measured in units per second
var fuel_consumption : float = 0
var matter : int = 0

signal died

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	fuel_consumed_this_frame += passive_burn * delta
	# Check for thrust or brakes
	if Input.is_action_pressed("brake") and fuel > 0:
		linear_velocity = linear_velocity.lerp(Vector2.ZERO, braking_strength * delta)
		fuel_consumed_this_frame += brake_burn * delta

	if Input.is_action_pressed("thrust") and fuel > 0:
		sprite.play("thrust")
		var direction: Vector2 = -transform.y.normalized()
		linear_velocity += (direction * acceleration) * delta
		fuel_consumed_this_frame += thruster_burn * delta
	else:
		sprite.play("idle")
	
	# Check for spin or angle brakes
	if Input.is_action_pressed("angular_brake") and fuel > 0:
		angular_velocity = lerpf(angular_velocity, 0.0, angle_braking_strength * delta)
		fuel_consumed_this_frame += brake_burn * delta
	else:	
		var rotation_input = Input.get_axis("rotate_left", "rotate_right")
		if rotation_input:
			angular_velocity += (rotation_input * torque) * delta
			fuel_consumed_this_frame += rotation_burn * delta
	
	if Input.is_action_pressed("fire"):
		$Inventory.use()
	
	linear_velocity.limit_length(terminal_velocity)
	angular_velocity = clamp(angular_velocity, -terminal_rotational_velocity, terminal_rotational_velocity)
	
	fuel -= fuel_consumed_this_frame
	fuel = clamp(fuel, 0, max_fuel)
	fuel_consumption = fuel_consumed_this_frame / delta
	fuel_consumed_this_frame = 0


## Ship dies
func die() -> void:
	died.emit()
	queue_free()


## Makes the ship take damage
func damage(dmg: int) -> void:
	health -= dmg
	if health <= 0:
		die()

## Ship collided with a body
func _on_collision(body: PhysicsBody2D) -> void:
	if not body is Asteroid:
		return
	damage(10)


func _on_matter_magnet_matter_picked_up() -> void:
	matter += 1
	print(matter)
