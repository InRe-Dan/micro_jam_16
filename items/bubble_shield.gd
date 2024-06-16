class_name BubbleShield extends Item

@export var cost : int = 30
@export var duration : float = 10.0
@export var repel_acceleration : float = 500

@onready var particles : CPUParticles2D = $Particles
@onready var area : Area2D = $Area2D

var time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var points : Array
	for i in range(300):
		var angle : float = TAU * randf()
		points.append(Vector2.from_angle(angle) * (30 * randf() + 970))
	particles.set_emission_points(points)

func _physics_process(delta: float) -> void:
	if time < 0.1:
		return
	for body in area.get_overlapping_bodies():
		body.linear_velocity += repel_acceleration * global_position.direction_to(body.global_position) * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	if time < 0:
		particles.emitting = false

func use(ammo_available : int) -> int:
	if ammo_available > cost and time < 0.5:
		time = duration
		particles.emitting = true
		return cost
	return 0

func get_ammo_info() -> String:
	return str(cost)
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if time < 0.1:
		return
	print(area.collision_mask)
	if area.collision_mask & 0x1:
		area.queue_free()
