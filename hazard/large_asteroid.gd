## Large Asteroid class
class_name LargeAsteroid extends Hazard

## Scale of the random angular velocity
@export var angular_velocity_scale: float = 1.2

## Spawn curve for lesser asteroids
@export var asteroid_spawn_distribution : Curve

var asteroid_scene : PackedScene = preload("res://hazard/asteroid.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if not asteroid_spawn_distribution: push_error("No spawn curve assigned")
	self.angular_velocity = randf_range(-angular_velocity_scale, angular_velocity_scale)


## Destroys the asteroid
func destroy() -> void:
	# Spawn one asteroid worth of matter
	var matter_asteroid: Asteroid = asteroid_scene.instantiate() as Asteroid
	HazardManager.call_deferred("spawn_hazard", matter_asteroid as Hazard, position)
	matter_asteroid.call_deferred("destroy")
	
	for i in range(round(asteroid_spawn_distribution.sample(randf()))):
		var asteroid: Asteroid = asteroid_scene.instantiate()
		HazardManager.call_deferred("spawn_hazard", asteroid as Hazard, position)
	
	super()
