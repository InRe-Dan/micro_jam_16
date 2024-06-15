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

	if not item.unlocked:
		icon.modulate.a = 0.1
		item_name.modulate.a = 0
		durability.modulate.a = 0
	elif not item.selected:
		icon.modulate.a = 0.5
		item_name.modulate.a = 0
		durability.modulate.a = 0.5
	else:
		icon.modulate.a = 1
		durability.modulate.a = 1
		item_name.modulate.a = 1

	icon.texture = item.data.icon
	item_name.text = item.data.name
	durability.text = item.get_ammo_info()
