class_name Inventory extends Node2D

@onready var player : Ship = get_parent()

var selected : int = 0

signal updated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_children()[selected].selected = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	## Find next item
	var old_selected := selected
	if Input.is_action_just_pressed("scroll_up"):
		while true:
			selected += 1
			if selected == get_child_count():
				selected = 0
			if get_children()[selected].unlocked:
				break
		
	elif Input.is_action_just_pressed("scroll_down"):
		while true:
			selected -= 1
			if selected < 0:
				selected = get_child_count() - 1
			if get_children()[selected].unlocked:
				break
		

	# Update UI
	get_children()[old_selected].selected = false
	get_children()[selected].selected = true
	updated.emit()

func use() -> void:
	updated.emit()
	player.ammo -= get_children()[selected].use(player.ammo)
	print(player.ammo)
