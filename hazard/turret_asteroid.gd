## Turret class
class_name TurretAsteroid extends Hazard

@onready var explosion_animation = $AnimationPlayer
@onready var explosion: Area2D = $Explosion

@export var matter_spawn_distribution : Curve

var matter_scene : PackedScene = preload("res://collectable/matter_fragment.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if not matter_spawn_distribution: push_error("No spawn curve assigned")
	var turret: Hazard = get_node("Turret") as Hazard
	if turret and is_instance_valid(turret):
		turret.top_level = true
		turret.global_position = Vector2.INF
		turret.visible = true
		$TurretBase.visible = true


## Destroys the asteroid
func destroy() -> void:
	explosion_animation.play("explosion")
	

## Explodes
func explode() -> void:
	var turret: Hazard = get_node("Turret") as Hazard
	if turret and is_instance_valid(turret):
		turret.destroy()
		$TurretBase.visible = false
	
	for body: Node2D in explosion.get_overlapping_bodies():
		if not body is Hazard and not body is Ship:
			continue
		
		body.damage(10)
	
	for i in range(matter_spawn_distribution.sample(randf())):
		var matter : MatterFragment = matter_scene.instantiate()
		add_sibling.call_deferred(matter)
		var direction = Vector2.from_angle(TAU * randf())
		matter.global_position = global_position + direction * (30 + randf() * 60)
		matter.rotation = randf() * TAU
		matter.velocity = direction * (30 + randf() * 50)
		matter.angular_velocity = (randf() - 0.5) * 0.5
