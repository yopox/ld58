class_name Player
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dir: Vector2
var x_min: float = 0
var x_max: float = 360


func _ready() -> void:
	sprite.flip_h = true
	Signals.player_shocked.connect(player_shocked)
	Signals.textbox_displayed.connect(player_idle)


func player_shocked() -> void:
	sprite.play("shocked")


func player_idle() -> void:
	sprite.play("default")


func _process(delta: float) -> void:
	if Util.dialog_shown: return
	if Util.cutscene_playing: return
	if Util.achievement_shown: return

	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		if sprite.animation != "walking":
			sprite.play("walking")
		sprite.flip_h = false
		direction = dir
	elif Input.is_action_pressed("left"):
		if sprite.animation != "walking":
			sprite.play("walking")
		sprite.flip_h = true
		direction = -dir
	else:
		if sprite.animation != "default":
			sprite.play("default")
	
	var d = delta * Values.PLAYER_SPEED
	
	if global_position.x + direction.x * d < x_min:
		Signals.move_left.emit()
	elif global_position.x + direction.x * d > x_max:
		Signals.move_right.emit()
	else:
		position += direction * d


func set_limits(left: Vector2, right: Vector2) -> void:
	dir = left.direction_to(right)
	x_min = left.x
	x_max = right.x
