extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	Signals.talking.connect(talk_animation)
	Signals.stop_talking.connect(stop_talk_animation)


func talk_animation() -> void:
	sprite.play("Talking")


func stop_talk_animation() -> void:
	sprite.play("Idle")
