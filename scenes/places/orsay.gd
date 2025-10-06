extends Location

enum ExplosionState {
	IDLE,
	ONGOING,
	REVERSE,
	AFTER,
}

var explosion_force := 150
var gravity := Vector2(0, 300)
var explosion_state = ExplosionState.IDLE
var velocities: Array[Vector2] = []

@onready var eiffel_tower: Node2D = $EiffelTower
@onready var parts := [
	$EiffelTower/Part1,
	$EiffelTower/Part2,
	$EiffelTower/Part3,
	$EiffelTower/Part4,
]
@onready var manager_dialog: Node2D = $ManagerDialog
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var dialog_position: Node2D = $ManagerDialog/DialogPosition


var textbox_offset = Vector2(0, Values.TEXTBOX_APPEAR_DY + Values.TEXTBOX_H / 2)

func _ready() -> void:
	if not Progress.intro_done:
		eiffel_tower.visible = true
		Util.cutscene_playing = true
		await play_intro()
		Util.cutscene_playing = false
	elif not Progress.outro_done and Progress.has_all_pieces():
		Util.cutscene_playing = true
		await play_outro()
		Util.cutscene_playing = false
	elif Progress.outro_done:
		eiffel_tower.visible = true
		await tilt_parts()


func play_intro() -> void:
	await Util.wait(1)

	manager_dialog.visible = true

	await Util.show_dialog(
		Util.BOSS_NAME,
		"""
		Bertrand, are you on the field?
		With this bread costume you should
		be incognito around here.
		This is a top priority mission. An attack
		is being planned. We forgot about it but
		I guess that we still have time!
		""",
		dialog_position.global_position - textbox_offset
	)

	await Util.wait(0.5)
	Signals.player_shocked.emit()
	trigger_explosion()
	await Util.wait(4.0)

	await Util.show_dialog(
		Util.BOSS_NAME,
		"""
		Bertrand?$
		Are you still there?$
		What happened?
		""",
		dialog_position.global_position - textbox_offset
	)

	Progress.intro_done = true
	manager_dialog.visible = false

func play_outro() -> void:
	await Util.wait(1)

	manager_dialog.visible = true

	await Util.show_dialog(
		Util.BOSS_NAME,
		"""
		Bertrand, we made it! Let's rebuild the
		tower now. The tower-repairing duct tape
		in your gadgets should help.
		""",
		dialog_position.global_position - textbox_offset
	)

	await Util.wait(0.5)
	Signals.player_shocked.emit()
	await trigger_repair()
	await Util.wait(1.0)

	await Util.show_dialog(
		Util.BOSS_NAME,
		"""
		Amazing! With your quality work no one
		will notice it was a ever damaged!/
		This was the last mission we had in
		store, so you will no longer working with
		us./
		Thank you for your service!$
		It was a pleasure to be your Cap-tain!
		""",
		dialog_position.global_position - textbox_offset
	)

	Progress.outro_done = true
	manager_dialog.visible = false

func trigger_explosion() -> void:
	cpu_particles_2d.emitting = true
	await Util.wait(.2)

	for p in parts:
		var dir = Vector2(randf() * 2 - 1, randf() * -2).normalized()
		velocities.append(dir * explosion_force)
	explosion_state = ExplosionState.ONGOING

func tilt_parts() -> void:
	var last_rotation = PI / 30
	for p in parts:
		last_rotation = - last_rotation
		p.rotation = last_rotation

func trigger_repair() -> void:
	var tweens: Array[Tween] = []

	await tilt_parts()
	for p in parts:
		var start_pos := Vector2.from_angle(randf_range(0, TAU)) * 400.0
		var tween := create_tween()
		tween.tween_property(p, "position", Vector2.ZERO, 1.0).from(start_pos).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tweens.append(tween)

	eiffel_tower.visible = true

	for t in tweens:
		await t.finished


	cpu_particles_2d.emitting = true
	await Util.wait(.2)

func _process(delta: float) -> void:
	match explosion_state:
		ExplosionState.ONGOING:
			var finished = true
			for i in velocities.size():
				velocities[i] += gravity * delta
				parts[i].position += velocities[i] * delta
				finished = finished && parts[i].global_position.y > Values.SCREEN_H
			if finished:
				explosion_state = ExplosionState.AFTER
		ExplosionState.REVERSE:
			var finished = true
			for i in velocities.size():
				velocities[i] += gravity * delta
				parts[i].position += velocities[i] * delta
				finished = finished && parts[i].position.length()
			if finished:
				explosion_state = ExplosionState.AFTER
		ExplosionState.AFTER:
			for i in parts.size():
				parts[i].visible = false
				explosion_state = ExplosionState.IDLE
