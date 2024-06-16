extends Label

var target : float = 1.0
var flashing : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flashing:
		self_modulate.a = 1.0
	else:
		self_modulate.a = 0.0

	if target > 0.5:
		modulate.a = lerpf(modulate.a, 1.0, 15 * delta)
		if modulate.a > 0.8:
			target = 0
	
	if target < 0.5:
		modulate.a = lerpf(modulate.a, 0.0, 15 * delta)
		if modulate.a < 0.4:
			target = 1.0
