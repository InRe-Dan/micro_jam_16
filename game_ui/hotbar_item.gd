class_name HotbarItem extends TextureRect

@onready var item_name : Label = $Name
@onready var durability : Label = $Durability
@onready var icon : TextureRect = $TextureRect

var item : Item

func _ready() -> void:
	icon.custom_minimum_size = get_minimum_size()

func update(init_item : Item = null) -> void:
	if not item:
		item = init_item

	icon.texture = item.data.icon
	item_name.text = item.data.name
	durability.text = item.get_ammo_info()

	if not item.unlocked:
		icon.modulate.a = 0.4
		item_name.modulate.a = 0.4
		durability.modulate.a = 0.4
		self_modulate.a = 0.4
		durability.text = str(item.data.initial_price) + " Matter"
	elif not item.selected:
		icon.modulate.a = 0.5
		item_name.modulate.a = 0.5
		durability.modulate.a = 0.5
		self_modulate.a = 0.5
	else:
		icon.modulate.a = 1
		durability.modulate.a = 1
		item_name.modulate.a = 1
		self_modulate.a = 1
		
	if item.unlocked and has_node("Buy"):
		$Buy.queue_free()



func _on_buy_pressed() -> void:
	var player : Ship = get_tree().get_first_node_in_group("player")
	if player.matter > item.data.initial_price:
		$Buy.queue_free()
		item.unlocked = true
