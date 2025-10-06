class_name Place
extends Node2D

const LOUVRE: Resource = preload("uid://bw3hbaknbx1qh")
const BIG_FOUNTAIN: Resource = preload("uid://cdnaw3bjl0cjj")
const ORSAY: Resource = preload("uid://3vyk1kg265sn")
const CHATELET: Resource = preload("uid://v008qkdot8fp")
const EUSTACHE: Resource = preload("uid://bsx26338og6x2")
const POMPIDOU: Resource = preload("uid://bjk40iqthhx31")
const STATUES: Resource = preload("uid://dcunsckap4hy7")
const METRO: Resource = preload("uid://dcl53jv2pulnk")

@onready var current: Node = $Current
@onready var place_name: Label = $Name
@onready var player: Player = $Player

var left: bool = true
var text_tween: Variant = null
var id: int = 0


func _ready() -> void:
	set_current_place(Progress.place)
	Signals.move_left.connect(move_left)
	Signals.move_right.connect(move_right)


func move_left() -> void:
	var i = Util.places.find(Progress.place)
	left = false
	set_current_place(Util.places[posmod(i - 1, Util.places.size())])


func move_right() -> void:
	var i = Util.places.find(Progress.place)
	left = true
	set_current_place(Util.places[posmod(i + 1, Util.places.size())])


func set_current_place(p: Util.Places) -> void:
	id += 1
	Progress.place = p

	for node in current.get_children():
		node.queue_free()

	var place: Location = get_scene(p).instantiate()
	current.add_child(place)
	show_place_name(p)
	
	var l = place.left.global_position
	var r = place.right.global_position
	if Util.spawn_in_center:
		Util.spawn_in_center = false
		player.global_position = (l + r) / 2.0
	elif left: player.global_position = l
	else: player.global_position = r
	player.set_limits(l, r)


func show_place_name(p: Util.Places) -> void:
	if text_tween != null:
		(text_tween as Tween).stop()
	
	var pn = get_place_name(p)
	place_name.text = pn
	place_name.modulate = Color("fff")
	
	var i = id
	await Util.wait(Values.LOCATION_TITLE_DISAPPEAR_DELAY)
	if id != i: return
	
	text_tween = get_tree().create_tween()
	text_tween.tween_property(place_name, "modulate", Color("#ffffff00"), Values.LOCATION_TITLE_DISAPPEAR_DURATION)
	text_tween.set_ease(Tween.EASE_OUT)
	text_tween.play()


static func get_place_name(place: Util.Places) -> String:
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
		Util.Places.METRO:
			return "Metro Station"
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
		Util.Places.METRO: return METRO
		_: return LOUVRE


func _on_exit_pressed() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
