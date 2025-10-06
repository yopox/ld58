extends Node2D

@onready var version: Label = $Version

func _ready() -> void:
	version.text = ProjectSettings.get_setting("application/config/version")


func _process(_delta: float) -> void:
	if Util.screen_transition: return
	
	if Input.is_action_just_pressed("a"):
		if Progress.mission_done:
			Signals.change_scene.emit(Util.Scenes.PLACE)
		else:
			Signals.change_scene.emit(Util.Scenes.INTRO)
