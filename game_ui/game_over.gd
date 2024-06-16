extends PanelContainer

@onready var time_label: Label = $VBox/TimeLabel
@onready var matter_label: Label = $VBox/MatterLabel


func game_over(time: float, matter: int) -> void:
	var minutes: int = floor(time/60)
	var seconds: int = time - minutes
	var sec_string: String = ""
	if seconds > 9:
		sec_string = str(seconds)
	else:
		sec_string = "0" + str(seconds)

	time_label.text = "Time: " + str(minutes) + ":" + sec_string
	matter_label.text = "Matter: " + str(matter)
	
	visible = true
