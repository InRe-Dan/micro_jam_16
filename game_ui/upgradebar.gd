extends HBoxContainer

@export var title : String
@export_multiline var description : String
@export var costs : Array[int] = [3, 5, 10, 15, 20, 25, 35, 50]

@export var upgraded_texture : Texture2D
@export var buy_texture : Texture2D
@export var hidden_texture : Texture2D

@onready var buttons : HBoxContainer = $MainHBox/HBoxContainer
@onready var label : Label = $Label
@onready var cost_label : Label = $MainHBox/Label2

signal hovered(info : String)
signal purchased(level : int)
var current : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(costs.size() == buttons.get_children().size())
	var i : int = 0
	for button : UpgradeButton in buttons.get_children():
		button.icon = hidden_texture
		button.cost = costs[i]
		if button != buttons.get_children().back():
			button.purchased.connect(buttons.get_children()[i + 1].enable)
		button.purchased.connect(successfuly_upgraded)
		i += 1
		button.textures = [upgraded_texture, buy_texture, hidden_texture]
		button.init()
	buttons.get_children().front().enable()
	
	label.text = title
	cost_label.text = "Cost: " + str(costs[current])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func successfuly_upgraded() -> void:
	current += 1
	purchased.emit(current)
	if current != 8:
		cost_label.text = "Cost: " + str(costs[current])
	else:
		cost_label.text = "MAX"

func _on_mouse_entered() -> void:
	if current < 8:
		hovered.emit(description + " (Cost: " + str(costs[current]) + " Matter)")
	else:
		hovered.emit("Fully upgraded!")
