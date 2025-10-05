extends Node

enum Places {
	EUSTACHE,
	BIG_FOUNTAIN,
	POMPIDOU,
	CHATELET,
	LOUVRE,
	STATUES,
	ORSAY,
}
enum Scenes {
	TITLE,
	INTRO,
	PARIS_MAP,
	PLACE,
	OUTRO,
}

var places = Places.values()

var current_place: Places = Places.BIG_FOUNTAIN
var dialog_shown: bool = false


func show_dialog(speaker_name: String, text: String, position: Vector2) -> void:
	Signals.show_dialog.emit(speaker_name, text, position)
	await Signals.dialog_over


func wait(amount: float) -> void:
	await get_tree().create_timer(amount).timeout
