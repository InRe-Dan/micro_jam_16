extends Enemy


func _physics_process(delta: float) -> void:
	super(delta)

	if get_parent() is Hazard:
		global_position = get_parent().global_position
