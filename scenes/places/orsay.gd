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
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	trigger_explosion()


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
