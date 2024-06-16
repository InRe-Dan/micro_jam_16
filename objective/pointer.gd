extends Node2D

## How far from the player the pointer should stay
@export var player_distance : float = 400
## Conversion ratio between pixels and astronomical units
@export var au_to_pixels : float = 2000

@onready var player : Ship = get_tree().get_first_node_in_group("player")
@onready var objective : Node2D = get_tree().get_first_node_in_group("objective")
@onready var arrow : Polygon2D = $Polygon2D
@onready var label : Label = $Label
@onready var main_track: AudioStreamPlayer = $AudioStreamPlayer
@onready var tension_track: AudioStreamPlayer = main_track.get_node("Tension")

func _ready() -> void:
	player.died.connect(queue_free)

func _process(_delta: float) -> void:
	if not is_instance_valid(objective):
		return
	
	# Orient arrows
	var direction := player.global_position.direction_to(objective.global_position)
	global_position = player.global_position + direction * player_distance
	arrow.rotation = direction.angle() + PI / 2
	
	# Update label
	var au : float = int(player.global_position.distance_to(objective.global_position) * 100 / au_to_pixels) / 100.
	main_track.volume_db = clamp((-100+au)/5, -12, 0)
	tension_track.volume_db = clamp((0-au)/1.5, -80, -18)
	if au < 0.5:
		visible = false
		return
	visible = true
	var string : String = str(au)
	var split : PackedStringArray = string.split(".")
	# We need to pad zeroes to make sure that the width of this string is always 4
	if split.size() == 1:
		label.text = string + ".00 au"
		return
	if split[1].length() == 0:
		split[1] = "00"
	elif split[1].length() == 1:
		split[1] = split[1].insert(0, "0")
	
	label.text = split[0] + "." + split[1] + " au"
	
