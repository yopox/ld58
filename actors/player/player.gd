class_name Player
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dir: Vector2
var x_min: float = 0
var x_max: float = 360


func _ready() -> void:
	sprite.flip_h = true


# pour que la petite bite respecte les perspectives (tentative)

# Limites verticales de la scène pour le calcul de la perspective
var y_min: float = 300  # Le personnage est "proche" -> plus grand
var y_max: float = 0  # Le personnage est "loin" -> plus petit

# Échelles correspondantes
var scale_min: float = 1.6
var scale_max: float = 0.3

func _process(delta: float) -> void:
	if Util.dialog_shown: return
	if Util.cutscene_playing: return

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

	# Mettre à jour l'échelle en fonction de la position Y
	update_perspective_scale()


func set_limits(left: Vector2, right: Vector2) -> void:
	dir = left.direction_to(right)
	x_min = left.x
	x_max = right.x

#Fonction transformation en petit caca /by doubletwinks
func update_perspective_scale() -> void:
	var y_pos := global_position.y
	# Règle de perspective linéaire
	var t :Variant = clamp((y_pos - y_max) / (y_min - y_max), 0.0, 1.0)
	# Échelle arrondie à deux chiffres max pour éviter artefacts
	var raw_scale :Variant= lerp(scale_max, scale_min, t)
	var safe_scale :Variant= round(raw_scale * 10.0) / 10.0  # Ex: 0.72 -> 0.7

	# Appliquer au nœud parent (Visuals), jamais au sprite directement
	sprite.scale = Vector2(safe_scale, safe_scale)

	# Évite les sous-pixels
	sprite.position = sprite.position.round()
