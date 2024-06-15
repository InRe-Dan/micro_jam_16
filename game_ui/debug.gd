extends VBoxContainer

@onready var player : Ship = get_tree().get_first_node_in_group("player")
@onready var label : Label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	player.died.connect(queue_free)
	
func _process(delta: float) -> void:
	label.text = ""
	label.text += "Velocity: " + str(player.linear_velocity) + "\n"

func _on_give_pressed() -> void:
	player.give_matter(10)


func _on_take_pressed() -> void:
	player.matter = 0
