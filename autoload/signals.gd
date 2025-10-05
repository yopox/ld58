@warning_ignore_start("unused_signal")
extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a"):
		confirm.emit()

# — STATES —
signal change_scene(scene: Util.Scenes)

# — UI —
signal show_dialog(speaker_name: String, text: String, position: Vector2)
signal dialog_over()
signal confirm()
