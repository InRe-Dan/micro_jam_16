## Manages the spawning and despawning of asteroids
extends Node

## Maximum amount of active asteroids
@export_range(1, 128, 1) var active_count: int = 32

## Minimum distance to spawn from the player
@export_range(2500, 10000, 1) var min_dist: float = 0
## Maximum distance to spawn from the player
@export_range(3000, 10000, 1) var max_dist : float = 5000

## Spawn velocity scale
@export_range(0, 5000, 10) var velocity_scale: int = 100

## Spawn angular velocity scale
@export_range(0.0, 10.0, 0.1) var angular_velocity_scale: float = 2.0

var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")
@onready var cleanup_timer: Timer = $CleanupCycle

@onready var ship: Ship = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	for i in range(active_count):
		spawn_asteroid()



## Called when an asteroid is freed
func _on_asteroid_cleanedup() -> void:
	# Spawn a new asteroid in place of the old one
	call_deferred("spawn_asteroid")


## Creates a new asteroid
func spawn_asteroid() -> void:
	
	var distance : float = randf() * (max_dist - min_dist) + min_dist
	var spawn_position: Vector2 = Vector2.from_angle(randf() * TAU) * distance + ship.global_position
	
	# Determine random velocity. Speed will be 30-100% of speed scale.
	var spawn_velocity: Vector2 = Vector2.from_angle(TAU * randf()) * velocity_scale * (randf() * 0.7 + 0.3)
	
	var asteroid: Asteroid = asteroid_scene.instantiate() as Asteroid
	asteroid.position = spawn_position
	asteroid.linear_velocity = spawn_velocity
	asteroid.angular_velocity = randf_range(-angular_velocity_scale, angular_velocity_scale)
	asteroid.ship = ship
	asteroid.cleanup.connect(_on_asteroid_cleanedup)
	asteroid.subscribe_to_cleanup(cleanup_timer)
	
	add_child(asteroid)
