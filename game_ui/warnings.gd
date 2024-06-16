extends Control

@onready var health : Label = $Health
@onready var fuel : Label = $Fuel
@onready var ammo : Label = $Ammo
@onready var player : Ship = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	player.died.connect(queue_free)

func _process(delta : float) -> void:
	health.flashing = player.health < 30
	ammo.flashing = player.ammo < 30
	fuel.flashing = player.fuel < 30
