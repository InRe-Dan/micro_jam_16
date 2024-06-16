class_name Dreadnull extends Enemy

var fighting: bool = false


func _physics_process(delta) -> void:
	if not fighting:
		var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
		if not ship or not is_instance_valid(ship):
			return
		
		if ship.position.distance_squared_to(position) <= engagement_distance * 4:
			fighting = true
	else:
		super(delta)
