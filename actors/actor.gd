class_name Actor
extends Node2D

signal interact()

@onready var bubble: Sprite2D = $Bubble

var can_interact: bool = false


func _ready() -> void:
	bubble.visible = false


func _process(_delta: float) -> void:
	if Util.dialog_shown: return
	if can_interact and Input.is_action_just_pressed("a"):
		interact.emit()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not area.get_parent() is Player: return
	can_interact = true
	bubble.visible = true


func _on_hitbox_area_exited(area: Area2D) -> void:
	if not area.get_parent() is Player: return
	can_interact = false
	bubble.visible = false
