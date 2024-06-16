# Player controlled ship
class_name Ship extends RigidBody2D

@export_category("Base stats")
## Maximum health of the ship
@export_range(1, 1000, 100) var maximum_health: int = 100
@export var max_ammo : int = 100
@export var laser_sight_length : int = 500
@export var weapon_regen : float = 0

@export_category("Movement")
## Rate at which the ship gains velocity while thrusting
@export_range(1, 500, 1) var acceleration: int = 60
## Additive rate at which the ship gains velocity while boosting
@export_range(1, 500, 1) var boost_acceleration: int = 120
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
@export var passive_burn : float = 0.2
@export var thruster_burn : float = 2.4
@export var boost_burn : float = 4.8
@export var brake_burn : float = 0.4
@export var rotation_burn : float = 0.8

## Current health of the ship
@onready var health: float = maximum_health
## Current fuel
@onready var fuel : float = max_fuel

@onready var sprite: Sprite2D = $Sprite2D
@onready var thrust_sprite: Sprite2D = sprite.get_node("Thrust")
@onready var ammo : int = max_ammo
@onready var iframe_timer: Timer = $Invincibility
@onready var particles : CPUParticles2D = $Thrust
@onready var afterburner_particles : CPUParticles2D = $Afterburner
@onready var forward_ray: RayCast2D = $RayCast2D
@onready var crosshair: Sprite2D = $Crosshair
@onready var laser_sight : Line2D = $LaserSight
@onready var collect_audio: AudioStreamPlayer2D = $CollectAudio

var game_over: PanelContainer

## Ship's current rotational velocity
var rotational_velocity: float = 0.0
var fuel_consumed_this_frame : float = 0
## Measured in units per second
var fuel_consumption : float = 0
var matter : int = 10
var thruster_power : float = 0.0
var afterburner_enabled : bool = false
var regen_timer : float = 0

var stopwatch_time: float = 0.0
var total_matter_collected: int = 0

signal died


## Called every process frame
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("die"):
		die()
	
	stopwatch_time += delta
	var laser_point: float = 0.0
	if forward_ray.is_colliding():
		laser_point = -forward_ray.get_collision_point().distance_to(global_position)
	else:
		laser_point = forward_ray.target_position.y
	crosshair.position.y = laser_point
	laser_sight.points[1] = Vector2(0, -1) * laser_sight_length
	if weapon_regen > 0:
		regen_timer += delta
		if regen_timer > 1 / weapon_regen:
			if ammo < max_ammo:
				ammo += 1
				regen_timer = 0

	if not sprite.modulate == Color.WHITE:
		sprite.modulate = sprite.modulate.lerp(Color.WHITE, 50.0 * delta)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	fuel_consumed_this_frame += passive_burn * delta
	# Check for thrust or brakes
	if Input.is_action_pressed("brake") and fuel > 0:
		linear_velocity = linear_velocity.lerp(Vector2.ZERO, braking_strength * delta)
		fuel_consumed_this_frame += brake_burn * delta

	if Input.is_action_pressed("thrust") and fuel > 0:
		thruster_power += delta * 10.
		var direction: Vector2 = -transform.y.normalized()
		linear_velocity += (direction * acceleration) * delta
		fuel_consumed_this_frame += thruster_burn * delta
		particles.emitting = true
		if afterburner_enabled and Input.is_action_pressed("boost") and fuel > 0:
			linear_velocity += (direction * boost_acceleration) * delta
			fuel_consumed_this_frame += boost_burn * delta
			afterburner_particles.emitting = true
		else:
			afterburner_particles.emitting = false
	else:
		particles.emitting = false
		thruster_power -= delta * 10.
		afterburner_particles.emitting = false
		
	
	thruster_power = clamp(thruster_power, 0., 1.)
	thrust_sprite.modulate.a = thruster_power
	
	var rotation_input = Input.get_axis("rotate_left", "rotate_right")
	if rotation_input and fuel > 0:
		angular_velocity += (rotation_input * torque) * delta
		fuel_consumed_this_frame += rotation_burn * delta
	if rotation_input * angular_velocity <= 0:
		angular_velocity = lerpf(angular_velocity, 0.0, angle_braking_strength * delta)

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
	if game_over and is_instance_valid(game_over):
		game_over.game_over(stopwatch_time, total_matter_collected, false)

	queue_free()


func get_inventory() -> Inventory:
	return $Inventory


## Makes the ship take damage
func damage(dmg: int) -> void:
	if not iframe_timer.is_stopped(): return
	iframe_timer.start()
	sprite.modulate = Color(25500, 25500, 25500)
	health -= dmg
	if health <= 0:
		die()


## Ship collided with a body
func _on_collision(body: Node2D) -> void:
	if not body is Hazard or body.is_in_group("ranged_enemy"):
		return
	damage(10)


func give_matter(amount : int) -> void:
	matter += amount
	total_matter_collected += amount


func _on_matter_magnet_matter_picked_up() -> void:
	collect_audio.play()
	give_matter(1)
