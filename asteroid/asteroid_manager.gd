## Manages the spawning and despawning of asteroids
extends Node

## Maximum amount of active asteroids
@export_range(1, 128, 1) var active_count: int = 24

## Buffered distance on asteroids spawning outside of view
@export_range(0, 256, 1) var buffer_distance: int = 0

var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(active_count):
		spawn_asteroid()


## Called when an asteroid is freed
func _on_asteroid_freed() -> void:
	pass


## Creates a new asteroid
func spawn_asteroid() -> void:
	var viewport_rect: Rect2 = get_viewport().get_visible_rect()
	
	# Determine random spawn location
	var spawn_position: Vector2
	var side = randi() % 4
	print(side)
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
	
	var asteroid: Asteroid = asteroid_scene.instantiate() as Asteroid
	asteroid.position = spawn_position
	add_child(asteroid)
