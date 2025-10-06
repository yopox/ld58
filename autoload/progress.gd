extends Node

enum Pieces {
	Statues,
	Rats,
}


var mission_done: bool = false
var place: Util.Places = Util.Places.ORSAY
var intro_done: bool = false
var outro_done: bool = false
var metro_ticket: bool = false
var eiffel_pieces: Dictionary = {}
var sphinx_riddle_enabled: bool = false
var sphinx_riddle_solved: bool = false


func reset() -> void:
	mission_done = false
	place = Util.Places.ORSAY
	intro_done = false
	outro_done = false
	metro_ticket = false
	eiffel_pieces = {}


func get_subtitle() -> String:
	var remaining = Pieces.values().size() - eiffel_pieces.size()
	if remaining == 0:
		return "All pieces collected!"
	else:
		return "%s to go!" % remaining


func has_all_pieces() -> bool:
	return eiffel_pieces.size() == Pieces.values().size()


func piece_for(place: Util.Places) -> Variant:
	match place:
		Util.Places.STATUES: return Pieces.Statues
		#Util.Places.LOUVRE: return true
		#Util.Places.CHATELET: return true
		#Util.Places.POMPIDOU: return true
	return null
