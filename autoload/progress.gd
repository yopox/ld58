extends Node

enum Pieces {
	Statues,
	Rats,
}


var mission_done: bool = false
var place: Util.Places = Util.Places.ORSAY
var intro_done: bool = false
var outro_done: bool = false
var eiffel_pieces: Dictionary = {}


func reset() -> void:
	mission_done = false
	place = Util.Places.ORSAY
	intro_done = false
	eiffel_pieces = {}


func get_subtitle() -> String:
	var remaining = Pieces.values().size() - eiffel_pieces.size()
	if remaining == 0:
		return "All pieces collected!"
	else:
		return "%s to go!" % remaining


func has_all_pieces() -> bool:
	return eiffel_pieces.size() == Pieces.values().size()
