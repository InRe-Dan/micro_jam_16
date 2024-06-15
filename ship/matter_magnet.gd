class_name MatterMagnet extends Area2D

## How fast matter within the radius comes to the origin
@export var acceleration : float = 100
## How close matter needs to be before matter_picked_up is emitted
@export var pickup_radius : float = 150

signal matter_picked_up


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Radius.assign_magnet_ref(self)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for matter : MatterFragment in get_overlapping_areas():
		if matter.global_position.distance_to(global_position) < pickup_radius:
			matter.queue_free()
			matter_picked_up.emit()
			continue
		matter.velocity += matter.global_position.direction_to(global_position) * acceleration * delta
