extends Node

enum Scenes {
	TITLE,
	INTRO,
	PARIS_MAP,
	PLACE,
	OUTRO,
}

enum Places {
	LOUVRE,
	BIG_FOUNTAIN,
	METRO,
}

var current_place: Places = Places.BIG_FOUNTAIN
var dialog_shown: bool = false


func wait(amount: float) -> void:
	await get_tree().create_timer(amount).timeout


func show_dialog(speaker_name: String, text: String, position: Vector2) -> void:
	Signals.show_dialog.emit(speaker_name, text, position)
	await Signals.dialog_over
