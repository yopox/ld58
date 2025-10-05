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
	METRO,
}

var current_place: Places = Places.LOUVRE


func wait(amount: float):
	await get_tree().create_timer(amount).timeout
