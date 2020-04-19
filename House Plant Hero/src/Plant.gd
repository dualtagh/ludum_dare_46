extends Area2D
class_name Plant

onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal plant_died
signal plant_watered

var health: = 100

func _process(delta) -> void:
	if health > 70:
		$AnimatedSprite.play("healthy")
	elif health > 30:
		$AnimatedSprite.play("unhealthy")
	elif health <= 0:
		$AnimatedSprite.play("dead")
		audio_player.play()
		emit_signal("plant_died")
		set_process(false)
	else:
		$AnimatedSprite.play("dying")


func _on_ThirstTimer_timeout() -> void:
	health -= 15

func water() -> void:
	if health > 0:
		if health <= 70:
			emit_signal("plant_watered")
		health = 100

func _ready() -> void:
	hide()
	var wait_time = rand_range(1, 2)
	$ThirstTimer.wait_time = wait_time
	
func start(pos: Vector2) -> void:
	position = pos
	$ThirstTimer.start()
	show()
