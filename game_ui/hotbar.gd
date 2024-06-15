extends HBoxContainer

var frame_scene : PackedScene = preload("res://game_ui/hotbar_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player : Ship = get_tree().get_first_node_in_group("player")
	assert(player)
	var inv : Inventory = player.get_inventory()
	for item in inv.get_children():
		var hotbar_item : HotbarItem = frame_scene.instantiate()
		add_child(hotbar_item)
		hotbar_item.update(item)
		var spacer : Control = Control.new()
		spacer.custom_minimum_size.x = 40
		add_child(spacer)
	get_children().back().queue_free()

	inv.updated.connect(update)

func update() -> void:
	for child in get_children():
		var hotbar_item : HotbarItem = child as HotbarItem
		if not hotbar_item:
			continue
		hotbar_item.update()
	
