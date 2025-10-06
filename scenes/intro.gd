extends Node2D

signal location_selected()

enum State {
	SPEECH,
	SELECT_LOCATION,
}

@onready var hand: Sprite2D = $Hand
@onready var map: Node2D = $Map
@onready var pin: Sprite2D = $Pin

const TEXTBOX_POS: Vector2 = Vector2(Values.SCREEN_W / 2.0, Values.SCREEN_H + 16.0)
const PARIS_OFFSET: Vector2 = Vector2(112 - 35, 24 - 7)

var state: State = State.SPEECH
var first_point: bool = true
var dot: bool = false
var last_random_text: int = 0


func _ready() -> void:
	play_intro()


func _process(delta: float) -> void:
	if state != State.SELECT_LOCATION: return
	
	var dir = Vector2.ZERO
	if Input.is_action_pressed("right"):
		dir += Vector2(1, 0)
		dot = false
	if Input.is_action_pressed("left"):
		dir += Vector2(-1, 0)
		dot = false
	if Input.is_action_pressed("up"):
		dir += Vector2(0, -1)
		dot = false
	if Input.is_action_pressed("down"):
		dir += Vector2(0, 1)
		dot = false
	
	dir = dir.normalized()
	hand.global_position += dir * delta * Values.HAND_SPEED
	
	if Input.is_action_just_pressed("a"):
		if dot:
			location_selected.emit()
		else:
			if hand.position.x < 112 or hand.position.x > 265 or hand.position.y < 24 or hand.position.y > 100:
				if hand.position.x < 57 or hand.position.x > 87 or hand.position.y < 39 or hand.position.y > 88:
					await Util.show_dialog_persist(
						"""
						Please point on the map.
						Point twice to confirm.
						"""
					)
				else:
					await Util.show_dialog_persist(
						"""
						Ouch!
						"""
					)
			else:
				dot = true
				pin.visible = true
				pin.global_position = hand.global_position
				update_map()
				if first_point:
					first_point = false
					await Util.show_dialog_persist(
						"""
						France? Lovely!
						Are you sure though?
						Press space again or select another place.
						"""
					)
				else:
					await show_random_paris_text()


func play_intro() -> void:
	await Util.show_textbox(TEXTBOX_POS, Util.BOSS_NAME)
	await Util.show_dialog_persist(
		"""
		Hello agent!
		Ready for your next mission?/
		We have a few destinations available,
		please point where you want to go.
		"""
	)
	
	await Util.wait(0.5)
	
	var hand_pos = Vector2(208, 80)
	var t1 = get_tree().create_tween()
	t1.set_trans(Tween.TRANS_QUAD)
	t1.tween_property(hand, "global_position", hand_pos, Values.INTRO_HAND_APPEAR)
	t1.play()
	await t1.finished
	
	state = State.SELECT_LOCATION
	Util.textbox_auto_next = true
	await location_selected
	Util.textbox_auto_next = false
	state = State.SPEECH
	
	var hand_pos_2 = Vector2(hand.global_position.x, 192)
	var t2 = get_tree().create_tween()
	t2.set_trans(Tween.TRANS_QUAD)
	t2.tween_property(hand, "global_position", hand_pos_2, Values.INTRO_HAND_APPEAR)
	t2.play()
	await t2.finished
	
	await Util.show_dialog_persist(
		"""
		Ok, I guess you're really into Paris,
		see you on the field!
		"""
	) 
	await Util.hide_textbox()
	
	await Util.wait(1.0)
	
	Progress.mission_done = true
	Progress.place = Util.Places.ORSAY
	Signals.change_scene.emit(Util.Scenes.PLACE)


func update_map() -> void:
	map.position = hand.position -  PARIS_OFFSET
	
	
	if map.position.x > 112:
		map.get_child(1).position.x = -153
		map.get_child(3).position.x = -153
	else:
		map.get_child(1).position.x = 153
		map.get_child(3).position.x = 153
	
	if map.position.y > 24:
		map.get_child(2).position.y = -76
		map.get_child(3).position.y = -76
	else:
		map.get_child(2).position.y = 76
		map.get_child(3).position.y = 76


func show_random_paris_text() -> void:
	var texts = [
		"""
		Come on, give it another shot.
		""",
		"""
		Bonjour :)
		""",
		"""
		You're really into going to Paris,
		right?
		""",
		"""
		Don't you want some sun and
		non-grumpy people?
		""",
		"""
		Just tell me when you are done.
		""",
		"""
		Paris is the capital and largest city
		of France, with an estimated city
		population of 2,048,472 in an area of
		105.4 km2, and a metropolitan population
		of 13,171,056 as of January 2025.
		Located on the river Seine in the centre
		of the Ile-de-France region, it is the
		largest metropolitan area and fourth-most
		populous city in the European Union.
		Nicknamed the City of Light, because
		of its role in the Age of Enlightenment,
		Paris has been one of the world's major
		centres of finance, diplomacy, commerce,
		culture, fashion, and gastronomy
		since the 17th century. 
		"""
	]
	
	var i = randi_range(0, texts.size() - 1)
	while i == last_random_text:
		i = randi_range(0, texts.size() - 1)
	last_random_text = i
	
	await Util.show_dialog_persist(texts[i])
