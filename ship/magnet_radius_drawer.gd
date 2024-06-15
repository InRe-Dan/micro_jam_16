## Draws the magnet radius
extends Control

var magnet: MatterMagnet


## Assigns a reference to the matter magnet
func assign_magnet_ref(magnet_ref: MatterMagnet) -> void:
	magnet = magnet_ref


## Draws a single frame
func _draw() -> void:
	if not magnet or not is_instance_valid(magnet): return
	draw_circle(get_viewport().size / 2, magnet.pickup_radius, Color(0, 0, 1, 0.1))


func _process(_delta):
	queue_redraw()
