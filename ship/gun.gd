## Class for simple ship gun
extends Node2D

@onready var bullet_scene: PackedScene = preload("res://ship/bullet.tscn")
@export var fire_delay: float = 1 / 30.

## Nodes representing where bullets should be spawned
@export var firing_positions : Array[Node2D]

var bullet_container: Node
## Which gun should be fired next
var gun_index : int = 0
var time_since_fired : float = 0

func use() -> void:
	if time_since_fired >= fire_delay:
		time_since_fired = 0;
		fire()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(firing_positions.size() > 0)
	bullet_container = get_tree().get_first_node_in_group("main")
	

func next_position() -> Vector2:
	gun_index += 1
	print(gun_index)
	gun_index = gun_index % firing_positions.size()
	return firing_positions[gun_index].global_position

func _process(delta: float) -> void:
	time_since_fired += delta

## Fires the gun
func fire() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	var pos : Vector2 = next_position()
	bullet.position = pos
	bullet.rotation = global_rotation
	bullet_container.add_child(bullet)
