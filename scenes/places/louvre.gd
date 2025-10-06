extends Location

const RAT = preload("uid://c3gdepdxmt38g")

@onready var test: Actor = $Test
@onready var rat_path: Path2D = $RatPath

const SPAWN_INTERVAL := 0.5
const FULL_ANIMATION_LENGTH := 15.0
const RATS_COUNT := 30
const SCREEN_MID_X := 180.0 # adjust for your viewport width

var spawn_timer := 0.0
var spawned := 0
var max_progress := 1.0
var followers: Array[PathFollow2D] = []

func _process(delta: float) -> void:
	if max_progress <= 0.0:
		return

	spawn_timer += delta
	if spawn_timer >= SPAWN_INTERVAL:
		spawn_timer = 0.0
		spawn_rat()

	for f in followers:
		var rat = f.get_child(0)

		var data = rat_path.curve.sample_baked_with_rotation(f.progress)
		var angle = data.get_rotation()
		rat.scale.x = sign(cos(angle)) if cos(angle) != 0 else 1
		rat.rotation = PI / 2 * sign(cos(angle)) if sin(angle) >= 0 else 0.0

func spawn_rat() -> void:
	var follow := PathFollow2D.new()
	follow.loop = false
	follow.rotates = false
	follow.progress_ratio = 0.0
	rat_path.add_child(follow)

	var rat := RAT.instantiate()
	follow.add_child(rat)
	rat.play("Walk")

	var target_progress = max_progress
	max_progress -= 1.0 / RATS_COUNT
	spawned += 1
	followers.append(follow)

	var tween := create_tween()
	tween.tween_property(follow, "progress_ratio", target_progress, max_progress * FULL_ANIMATION_LENGTH)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func ():
		rat.play("Idle")
	)

	# Mirror/rotate based on half of screen
	if rat.global_position.x < SCREEN_MID_X:
		rat.scale.x = 1
	else:
		rat.scale.x = -1

func _on_test_interact() -> void:
	await Util.show_dialog(
		"actor text",
		"""
		Test of text.
		Line 2.
		Wow even more lines
		wtfffff.
		""",
		test.global_position
	)
	Log.info("finished")
