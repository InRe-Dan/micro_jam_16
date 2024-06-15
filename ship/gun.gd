## Class for simple ship gun
extends Node2D

@onready var bullet_scene: PackedScene = preload("res://ship/bullet.tscn")
@onready var fire_delay: Timer = $Timer

var bullet_container: Node


## Initializes this node
func init(bullet_collection: Node) -> void:
	bullet_container = bullet_collection
	set_process(true)


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)


## Called every process frame
func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if fire_delay.is_stopped():
			fire_delay.start()
			fire()


## Fires the gun
func fire() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.rotation = global_rotation
	bullet_container.add_child(bullet)
