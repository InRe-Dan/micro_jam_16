class_name TractorCannon extends Item

@export var ammo_spend_interval : float = 0.2
@export var matter_acceleration : float = 1000

@onready var suck : CPUParticles2D = $Suck
@onready var area : Area2D = $Area2D

var fire_time : float
var rollover_time : float


## Uses this item. Must check for item durability.
## Returns how much durability should be spent.
func use(ammo_available : int) -> int:
	if ammo_available > 0 and fire_time == 0:
		rollover_time = 0.05
		fire_time = ammo_spend_interval
		return 1
	return 0

## This is a string, so you can return 30/60, 30, 50% etc.
## Only used for the purposes of UI.
func get_ammo_info() -> String:
	return str(1 / ammo_spend_interval) + "/s"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var points : Array
	for i in range(300):
		var angle : float = (PI * 1.25) + (PI / 2) * (i / 300.)
		points.append(Vector2.from_angle(angle) * (1600 * randf() + 400))
	suck.set_emission_points(points)

func _physics_process(delta: float) -> void:
	if fire_time <= 0 and rollover_time <= 0:
		return
	for matter : MatterFragment in area.get_overlapping_areas():
		matter.velocity += matter_acceleration * matter.global_position.direction_to(global_position) * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	suck.emitting = selected
	fire_time -= delta
	fire_time = max(fire_time, 0)
	if fire_time == 0:
		rollover_time -= delta
	if fire_time <= 0 and rollover_time <= 0:
		suck.radial_accel_max = 0
		suck.radial_accel_min = 0
	else:
		suck.radial_accel_max = -1000
		suck.radial_accel_min = -1000
	
