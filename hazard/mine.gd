## Mine class
class_name Mine extends Hazard

@onready var explosion_animation = $AnimationPlayer
@onready var explosion: Area2D = $Explosion


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


## Destroys the asteroid
func destroy() -> void:
	explosion_animation.play("explosion")
	

## Explodes
func explode() -> void:
	for body: Node2D in explosion.get_overlapping_bodies():
		if not body is Hazard and not body is Ship:
			continue
		
		body.damage(20)
