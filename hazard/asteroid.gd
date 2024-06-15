## Asteroid class
class_name Asteroid extends Hazard

## Scale of the random angular velocity
@export var angular_velocity_scale: float = 2.5

@export var matter_spawn_distribution : Curve

var matter_scene : PackedScene = preload("res://collectable/matter_fragment.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not matter_spawn_distribution: push_error("No spawn curve assigned")
	self.angular_velocity = randf_range(-angular_velocity_scale, angular_velocity_scale)


## Destroys the asteroid
func destroy() -> void:
	for i in range(matter_spawn_distribution.sample(randf())):
		var matter : MatterFragment = matter_scene.instantiate()
		add_sibling.call_deferred(matter)
		var direction = Vector2.from_angle(TAU * randf())
		matter.global_position = global_position + direction * (30 + randf() * 60)
		matter.rotation = randf() * TAU
		matter.velocity = direction * (30 + randf() * 50)
		matter.angular_velocity = (randf() - 0.5) * 0.5
	
	super()
