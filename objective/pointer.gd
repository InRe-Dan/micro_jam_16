extends Node2D

## How far from the player the pointer should stay
@export var player_distance : float = 400
## Conversion ratio between pixels and astronomical units
@export var au_to_pixels : float = 1000

@onready var player : Ship = get_tree().get_first_node_in_group("player")
@onready var objective : Node2D = get_tree().get_first_node_in_group("objective")
@onready var arrow : Polygon2D = $Polygon2D
@onready var label : Label = $Label

func _ready() -> void:
	player.died.connect(queue_free)w

func _process(delta: float) -> void:
	# Orient arrows
	var direction := player.global_position.direction_to(objective.global_position)
	global_position = player.global_position + direction * player_distance
	arrow.rotation = direction.angle() + PI / 2
	
	# Update label
	var au : int = player.global_position.distance_to(objective.global_position) * 100 / au_to_pixels
	var string : String = str(au / 100.)
	# We need to pad zeroes to make sure that the width of this string is always 4
	if string.length() == 1:
		string += ".00"
	elif string.length() == 2:
		push_error("wtf")
	elif string.length() == 3:
		print(string)
		string = string.insert(3, "0")
	
	label.text = string + " au"
	
