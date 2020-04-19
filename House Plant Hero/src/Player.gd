extends KinematicBody2D
class_name Player

onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(300.0, 1000.0)
export var gravity: = 4000.0

var _velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	if _velocity.length() > 0:
		$AnimatedSprite.play()
		pass
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.stop()
		pass
		
	if _velocity.x != 0:
		$AnimatedSprite.animation = "walking"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = _velocity.x < 0
		
		# Pretty hacky
		if _velocity.x < 0:
			if $WaterGun.scale.x > 0:
				$WaterGun.scale *= Vector2(-1,1)
		else:
			if $WaterGun.scale.x < 0:
				$WaterGun.scale *= Vector2(-1,1)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") 
		- Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
		audio_player.play()
	if is_jump_interrupted:
		out.y = 0
	return out

func _ready() -> void:
	hide()
	
func start(pos: Vector2) -> void:
	position = pos
	show()
