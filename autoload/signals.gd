@warning_ignore_start("unused_signal")
extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a"):
		confirm.emit()

# — STATES —
signal change_scene(scene: Util.Scenes)

# — LOCATIONS —
signal move_left()
signal move_right()

# — PLAYER —
signal player_shocked()

# — UI —
signal show_dialog(speaker_name: String, text: String, position: Vector2)
signal show_textbox(position: Vector2, speaker_name: String)
signal textbox_displayed()
signal hide_textbox()
signal textbox_hidden()
signal show_dialog_persist(text: String)
signal dialog_over()
signal confirm()
signal talking()
signal stop_talking()
