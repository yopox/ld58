extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("a"):
		if Progress.mission_done:
			Signals.change_scene.emit(Util.Scenes.PLACE)
		else:
			Signals.change_scene.emit(Util.Scenes.INTRO)
