class_name Player
extends Sprite2D


func _process(delta: float) -> void:
	if Util.dialog_shown: return
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction += Vector2(1, 0)
	if Input.is_action_pressed("left"):
		direction += Vector2(-1, 0)
	if Input.is_action_pressed("up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		direction += Vector2(0, 1)
	
	direction = direction.normalized()
	position += direction * delta * Values.PLAYER_SPEED
