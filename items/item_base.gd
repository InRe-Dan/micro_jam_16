class_name Item extends Node2D

@export var data : ItemData
@export var unlocked : bool = false
var selected : bool = false

## Uses this item. Must check for item durability.
## Returns how much durability should be spent.
func use(ammo_available : int) -> int:
	push_error("Unimplemented Item Method!")
	return 0
	
## This is a string, so you can return 30/60, 30, 50% etc.
## Only used for the purposes of UI.
func get_ammo_info() -> String:
	push_error("Unimplemented Item Method!")
	# Shut up, editor.
	return "100%"
	
