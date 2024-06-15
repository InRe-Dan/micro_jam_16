extends VBoxContainer

@onready var player : Ship = get_tree().get_first_node_in_group("player")
@onready var health : TextureProgressBar = $HBoxContainer2/HealthBar
@onready var fuel : TextureProgressBar = $HBoxContainer/FuelBar
@onready var burn : Label = $Burn
@onready var matter : Label = $Matter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.died.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health.value = player.health / player.maximum_health
	fuel.value = player.fuel / player.max_fuel
	var c : float = player.fuel_consumption
	var rounded : float = (round(c*pow(10,3))/pow(10,3))
	burn.text = "Fuel consumption: " + str(rounded)
	matter.text = "Matter: " + str(player.matter)

func _on_fuel_bought() -> void:
	if player.matter > 0:
		player.matter -= 1
		player.fuel += player.max_fuel * 0.1


func _on_repair_bought() -> void:
	if player.matter > 0:
		player.matter -= 1
		player.health += player.maximum_health * 0.05
		player.health = clamp(player.health, 0, player.maximum_health)
