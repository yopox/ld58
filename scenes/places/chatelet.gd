extends Location

@onready var sphinx: Actor = $Sphinx
@onready var eiffel_piece: Sprite2D = $EiffelPiece


func _ready() -> void:
	if not Progress.sphinx_riddle_solved or Progress.eiffel_pieces.has(Progress.Pieces.Sphinx):
		eiffel_piece.visible = false
	else:
		await Util.wait(Values.CHATELET_RIDDLE_SOLVED_DELAY)
		Progress.eiffel_pieces[Progress.Pieces.Sphinx] = true
		Util.achievement_node = eiffel_piece
		Signals.show_achievement.emit(Values.ACHIEVEMENT_TITLE, Progress.get_subtitle())


func _on_sphinx_interact() -> void:
	if Progress.sphinx_riddle_solved:
		await Util.show_dialog(
			"Sphinx",
			"""
			You solved my riddle!
			""",
			sphinx.position
		)
		return
	else:
		await Util.show_dialog(
			"Sphinx",
			"""
			With a distant technology,
			Travel, travel,
			from me, to me!
			""",
			sphinx.position
		)
		Progress.sphinx_riddle_enabled = true
