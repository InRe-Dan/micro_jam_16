extends Label


@onready var player : Ship = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Matter: " + str(player.matter)
