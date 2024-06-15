class_name MatterFragment extends Area2D

var velocity : Vector2
var angular_velocity : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += velocity * delta
	velocity = velocity / (1 + 0.3 * delta)
	rotation += angular_velocity * delta
