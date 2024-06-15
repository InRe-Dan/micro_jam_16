## Clean up cycle for matter pick-ups
extends Timer

## Signal for matter to clean up
signal matter_clean


## Timer timed out
func _on_timeout():
	matter_clean.emit()
