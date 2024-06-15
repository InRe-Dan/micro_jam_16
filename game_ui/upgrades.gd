extends VBoxContainer

@onready var label : Label = $Description

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
