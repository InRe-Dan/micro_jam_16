extends Node2D

var selected : int = 0

signal updated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		selected += 1
	if Input.is_action_just_pressed("scroll_down"):
		selected -= 1
	
	if selected < 0:
		selected = get_child_count() - 1
	if selected == get_child_count():
		selected = 0

func use() -> void:
	get_children()[selected].use()
