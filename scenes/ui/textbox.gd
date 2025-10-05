extends Node2D

var frame: int = Values.TEXTBOX_CHAR_FRAMES
var line: int = 0
var remaining: String = ""

@onready var bubble: NinePatchRect = $Bubble
@onready var speaker: Label = $Speaker
@onready var text: Label = $Text


func _ready() -> void:
	bubble.size.x = Values.TEXTBOX_W
	bubble.size.y = Values.TEXTBOX_H

	speaker.text = ""
	text.text = ""
	modulate = Color("#ffffff00")
	Signals.show_dialog.connect(show_dialog)


func appear(p: Vector2) -> void:
	position = p + Vector2(0, Values.TEXTBOX_APPEAR_DY)

	var t1 = get_tree().create_tween()
	t1.tween_property(self, "modulate", Color("#fff"), Values.TEXTBOX_APPEAR_DELAY)
	t1.set_ease(Tween.EASE_OUT)
	t1.play()

	var t2 = get_tree().create_tween()
	t2.tween_property(self, "position", p, Values.TEXTBOX_APPEAR_DELAY)
	t2.set_ease(Tween.EASE_OUT)
	t2.play()

	await t1.finished


func consume_char() -> void:
	await get_tree().process_frame

	if frame == Values.TEXTBOX_CHAR_FRAMES:
		match remaining[0]:
			'$':
				await Signals.confirm
			'\n':
				line += 1
				if line % 2 == 0:
					await Signals.confirm
					text.text = ""
				else:
					text.text += "\n"
			_:
				text.text += remaining[0]
		remaining = remaining.substr(1)
		frame = 0
	else:
		frame += 1


func disappear() -> void:
	var p = position + Vector2(0, Values.TEXTBOX_APPEAR_DY)

	var t1 = get_tree().create_tween()
	t1.tween_property(self, "modulate", Color("#ffffff00"), Values.TEXTBOX_APPEAR_DELAY)
	t1.set_ease(Tween.EASE_OUT)
	t1.play()

	var t2 = get_tree().create_tween()
	t2.tween_property(self, "position", p, Values.TEXTBOX_APPEAR_DELAY)
	t2.set_ease(Tween.EASE_OUT)
	t2.play()

	await t1.finished


func show_dialog(speaker_name: String, dialog: String, p: Vector2) -> void:
	Util.dialog_shown = true
	frame = Values.TEXTBOX_CHAR_FRAMES
	speaker.text = speaker_name
	text.text = ""
	line = 0
	remaining = dialog.substr(1, dialog.length() - 4)

	var pos = p + Values.TEXTBOX_OFFSET
	pos.x = clampf(pos.x, Values.TEXTBOX_MIN_X, Values.SCREEN_W - Values.TEXTBOX_W - Values.TEXTBOX_MIN_X)
	await appear(pos)

	while remaining != "":
		await consume_char()

	await Signals.confirm
	await disappear()

	Signals.dialog_over.emit()
	Util.dialog_shown = false
