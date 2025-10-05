extends Node2D

const LOUVRE: Resource = preload("uid://bw3hbaknbx1qh")
const BIG_FOUNTAIN = preload("uid://cdnaw3bjl0cjj")

@onready var current: Node = $Current
@onready var place_name: Label = $Name
@onready var place_name_2: Label = $NameShadow


func _ready() -> void:
	set_current_place(Util.current_place)


func set_current_place(p: Util.Places) -> void:
	for node in current.get_children():
		node.queue_free()
		
	var place = get_scene(p)
	var pn = get_place_name(p)
	place_name.text = pn
	place_name_2.text = pn
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
