class_name Oscillator
extends Node

@export var freq: float = 1.0
@export var amplitude: float = 2.0

var default_pos: Vector2
var t: float = 0


func _ready() -> void:
	var parent = get_parent()
	if not (parent is Node2D or parent is Control):
		return
	default_pos = parent.position


func _process(delta: float) -> void:
	var parent = get_parent()
	t += delta
	parent.position = default_pos + Vector2(0, sin(t * freq) * amplitude)
