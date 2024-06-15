class_name UpgradeButton extends Button

var cost : int = 1
var textures : Array[Texture2D]

signal purchased

# Called when the node enters the scene tree for the first time.
func init() -> void:
	pressed.connect(_on_pressed)
	disabled = true
	icon = textures[2]


func enable() -> void:
	disabled = false
	text = "+"
	icon = textures[1]

func _on_pressed() -> void:
	var player : Ship = get_tree().get_first_node_in_group("player")
	if not player:
		return
	if player.matter > cost:
		player.matter -= cost
		icon = textures[0]
		disabled = true
		text = ""
		purchased.emit()
