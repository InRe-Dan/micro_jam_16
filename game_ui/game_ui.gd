extends TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var queue : Array[Control] = [self]
	while queue:
		var control : Control = queue.pop_front()
		queue.append_array(control.get_children())
		control.focus_mode = control.FOCUS_NONE
	get_tree().get_first_node_in_group("player").died.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
