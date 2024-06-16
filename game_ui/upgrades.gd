extends VBoxContainer

@onready var label : Label = $"../../Description"
@onready var player : Ship = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is HBoxContainer:
			child.hovered.connect(update_text)

func update_text(text : String) -> void:
	label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_health_purchased(level: int) -> void:
	match level:
		1:
			player.maximum_health += 20
			player.health += 20
		2:
			player.maximum_health += 15
			player.health += 15
		3:
			player.maximum_health += 15
			player.health += 15
		4:
			player.maximum_health += 10
			player.health += 10
		5:
			player.maximum_health += 10
			player.health += 10
		6:
			player.maximum_health += 10
			player.health += 10
		7:
			player.maximum_health += 10
			player.health += 10
		8:
			player.maximum_health += 10
			player.health += 10
		_:
			push_error("Unimplemented upgrade bought.")


func _on_speed_purchased(level: int) -> void:
	match level:
		1:
			player.acceleration += 30
		2:
			player.acceleration += 30
		3:
			player.acceleration += 30
		4:
			player.acceleration += 30
		5:
			player.acceleration += 30
		6:
			player.acceleration += 30
		7:
			player.acceleration += 30
		8:
			player.acceleration += 30
		_:
			push_error("Unimplemented upgrade bought.")


func _on_brake_purchased(level: int) -> void:
	match level:
		1:
			player.braking_strength += 0.05
		2:
			player.braking_strength += 0.05
		3:
			player.braking_strength += 0.05
		4:
			player.braking_strength += 0.05
		5:
			player.braking_strength += 0.05
		6:
			player.braking_strength += 0.05
		7:
			player.braking_strength += 0.05
		8:
			player.braking_strength += 0.05
		_:
			push_error("Unimplemented upgrade bought.")


func _on_boost_purchased(level: int) -> void:
	match level:
		1:
			player.afterburner_enabled = true
		2:
			player.boost_burn -= 0.2
		3:
			player.boost_burn -= 0.2
		4:
			player.boost_burn -= 0.2
		5:
			player.boost_burn -= 0.2
		6:
			player.boost_burn -= 0.2
		7:
			player.boost_burn -= 0.2
		8:
			player.boost_burn -= 0.2
		_:
			push_error("Unimplemented upgrade bought.")


func _on_fuel_e_purchased(level: int) -> void:
	match level:
		1:
			player.passive_burn -= 0.2
		2:
			player.thruster_burn -= 0.2
		3:
			player.thruster_burn -= 0.2
		4:
			player.thruster_burn -= 0.2
		5:
			player.thruster_burn -= 0.2
		6:
			player.brake_burn -= 0.2
		7:
			player.thruster_burn -= 0.2
		8:
			player.thruster_burn -= 0.2
		_:
			push_error("Unimplemented upgrade bought.")


func _on_turn_purchased(level: int) -> void:
	match level:
		1:
			player.torque += 0.4
			player.angle_braking_strength += 0.1
		2:
			player.torque += 0.4
			player.angle_braking_strength += 0.3
		3:
			player.torque += 0.4
			player.angle_braking_strength += 0.3
		4:
			player.torque += 0.5
			player.angle_braking_strength += 0.5
		5:
			player.torque += 0.5
			player.angle_braking_strength += 1
		6:
			player.torque += 0.7
			player.angle_braking_strength += 2
		7:
			player.torque += 0.7
			player.angle_braking_strength += 2
		8:
			player.torque += 0.7
			player.angle_braking_strength += 3
		_:
			push_error("Unimplemented upgrade bought.")


func _on_fuel_purchased(level: int) -> void:
	match level:
		1:
			player.max_fuel += 30
		2:
			player.max_fuel += 30
		3:
			player.max_fuel += 30
		4:
			player.max_fuel += 30
		5:
			player.max_fuel += 30
		6:
			player.max_fuel += 30
		7:
			player.max_fuel += 30
		8:
			player.max_fuel += 30
		_:
			push_error("Unimplemented upgrade bought.")


func _on_regen_purchased(level: int) -> void:
	match level:
		1:
			player.weapon_regen += 1
		2:
			player.weapon_regen += 1
		3:
			player.weapon_regen += 1
		4:
			player.weapon_regen += 1
		5:
			player.weapon_regen += 1
		6:
			player.weapon_regen += 1
		7:
			player.weapon_regen += 1
		8:
			player.weapon_regen += 1
		_:
			push_error("Unimplemented upgrade bought.")
