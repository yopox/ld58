extends Location

@onready var ticket: Actor = $Ticket

func _ready() -> void:
	if Progress.metro_ticket:
		ticket.visible = false


func _on_ticket_interact() -> void:
	if Progress.metro_ticket: return
	
	Util.achievement_node = ticket
	Signals.show_achievement.emit(
		"Metro Ticket Collected!",
		"Press M to use the metro."
	)
	Progress.metro_ticket = true
