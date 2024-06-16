extends HBoxContainer

var following : bool = false
var mouse_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if following:
		global_position = get_global_mouse_position() + mouse_offset


func _on_button_button_down() -> void:
	following = true
	mouse_offset = global_position - get_global_mouse_position()

func _on_button_button_up() -> void:
	following = false
