extends Node2D

const LOUVRE: Resource = preload("uid://bw3hbaknbx1qh")
const BIG_FOUNTAIN = preload("uid://cdnaw3bjl0cjj")

@onready var current: Node = $Current
@onready var place_name: Label = $Name


func _ready() -> void:
	var place = get_scene(Util.current_place)
	place_name.text = get_place_name(Util.current_place)
	current.add_child(place.instantiate())


func get_place_name(place: Util.Places) -> String:
	match place:
		Util.Places.LOUVRE:
			return "Louvre"
		Util.Places.METRO:
			return "Metro"
		Util.Places.BIG_FOUNTAIN:
			return "Place Joachim du Bellay"
		_:
			return "Unknown"


func get_scene(place: Util.Places) -> Resource:
	match place:
		Util.Places.BIG_FOUNTAIN:
			return BIG_FOUNTAIN
		_:
			return LOUVRE
