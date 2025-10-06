extends Node

enum Pieces {}


var mission_done: bool = false
var place: Util.Places = Util.Places.ORSAY
var intro_done: bool = false
var eiffel_pieces: Dictionary = {}
var lights_minigame: bool = false


func reset() -> void:
	mission_done = false
	place = Util.Places.ORSAY
	intro_done = false
	eiffel_pieces = {}
	lights_minigame = false
