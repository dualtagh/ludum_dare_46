extends CanvasLayer

signal start_game

enum GAME_STATE {
	MENU,
	PLAYING
}

var _game_state = GAME_STATE.MENU

var lives_3 = preload("res://assets/3_lives.png")
var lives_2 = preload("res://assets/2_lives.png")
var lives_1 = preload("res://assets/1_lives.png")

func _process(delta: float) -> void:
	if _game_state == GAME_STATE.MENU and Input.is_action_just_pressed("start"):
		start_game()
		

func show_message(text) -> void:
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	_game_state = GAME_STATE.MENU
	show_message("You let 3 plants die :(")
	$TitleLabel.text = "GAME OVER"
	$TitleLabel.show()
	yield($MessageTimer, "timeout")
	
	$TitleLabel.text = "HOUSE PLANT HERO"
	
	$MessageLabel.text = "Press <ENTER> to start a new game."
	$MessageLabel.show()
	$MessageTimer.stop()

func start_game():
	$TitleLabel.hide()
	show_message("Press arrows/WASD to move/jump. Press <SPACE> to squirt.")
	emit_signal("start_game")
	_game_state = GAME_STATE.PLAYING

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout() -> void:
	$MessageLabel.hide()
	
func update_lives(lives) -> void:
	if lives >= 3:
		$Lives.set_texture(lives_3)
		$Lives.show()
	elif lives == 2:
		$Lives.set_texture(lives_2)
	elif lives == 1:
		$Lives.set_texture(lives_1)
	else:
		$Lives.hide()

func plant_delivered() -> void:
	var messages = [
		"A plant has been delivered, why did you buy so many?",
		"A plant has been delivered.",
	]
	show_message(messages[randi()%2])
