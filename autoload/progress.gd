extends Node

enum Pieces {}


var intro_done: bool = false
var eiffel_pieces: Dictionary = {}
var lights_minigame: bool = false


func reset() -> void:
	intro_done = false
	eiffel_pieces = {}
	lights_minigame = false
