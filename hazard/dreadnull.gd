class_name Dreadnull extends Enemy

var fighting: bool = false

@onready var missiles = $Missiles
@onready var fight_start = $FightStart

var game_over: PanelContainer


func _physics_process(delta) -> void:
	if not fighting:
		var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
		if not ship or not is_instance_valid(ship):
			return
		
		if ship.position.distance_squared_to(position) <= engagement_distance * 4:
			fighting = true
			fight_start.play()
	else:
		super(delta)
		missiles.use(missiles.ammo_per_shot)


func destroy() -> void:
	var ship: Ship = get_tree().get_first_node_in_group("player") as Ship
	if not ship or not is_instance_valid(ship):
		return
	game_over.game_over(ship.stopwatch_time, ship.total_matter_collected, true)
	super()
