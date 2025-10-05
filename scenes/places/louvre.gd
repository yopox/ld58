extends Node2D

@onready var test: Actor = $Test

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
