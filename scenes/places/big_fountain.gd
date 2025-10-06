extends Location

@onready var romantic_couple: Actor = $"Romantic Couple"
@onready var eiffel_piece: Sprite2D = $EiffelPiece
@onready var delivery_guy: Actor = $"Delivery Guy"

var delivery_talked: bool = false


func _on_romantic_couple_interact() -> void:
	if not Progress.eiffel_pieces.get(Progress.Pieces.Couple, false):
		await Util.show_dialog(
			"Passionate date person",
			"""
			He said he'd offer me the stars and
			gave me this ugly piece of metal.../
			It's too much for a first date, but also
			too heavy for me to run away.../
			Please...$ take it...$
			""",
			romantic_couple.global_position,
		)
		Progress.eiffel_pieces[Progress.Pieces.Couple] = true
		Util.achievement_node = eiffel_piece
		Signals.show_achievement.emit(Values.ACHIEVEMENT_TITLE, Progress.get_subtitle())
	else:
		await Util.show_dialog(
			"Passionate date person",
			"""
			Now you lifted this heavy weight off my
			chest, I actually start to like this
			person!
			""",
			romantic_couple.global_position,
		)

func _on_delivery_guy_interact() -> void:
	if not delivery_talked:
		await Util.show_dialog(
			"Delivery biker",
			"""
			...
			""",
			delivery_guy.global_position,
		)
		delivery_talked = true
	else:
		await Util.show_dialog(
			"Delivery biker",
			"""
			Sorry, je ne parle pas anglais.
			""",
			delivery_guy.global_position,
		)
