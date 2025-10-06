extends Location

enum ExplosionState {
	IDLE,
	ONGOING,
	AFTER,
}

var explosion_force := 150
var gravity := Vector2(0, 300)
var explosion_state = ExplosionState.IDLE
var velocities: Array[Vector2] = []

@onready var parts := [
	$EiffelTower/Part1,
	$EiffelTower/Part2,
	$EiffelTower/Part3,
	$EiffelTower/Part4,
]
@onready var manager_dialog: Node2D = $ManagerDialog
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var dialog_position: Node2D = $ManagerDialog/DialogPosition


func _ready() -> void:
	if not Progress.intro_done:
		Util.cutscene_playing = true
		await play_intro()
		Util.cutscene_playing = false


func play_intro() -> void:
	await Util.wait(1)
	
	manager_dialog.visible = true
	
	await Util.show_dialog(
		Util.BOSS_NAME,
		"""
		This is a top priority mission. An attack
		is being planned. We forgot about it but I
		guess we still have time!
		""",
		dialog_position.global_position
	)
	
	await Util.wait(0.5)
	trigger_explosion()
	await Util.wait(4.0)

	await Util.show_dialog(
		Util.BOSS_NAME,
		"""
		Bertrand?$
		Are you still there?$
		What happened?
		""",
		dialog_position.global_position
	)
	
	Progress.intro_done = true
	manager_dialog.visible = false


func trigger_explosion() -> void:
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(.2).timeout

	for p in parts:
		var dir = Vector2(randf() * 2 - 1, randf() * -2).normalized()
		velocities.append(dir * explosion_force)
	explosion_state = ExplosionState.ONGOING

func _process(delta: float) -> void:
	match explosion_state:
		ExplosionState.ONGOING:
			var finished = false
			for i in velocities.size():
				velocities[i] += gravity * delta
				parts[i].position += velocities[i] * delta
				finished = finished && parts[i].position.y < 0
			if finished:
				explosion_state = ExplosionState.AFTER
		ExplosionState.AFTER:
			for i in parts.size():
				parts[i].visible += false
				explosion_state = ExplosionState.IDLE
