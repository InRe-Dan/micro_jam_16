@tool
class_name WeightCurve extends Curve


func _init():
	if not Engine.is_editor_hint():
		return
	max_value = 1000
	add_point(Vector2.ZERO)
	add_point(Vector2.RIGHT)
