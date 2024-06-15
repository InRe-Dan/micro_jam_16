## Manages the spawning and despawning of asteroids
extends Node

## Maximum amount of active asteroids
@export_range(1, 128, 1) var active_count: int = 16

## Buffered distance on asteroids spawning outside of view
@export_range(0, 256, 1) var buffer_distance: int = 0

## Spawn velocity scale
@export_range(0, 1000, 10) var velocity_scale: int = 100

## Spawn angular velocity scale
@export_range(0, 100, 1) var angular_velocity_scale: int = 10

var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")
@onready var cleanup_timer: Timer = $CleanupCycle

var ship: Ship


## Initializes this node
func init(_ship: Ship) -> void:
	self.ship = _ship
	for i in range(active_count):
		spawn_asteroid()


## Called when an asteroid is freed
func _on_asteroid_cleanedup() -> void:
	# Spawn a new asteroid in place of the old one
	spawn_asteroid()


## Creates a new asteroid
func spawn_asteroid() -> void:
	if not ship or not is_instance_valid(ship):
		return
	var viewport_rect: Rect2 = ship.get_view()
	
	# Determine random spawn location
	var side = randi() % 4
	var spawn_position: Vector2 = Vector2.ZERO
	match side:
		0: # Top side
			spawn_position.x = randf_range(-viewport_rect.size.x / 2, viewport_rect.size.x / 2)
			spawn_position.y = (viewport_rect.position.y - viewport_rect.size.y / 2) - buffer_distance
		1: # Bottom side
			spawn_position.x = randf_range(-viewport_rect.size.x / 2, viewport_rect.size.x / 2)
			spawn_position.y = (viewport_rect.position.y + viewport_rect.size.y / 2) + buffer_distance
		2: # Left side
			spawn_position.x = (viewport_rect.position.x - viewport_rect.size.x / 2) - buffer_distance
			spawn_position.y = randf_range(-viewport_rect.size.y / 2, viewport_rect.size.y / 2)
		_: # Right side
			spawn_position.x = (viewport_rect.position.x + viewport_rect.size.x / 2) + buffer_distance
			spawn_position.y = randf_range(-viewport_rect.size.y / 2, viewport_rect.size.y / 2)
	
	# Determine random velocity
	var spawn_velocity: Vector2 = Vector2(randf_range(-1, 1) * velocity_scale, randf_range(-1, 1) * velocity_scale)
	
	var asteroid: Asteroid = asteroid_scene.instantiate() as Asteroid
	asteroid.position = spawn_position
	asteroid.linear_velocity = spawn_velocity
	asteroid.angular_velocity = randf_range(-angular_velocity_scale, angular_velocity_scale)
	asteroid.ship = ship
	asteroid.cleanup.connect(_on_asteroid_cleanedup)
	asteroid.subscribe_to_cleanup(cleanup_timer)
	
	add_child(asteroid)
