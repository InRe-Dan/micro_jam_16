# Enemy controlled ship
class_name Enemy extends Hazard

@export_category("Movement")
## Rate at which the ship gains velocity while thrusting
@export_range(0, 500, 1) var acceleration: int = 180
## Rate at which the ship turns
@export_range(0.1, 10.0, 0.1) var turn_speed: float = 4.0
## Maximum velocity the ship is able to reach
@export_range(0.00, 0.1, 0.01) var terminal_velocity: float = 0.06
## Braking strength
@export_range(0.0, 10.0, 0.1) var braking_strength: float = 5.0
## Engage distance
@export var engagement_distance: float = 2e6

## Look angle at which it will start to thrust towards target
const look_threshold: float = PI/6

@onready var sprite: Sprite2D = $Sprite2D
@onready var thrust_sprite: Sprite2D = sprite.get_node("Thrust")
@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var weapon: Item = $Weapon

signal died

@onready var explosion_animation = $AnimationPlayer
@onready var explosion: Area2D = $Explosion


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
	if not ship or not is_instance_valid(ship):
		return
	
	# Always trying to face player
	rotation = lerp_angle(rotation, (position - ship.position).angle() - PI/2, delta * 10 * turn_speed)

	
	var facing_vector = Vector2(cos(rotation), sin(rotation))
	var is_facing: bool = abs(facing_vector.angle_to((position - ship.position).normalized()) - PI/2) < look_threshold
	var is_far: bool = position.distance_squared_to(ship.position) > engagement_distance
	if is_facing:
		if is_far:
			# Begin thrusting
			var direction: Vector2 = -transform.y.normalized()
			linear_velocity += (direction * acceleration) * delta
			particles.emitting = true
		else:
			# Begin shooting
			weapon.use(weapon.ammo_per_shot)
	else:
		particles.emitting = false
	
	linear_velocity.limit_length(terminal_velocity)
	
	# Always braking
	linear_velocity = linear_velocity.move_toward(Vector2.ZERO, delta * 10 * braking_strength)

	if health <= 0:
		particles.emitting = false


## Destroys the asteroid
func destroy() -> void:
	explosion_animation.play("explosion")
	

## Explodes
func explode() -> void:
	for body: Node2D in explosion.get_overlapping_bodies():
		if not body is Hazard and not body is Ship:
			continue
		
		body.damage(4)
