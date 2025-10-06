extends Node2D

const STATION = preload("uid://dqh57flwpo18s")

@onready var hand: Sprite2D = $Hand
@onready var station: Control = $Station

var x_pos = []
var selected: int = 0
var place_n: int = 0

func _ready() -> void:
	var gap = 24
	var item_x = 16 + gap / 2.0
	var x_total = Util.Places.values().size() * item_x
	var x_margin = (Values.SCREEN_W - x_total) / 2.0
	for place in Util.Places.values():
		var s: Sprite2D = Sprite2D.new()
		var s_x = x_margin + item_x * place_n + 8
		s.position.x = s_x
		x_pos.append(s_x)
		s.position.y = 136
		s.z_index = 10

		var atlas: AtlasTexture = AtlasTexture.new()
		atlas.atlas = STATION
		atlas.region.size.x = 16
		atlas.region.size.y = 16
		s.texture = atlas

		var piece = Progress.piece_for(place)
		if piece == null:
			atlas.region.position.x = 32
		elif not Progress.eiffel_pieces.has(piece):
			atlas.region.position.x = 0
		else:
			atlas.region.position.x = 16

		add_child(s)

		if place_n > 0:
			var rect = ColorRect.new()
			rect.z_index = 2
			rect.size.x = 32
			rect.size.y = 12
			rect.color = Color("#fcef8d")
			rect.position.x = x_margin + item_x * (place_n - 1) + 8
			rect.position.y = 130
			add_child(rect)

		place_n += 1

	update_hand()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		selected = posmod(selected + 1, Util.Places.values().size())
	elif Input.is_action_just_pressed("left"):
		selected = posmod(selected - 1, Util.Places.values().size())

	update_hand()

	if Input.is_action_just_pressed("a"):
		if Progress.sphinx_riddle_enabled and not Progress.sphinx_riddle_solved and Progress.place == Util.Places.CHATELET:
			Progress.sphinx_riddle_solved = Util.Places.values()[selected] == Util.Places.CHATELET
		Progress.place = Util.Places.values()[selected]
		Util.spawn_in_center = true
		Signals.change_scene.emit(Util.Scenes.PLACE)

func update_hand() -> void:
	hand.position.x = x_pos[selected]
	for label: Label in station.get_children():
		label.text = "SPACE: Travel to '%s'" % Place.get_place_name(Util.Places.values()[selected])
