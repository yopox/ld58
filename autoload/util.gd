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


func wait(amount: float):
	await get_tree().create_timer(amount).timeout
