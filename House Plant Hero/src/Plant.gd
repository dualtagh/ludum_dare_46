extends Area2D
class_name Plant

var health: = 100

func _process(delta) -> void:
	if health > 70:
		$AnimatedSprite.play("healthy")
	elif health > 30:
		$AnimatedSprite.play("unhealthy")
	elif health <= 0:
		$AnimatedSprite.play("dead")
	else:
		$AnimatedSprite.play("dying")


func _on_ThirstTimer_timeout() -> void:
	health -= 10

func water() -> void:
	if health > 0:
		health = 100
