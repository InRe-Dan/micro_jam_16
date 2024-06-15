## Main script
extends Node2D

@onready var ship: Ship = $Ship


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AsteroidManager.init(ship)
	ship.get_node("Gun").init($BulletCollection)
