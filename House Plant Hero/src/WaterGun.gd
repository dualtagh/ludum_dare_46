extends Area2D
class_name WaterGun

enum STATES { IDLE, SQUIRTING}
var current_state = STATES.IDLE

func _ready() -> void:
	set_physics_process(false)
	
func _change_state(new_state):
	current_state = new_state
	
	match current_state:
		STATES.IDLE:
			set_physics_process(false)
		STATES.SQUIRTING:
			set_physics_process(true)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		squirt()
		
func _physics_process(delta: float) -> void:
	var overlapping_areas = get_overlapping_areas()
	if not overlapping_areas:
		return
	
	for area in overlapping_areas:
		if area.is_in_group("plants"):
			(area as Plant).water()
	set_physics_process(false)
	
func squirt() -> void:
	_change_state(STATES.SQUIRTING)
	$Particles2D.restart()
