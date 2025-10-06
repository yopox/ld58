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

var state: State = State.SPEECH
var dot: bool = false


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
			dot = true
			pin.visible = true
			pin.global_position = hand.global_position
			# TODO: move map position
			# TODO: random text for paris


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
	
	await location_selected
	
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
