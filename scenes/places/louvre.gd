extends Location

enum RatState {
	BEFORE,
	STARTED,
	BEFORE_EXPLODING,
	EXPLODING,
	DONE,
}

const NOTE = preload("uid://crnpelln8qmhe")
const NOTE_ARRIVAL_LENGTH := 4.0
const NOTE_INTERVAL := 1.0
const NOTE_QUEUE := ["A", "C", "D", "E", "A", "B"]
const RAT = preload("uid://c3gdepdxmt38g")
const RATS_COUNT := 45

var FULL_ANIMATION_LENGTH := NOTE_QUEUE.size() * NOTE_INTERVAL + NOTE_ARRIVAL_LENGTH
var RAT_ANIMATION_LENGTH := FULL_ANIMATION_LENGTH / 2
var SPAWN_INTERVAL := RAT_ANIMATION_LENGTH / RATS_COUNT
# @onready var audio_players = {
# 	"a": $Audio_A,
# 	"b": $Audio_B,
# 	"c": $Audio_C,
# 	"d": $Audio_D,
# 	"e": $Audio_E
# }
var active_notes = {
	"A": [],
	"B": [],
	"C": [],
	"D": [],
	"E": [],
}
var explosion_force := 150
var followers: Array[PathFollow2D] = []
var gravity := Vector2(0, 300)
var max_progress := 0.0
var note_index := 0
var note_timer := 0.0
var rat_state = RatState.BEFORE
var spawn_timer := 0.0
var spawned := 0
var velocities: Array[Vector2] = []

# seconds between notes
@onready var paths = {
	"A": $Notes/NoteA/PathA,
	"B": $Notes/NoteB/PathB,
	"C": $Notes/NoteC/PathC,
	"D": $Notes/NoteD/PathD,
	"E": $Notes/NoteE/PathE,
}
@onready var music_player: Actor = $MusicPlayer
@onready var rat_path: Path2D = $RatPath
@onready var notes: Node2D = $Notes


func _process(delta: float) -> void:
	match rat_state:
		RatState.STARTED:
			process_notes(delta)

			var lost = false
			var win = note_index >= NOTE_QUEUE.size()
			for key in active_notes.keys():
				for note in active_notes[key]:
					win = false
					if note.progress_ratio >= 1.0:
						lost = true
			if lost:
				explode()

			for rat in followers:
				var data = rat_path.curve.sample_baked_with_rotation(rat.progress)
				var angle = data.get_rotation()
				rat.scale.x = sign(cos(angle)) if cos(angle) != 0 else 1
				rat.rotation = PI / 2 * sign(cos(angle)) if sin(angle) >= 0 else 0.0
				var tween = rat.get_meta("tween")
				if tween.is_running():
					win = false

			if max_progress <= 1.0:
				spawn_timer += delta
				if spawn_timer >= SPAWN_INTERVAL:
					spawn_timer = 0.0
					spawn_rat()

			if win:
				rat_state = RatState.DONE
		RatState.EXPLODING:
			var finished = true
			for i in velocities.size():
				if i < followers.size():
					velocities[i] += gravity * delta
					followers[i].position += velocities[i] * delta
					finished = finished && followers[i].global_position.y > Values.SCREEN_H
			if finished:
				rat_state = RatState.BEFORE
				cleanup_rats()
				await Util.show_dialog(
					"Flute player",
					"""
					You're not a fresh baguette after all...
					""",
					music_player.global_position,
				)


func cleanup_rats() -> void:
	notes.visible = false
	for f in followers:
		if is_instance_valid(f):
			f.queue_free()
	followers.clear()
	spawned = 0
	max_progress = 1.0
	spawn_timer = 0.0
	Util.cutscene_playing = false


func explode() -> void:
	rat_state = RatState.BEFORE_EXPLODING
	for key in active_notes.keys():
		for note in active_notes[key]:
			note.queue_free()
		active_notes[key].clear()
	for rat in followers:
		rat.get_child(0).play("Idle")
		rat.scale.x = 1
		rat.rotation = 0.0
		var tween = rat.get_meta("tween")
		if tween.is_running():
			tween.stop()
		var dir = Vector2(randf() * 2 - 1, randf() * -2).normalized()
		velocities.append(dir * explosion_force)

	await Util.wait(1)
	rat_state = RatState.EXPLODING


func fire_note_from_queue(note_char: String) -> void:
	var note_instance = NOTE.instantiate()
	note_instance.play(note_char)

	var follow = PathFollow2D.new()
	follow.rotates = false
	paths[note_char].add_child(follow)
	follow.add_child(note_instance)
	note_instance.position = Vector2.ZERO

	var tween := create_tween()
	tween.tween_property(follow, "progress_ratio", 1.0, NOTE_ARRIVAL_LENGTH)
	tween.set_trans(Tween.TRANS_LINEAR)
	follow.set_meta("tween", tween)

	# add to active notes array
	active_notes[note_char].append(follow)


func play_note(path_key: String) -> void:
	var related_notes = active_notes[path_key]
	if related_notes.size() > 0:
		var note = related_notes.pop_front()
		var tween = note.get_meta("tween")
		if tween.is_running():
			tween.stop()
		note.queue_free()
	# audio_players[path_key].play()


func process_notes(delta) -> void:
	if Input.is_action_just_pressed("left"):
		play_note("A")
	elif Input.is_action_just_pressed("down"):
		play_note("B")
	elif Input.is_action_just_pressed("right"):
		play_note("C")
	elif Input.is_action_just_pressed("up"):
		play_note("D")
	elif Input.is_action_just_pressed("start") or Input.is_action_just_pressed("a"):
		play_note("E")

	note_timer += delta
	if note_timer >= NOTE_INTERVAL and note_index < NOTE_QUEUE.size():
		var note_char = NOTE_QUEUE[note_index]
		fire_note_from_queue(note_char)
		note_index += 1
		note_timer = 0.0


func spawn_rat() -> void:
	var follow := PathFollow2D.new()
	follow.loop = false
	follow.rotates = false
	rat_path.add_child(follow)
	follow.progress_ratio = 0.0
	follow.z_index = RATS_COUNT - followers.size()

	var rat := RAT.instantiate()
	follow.add_child(rat)
	rat.play("Walk")

	var target_progress = max_progress
	max_progress += 1.0 / RATS_COUNT
	spawned += 1
	followers.append(follow)

	var tween := create_tween()
	tween.tween_property(follow, "progress_ratio", target_progress, max_progress * RAT_ANIMATION_LENGTH)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(
		func():
			rat.play("Dance")
	)
	follow.set_meta("tween", tween)


func _on_test_interact() -> void:
	Util.cutscene_playing = true
	await Util.show_dialog(
		"Flute player",
		"""
		Wow! A walking baguette!
		You + me, let's do a perfect sound-wich.
		I've got a rat choir with me, let's go!
		""",
		music_player.global_position,
	)
	rat_state = RatState.STARTED
	notes.visible = true
