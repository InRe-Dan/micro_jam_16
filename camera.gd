extends Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target : Node2D = get_tree().get_first_node_in_group("player")
	if not target:
		target = get_tree().get_first_node_in_group("objective")
	if not target:
		target = self
	global_position = target.global_position
