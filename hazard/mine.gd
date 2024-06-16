## Mine class
class_name Mine extends Hazard

@onready var explosion_animation = $AnimationPlayer
@onready var explosion: Area2D = $Explosion
@onready var proximity: Area2D = $Proximity
@onready var warning_particles: CPUParticles2D = proximity.get_node("CPUParticles2D")
@onready var shape: CollisionShape2D = proximity.get_node("CollisionShape2D")
@onready var explosion_audio: AudioStreamPlayer2D = explosion.get_node("AudioStreamPlayer2D")
@onready var warning_audio: AudioStreamPlayer2D = $WarningAudio

var destroyed: bool = false


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	var points: Array[Vector2] = []
	for i: float in range(warning_particles.amount):
		var angle: float = TAU * (i/warning_particles.amount)
		points.append(Vector2.from_angle(angle) * shape.shape.radius)
	
	warning_particles.emission_points = points
	

## Destroys the asteroid
func destroy() -> void:
	if not destroyed:
		warning_audio.play()
	destroyed = true
	explosion_animation.play("explosion")


## Explodes
func explode() -> void:
	explosion_audio.play()
	for body: Node2D in explosion.get_overlapping_bodies():
		if body.has_method("damage"): body.damage(20)


func _on_proximity_body_entered(body):
	if body is Ship or body.is_in_group("ranged_enemy"):
		destroy()
