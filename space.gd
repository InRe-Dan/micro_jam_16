## Main script
extends Node2D

@onready var ship: Ship = $Ship

func _ready() -> void:
	var game_over_screen = $CanvasLayer/GameOver
	if not game_over_screen or not is_instance_valid(game_over_screen):
		return
	
	if not ship or not is_instance_valid(ship):
		return
	
	ship.game_over = game_over_screen
	
	
## Input
func _input(event):
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
