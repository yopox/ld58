extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("a"):
		# TODO: go to intro
		Signals.change_scene.emit(Util.Scenes.PLACE)
