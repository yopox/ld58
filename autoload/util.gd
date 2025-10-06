extends Node

enum Places {
	EUSTACHE,
	BIG_FOUNTAIN,
	POMPIDOU,
	CHATELET,
	LOUVRE,
	STATUES,
	ORSAY,
	METRO,
}
enum Scenes {
	TITLE,
	INTRO,
	PARIS_MAP,
	PLACE,
	OUTRO,
}

var places = Places.values()

const BOSS_NAME: String = "Cap Manager"

var dialog_shown: bool = false
var cutscene_playing: bool = false
var textbox_auto_next: bool = false


func show_dialog(speaker_name: String, text: String, position: Vector2) -> void:
	Signals.show_dialog.emit(speaker_name, text, position)
	await Signals.dialog_over


func show_dialog_persist(text: String) -> void:
	Signals.show_dialog_persist.emit(text)
	await Signals.dialog_over


func show_textbox(position: Vector2, speaker_name: String) -> void:
	Signals.show_textbox.emit(position, speaker_name)
	await Signals.textbox_displayed


func hide_textbox() -> void:
	Signals.hide_textbox.emit()
	await Signals.textbox_hidden


func wait(amount: float) -> void:
	await get_tree().create_timer(amount).timeout
