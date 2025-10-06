extends Location

enum RatState {
	BEFORE,
	STARTED,
	BEFORE_EXPLODING,
	EXPLODING,
	DONE,
}

const FULL_ANIMATION_LENGTH := 15.0
const RAT = preload("uid://c3gdepdxmt38g")
const RATS_COUNT := 45
const SPAWN_INTERVAL := 0.5

var explosion_force := 150
var followers: Array[PathFollow2D] = []
var gravity := Vector2(0, 300)
var max_progress := 0.0
var rat_state = RatState.BEFORE
var spawn_timer := 0.0
var spawned := 0
var velocities: Array[Vector2] = []

@onready var path_a: Path2D = $Notes/NoteA/PathA
@onready var path_b: Path2D = $Notes/NoteB/PathB
@onready var path_c: Path2D = $Notes/NoteC/PathC
@onready var path_d: Path2D = $Notes/NoteD/PathD
@onready var path_e: Path2D = $Notes/NoteE/PathE
@onready var music_player: Actor = $MusicPlayer
@onready var rat_path: Path2D = $RatPath
@onready var notes: Node2D = $Notes


func _process(delta: float) -> void:
	match rat_state:
		RatState.STARTED:
			for rat in followers:
				var data = rat_path.curve.sample_baked_with_rotation(rat.progress)
				var angle = data.get_rotation()
				rat.scale.x = sign(cos(angle)) if cos(angle) != 0 else 1
				rat.rotation = PI / 2 * sign(cos(angle)) if sin(angle) >= 0 else 0.0

			if max_progress <= 1.0:
				spawn_timer += delta
				if spawn_timer >= SPAWN_INTERVAL:
					spawn_timer = 0.0
					spawn_rat()
			else:
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


func explode() -> void:
	rat_state = RatState.BEFORE_EXPLODING
	for rat in followers:
		rat.get_child(0).play("Idle")
		rat.scale.x = 1
		rat.rotation = 0.0
		var tween = rat.get_meta("tween", null)
		if tween and tween.is_running():
			tween.stop()
		var dir = Vector2(randf() * 2 - 1, randf() * -2).normalized()
		velocities.append(dir * explosion_force)

	await Util.wait(1)
	rat_state = RatState.EXPLODING


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
	tween.tween_property(follow, "progress_ratio", target_progress, max_progress * FULL_ANIMATION_LENGTH)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(
		func():
			rat.play("Dance")
	)
	follow.set_meta("tween", tween)


func _on_test_interact() -> void:
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
	await Util.wait(5)
	explode()
