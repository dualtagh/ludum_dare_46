extends Area2D
class_name Plant

var health: = 100

func _process(delta) -> void:
	if health > 70:
		$AnimatedSprite.play("healthy")
	elif health > 30:
		$AnimatedSprite.play("unhealthy")
	else:
		$AnimatedSprite.play("dying")
		if health <= 0:
			hide()


func _on_ThirstTimer_timeout() -> void:
	health -= 10

func water() -> void:
	health = 100
