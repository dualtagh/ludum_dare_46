extends Node2D

export (PackedScene) var Player
export (PackedScene) var Plant
export (PackedScene) var PlantSpawnLocations

var _score
var _lives
var _player : Player
var _plant_spawn_locations: Node
var _plants: Node

func _ready():
	randomize()

func game_over():
	$PlantTimer.stop()
	$HUD.show_game_over()
	remove_child(_player)
		
func new_game():
	_score = 0
	_lives = 3
	
	remove_child(_plants)
	_plant_spawn_locations = PlantSpawnLocations.instance()
	_plants = Node.new()
	add_child(_plants)
	
	_player = Player.instance()
	add_child(_player)
	_player.start($PlayerSpawnLocation.position)
	
	$HUD.update_score(_score)
	$HUD.update_lives(_lives)
	_on_PlantTimer_timeout() # First plant
	$PlantTimer.start()


func _on_PlantTimer_timeout() -> void:
	var num_spawns = _plant_spawn_locations.get_children().size()
	if num_spawns > 0:
		var chose_spawn_index = randi() % num_spawns
		var chosen_spawn = _plant_spawn_locations.get_child(chose_spawn_index) as Node2D
		
		var plant = Plant.instance()
		_plants.add_child(plant)
		plant.start(chosen_spawn.position)
		plant.connect("plant_died", self,"_lost_a_life")
		plant.connect("plant_watered", self,"_plant_watered")
		_plant_spawn_locations.remove_child(chosen_spawn)
		$HUD.plant_delivered()


func _on_HUD_start_game() -> void:
	new_game()
	
func _lost_a_life() -> void:
	_lives -= 1
	$HUD.update_lives(_lives)
	if _lives == 0:
		game_over()
		
func _plant_watered() -> void:
	_score += 100
	$HUD.update_score(_score)
