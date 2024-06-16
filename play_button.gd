extends Button


func _on_pressed() -> void:
	$"../..".visible = false
	$"../../../Hotbar".visible = true
	$"../../../DraggableWindow".visible = true
	$"../../../../Pointer".visible = true
	$"../../../Warnings".visible = true
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT
