extends Location

@onready var phryge: Actor = $Phryge


func _on_phryge_interact() -> void:
	if Progress.has_all_pieces():
		await Util.show_dialog(
			"Phryge",
			"""
			Agent B, you saved the day!
			""",
			phryge.position
		)
	elif Progress.sphinx_riddle_enabled and not Progress.sphinx_riddle_solved:
		if Progress.metro_ticket:
			await Util.show_dialog(
				"Phryge",
				"""
				The sphinx riddle is not so easy...
				You could try using this metro ticket?
				""",
				phryge.position
			)
		else:
			await Util.show_dialog(
				"Phryge",
				"""
				I saw a ticket on the floor
				in the metro station!
				Is it yours?
				""",
				phryge.position
			)
	elif not Progress.eiffel_pieces.has(Progress.Pieces.Statues):
		await Util.show_dialog(
			"Phryge",
			"""
			These statues at the Louvre
			museum are suspicious...
			""",
			phryge.position
		)
	elif Progress.metro_ticket:
		await Util.show_dialog(
			"Phryge",
			"""
			Locations with the pieces you
			need to collect are shown on
			the metro map!
			""",
			phryge.position
		)
	else:
		await Util.show_dialog(
			"Phryge",
			"""
			Agent M, help us!
			""",
			phryge.position
		)
