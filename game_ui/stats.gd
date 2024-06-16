extends VBoxContainer

@onready var player : Ship = get_tree().get_first_node_in_group("player")
@onready var health : TextureProgressBar = $HBoxContainer2/HealthBar
@onready var fuel : TextureProgressBar = $HBoxContainer/FuelBar
@onready var ammo : TextureProgressBar = $Ammo/AmmoBar
@onready var burn : Label = $Burn
@onready var matter : Label = $Matter

@onready var hull_text : Label = $HBoxContainer2/HealthBar/HBoxContainer/Label2
@onready var fuel_text : Label = $HBoxContainer/FuelBar/HBoxContainer/Label2
@onready var weapons_text : Label = $Ammo/AmmoBar/HBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.died.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	health.value = player.health / player.maximum_health
	fuel.value = player.fuel / player.max_fuel
	ammo.value = float(player.ammo) / player.max_ammo
	var c : float = player.fuel_consumption
	var rounded : float = (round(c*pow(10,3))/pow(10,3))
	burn.text = "Fuel consumption: " + str(rounded)
	matter.text = "Matter: " + str(player.matter)

	hull_text.text = str(player.health) + "/" + str(player.maximum_health) + " "
	fuel_text.text = str(int(player.fuel)) + "/" + str(int(player.max_fuel)) + " "
	weapons_text.text = str(player.ammo) + "/" + str(player.max_ammo) + " "

func _on_fuel_bought() -> void:
	if player.matter > 0 and player.fuel < player.max_fuel:
		player.matter -= 1
		player.fuel += player.max_fuel * 0.1


func _on_repair_bought() -> void:
	if player.matter > 0 and player.health < player.maximum_health:
		player.matter -= 1
		player.health += player.maximum_health * 0.05
		player.health = clamp(player.health, 0, player.maximum_health)


func _on_buy_ammo_pressed() -> void:
	if player.matter > 0 and player.ammo < player.max_ammo:
		player.matter -= 1
		player.ammo += player.max_ammo * 0.1
		player.ammo = clamp(player.ammo, 0, player.max_ammo)
