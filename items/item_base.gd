class_name Item extends Node2D

## Uses this item. Must check for item durability
func use() -> void:
	push_error("Unimplemented Item Method!")
	
## This is a string, so you can return 30/60, 30, 50% etc.
## Only used for the purposes of UI.
func get_ammo_info() -> String:
	push_error("Unimplemented Item Method!")
	# Shut up, editor.
	return "100%"
	
## Called by UI nodes when the "Buy" button is used.
func buy_ammo() -> void:
	push_error("Unimplemented Item Method!")
