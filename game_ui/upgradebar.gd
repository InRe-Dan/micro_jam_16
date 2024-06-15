extends HBoxContainer

@export var title : String
@export var description : String
@export var costs : Array[int] = [3, 5, 10, 15, 20, 25, 35, 50]

@export var upgraded_texture : Texture2D
@export var buy_texture : Texture2D
@export var hidden_texture : Texture2D

@onready var buttons : HBoxContainer = $HBoxContainer
@onready var label : Label = $Label

signal hovered(info : String)
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
			button.purchased.connect(func x(): current += 1)
		i += 1
		button.textures = [upgraded_texture, buy_texture, hidden_texture]
		button.init()
	buttons.get_children().front().enable()
	
	label.text = title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	hovered.emit(description + "\nCost: " + str(costs[current]) + " Matter")