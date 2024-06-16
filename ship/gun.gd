## Class for simple ship gun
class_name DualGun extends Item

@export var damage : int = 1
@export var fire_delay: float = 1 / 30.
@export var ammo_per_shot : int = 1
## Nodes representing where bullets should be spawned
@export var firing_positions : Array[Node2D]

@export var bullet_scene: PackedScene = preload("res://ship/bullet.tscn")

var bullet_container: Node
## Which gun should be fired next
var gun_index : int = 0
var time_since_fired : float = 0

func use(ammo_available : int) -> int:
	if time_since_fired >= fire_delay and ammo_available > 0:
		time_since_fired = 0;
		fire()
		return ammo_per_shot
	return 0

func get_ammo_info() -> String:
	return str(int(ammo_per_shot / fire_delay)) + "/s"

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(firing_positions.size() > 0)
	bullet_container = get_tree().get_first_node_in_group("main")

func next_position() -> Vector2:
	gun_index += 1
	gun_index = gun_index % firing_positions.size()
	return firing_positions[gun_index].global_position

func _process(delta: float) -> void:
	time_since_fired += delta

## Fires the gun
func fire() -> void:
	var bullet: Bullet = bullet_scene.instantiate() as Bullet
	var pos : Vector2 = next_position()
	if get_parent().get_parent() is Ship:
		var ship = get_parent().get_parent()
		bullet.velocity_offset = ship.linear_velocity
		bullet.collision_mask = ship.collision_mask
	elif get_parent() is Enemy:
		bullet.collision_mask = get_parent().collision_mask
	
	bullet.damage = damage
	bullet.position = pos
	bullet.rotation = global_rotation
	bullet_container.add_child(bullet)
