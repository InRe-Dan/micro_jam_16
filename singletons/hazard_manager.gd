## Manages the spawning and despawning of hazards
extends Node

signal cleanup

## Maximum amount of active hazards
@export_range(1, 128, 1) var active_count: int = 48

## Spawn weights of hazards
@export var spawn_weights: Array[SpawnWeight] = []

## Minimum distance to spawn from the player
@export_range(2000, 10000, 1) var min_dist: float = 3000
## Maximum distance to spawn from the player
@export_range(3000, 10000, 1) var max_dist : float = 6000

## Spawn velocity scale
@export_range(0, 5000, 10) var velocity_scale: int = 100

var asteroid_scene: PackedScene = preload("res://hazard/asteroid.tscn")
var large_asteroid_scene: PackedScene = preload("res://hazard/large_asteroid.tscn")
var mine_scene: PackedScene = preload("res://hazard/mine.tscn")

@onready var ship: Ship = get_tree().get_first_node_in_group("player")
var stopped = false

signal start

func stop() -> void:
	stopped = true


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(active_count):
		create_new_hazard()
	ship.died.connect(stop)


## Called when an hazard is freed
func _on_hazard_cleanedup() -> void:
	# Spawn a new hazard in place of the old one
	call_deferred("create_new_hazard")


## Creates a new random hazard
func create_new_hazard() -> void:
	if stopped or not ship or not is_instance_valid(ship): return
	
	# Cache spawn weights
	var total_weight: float = 0.0
	var weights_sampled: Array[Dictionary] = []
	var difficulty = 0.0
	var objective = get_tree().get_first_node_in_group("objective")
	if is_instance_valid(objective):
		difficulty = min(1, abs(1.0 - (ship.position.distance_squared_to(objective.position) / 1.6e11)))

	for spawn_weight: SpawnWeight in spawn_weights:
		var weight: float = spawn_weight.weight.sample(difficulty)
		total_weight += weight
		weights_sampled.append({
			"scene": spawn_weight.hazard,
			"weight": weight
		})
	
	# Choose random hazard from cache
	var spawn_choice = randf_range(0, total_weight)
	var hazard: Hazard
	var cumulative_weight: float = 0.0
	for spawn_weight: Dictionary in weights_sampled:
		cumulative_weight += spawn_weight["weight"]
		if spawn_choice <= cumulative_weight:
			hazard = spawn_weight["scene"].instantiate() as Hazard
			break
	
	call_deferred("spawn_hazard", hazard)
	hazard.cleaned.connect(_on_hazard_cleanedup)


## Spawns a new hazard by instance
func spawn_hazard(hazard: Hazard, spawn_position: Vector2 = Vector2.INF) -> void:
	if stopped:
		hazard.clean()
		return
	
	if spawn_position.is_equal_approx(Vector2.INF):
		var distance : float = randf() * (max_dist - min_dist) + min_dist
		spawn_position = Vector2.from_angle(randf() * TAU) * distance + ship.global_position
	
	# Determine random velocity. Speed will be 30-100% of speed scale.
	var spawn_velocity: Vector2 = Vector2.from_angle(TAU * randf()) * velocity_scale * (randf() * 0.7 + 0.3)
	
	hazard.position = spawn_position
	hazard.linear_velocity = spawn_velocity
	
	add_child(hazard)


## Clean up cycle
func _on_timeout():
	cleanup.emit()
