extends Node2D

const LOUVRE: Resource = preload("uid://bw3hbaknbx1qh")
const BIG_FOUNTAIN: Resource = preload("uid://cdnaw3bjl0cjj")
const ORSAY: Resource = preload("uid://3vyk1kg265sn")
const CHATELET: Resource = preload("uid://v008qkdot8fp")
const EUSTACHE: Resource = preload("uid://bsx26338og6x2")
const POMPIDOU: Resource = preload("uid://bjk40iqthhx31")
const STATUES: Resource = preload("uid://dcunsckap4hy7")

@onready var current: Node = $Current
@onready var place_name: Label = $Name
@onready var player: Player = $Player

var left: bool = true


func _ready() -> void:
	set_current_place(Util.current_place)
	Signals.move_left.connect(move_left)
	Signals.move_right.connect(move_right)


func move_left() -> void:
	var i = Util.places.find(Util.current_place)
	left = false
	set_current_place(Util.places[posmod(i - 1, Util.places.size())])


func move_right() -> void:
	var i = Util.places.find(Util.current_place)
	left = true
	set_current_place(Util.places[posmod(i + 1, Util.places.size())])


func set_current_place(p: Util.Places) -> void:
	Util.current_place = p

	for node in current.get_children():
		node.queue_free()

	var place: Location = get_scene(p).instantiate()
	var pn = get_place_name(p)
	place_name.text = pn
	current.add_child(place)
	if left: player.global_position = place.left.global_position
	else: player.global_position = place.right.global_position
	player.set_limits(place.left.global_position, place.right.global_position)


func get_place_name(place: Util.Places) -> String:
	match place:
		Util.Places.LOUVRE:
			return "Louvre Museum"
		Util.Places.BIG_FOUNTAIN:
			return "Place Joachim du Bellay"
		Util.Places.ORSAY:
			return "Orsay Museum"
		Util.Places.EUSTACHE:
			return "St. Eustache Church"
		Util.Places.CHATELET:
			return "Place du Chatelet"
		Util.Places.STATUES:
			return "Louvre Museum Statues"
		Util.Places.POMPIDOU:
			return "Pompidou Museum"
		_:
			return "Unknown"


func get_scene(place: Util.Places) -> Resource:
	match place:
		Util.Places.BIG_FOUNTAIN: return BIG_FOUNTAIN
		Util.Places.ORSAY: return ORSAY
		Util.Places.POMPIDOU: return POMPIDOU
		Util.Places.EUSTACHE: return EUSTACHE
		Util.Places.STATUES: return STATUES
		Util.Places.CHATELET: return CHATELET
		_: return LOUVRE
