extends Node2D

const LOUVRE: Resource = preload("uid://bw3hbaknbx1qh")
const BIG_FOUNTAIN: Resource = preload("uid://cdnaw3bjl0cjj")
const ORSAY: Resource = preload("uid://3vyk1kg265sn")
const CHATELET: Resource = preload("uid://v008qkdot8fp")
const EUSTACHE: Resource = preload("uid://bsx26338og6x2")
const POMPIDOU: Resource = preload("uid://bjk40iqthhx31")
const STATUES: Resource = preload("uid://dcunsckap4hy7")

@onready var current: Node = $Current
@onready var place_name: Control = $NameContainer
@onready var player: Player = $Player

var left: bool = true
var text_tween: Variant = null
var id: int = 0
var spawn_in_center: bool = true


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
	id += 1
	Util.current_place = p

	for node in current.get_children():
		node.queue_free()

	var place: Location = get_scene(p).instantiate()
	current.add_child(place)
	show_place_name(p)
	
	var l = place.left.global_position
	var r = place.right.global_position
	if spawn_in_center:
		spawn_in_center = false
		player.global_position = (l + r) / 2.0
	elif left: player.global_position = l
	else: player.global_position = r
	player.set_limits(l, r)


func show_place_name(p: Util.Places) -> void:
	if text_tween != null:
		(text_tween as Tween).stop()
	
	var pn = get_place_name(p)
	for text in place_name.get_children():
		text.text = pn
	place_name.modulate = Color("fff")
	
	var i = id
	await Util.wait(Values.LOCATION_TITLE_DISAPPEAR_DELAY)
	if id != i: return
	
	text_tween = get_tree().create_tween()
	text_tween.tween_property(place_name, "modulate", Color("#ffffff00"), Values.LOCATION_TITLE_DISAPPEAR_DURATION)
	text_tween.set_ease(Tween.EASE_OUT)
	text_tween.play()


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
