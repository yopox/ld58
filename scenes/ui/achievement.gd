extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var title: Label = $Title
@onready var subtitle: Label = $Subtitle


func _ready() -> void:
	title.modulate = Color("#ffffff00")
	subtitle.modulate = Color("#ffffff00")
	Signals.show_achievement.connect(show_achievement)


func show_achievement(title_text: String, subtitle_text: String) -> void:
	Util.achievement_shown = true
	
	if Util.achievement_node != null:
		var t0 = create_tween()
		t0.set_trans(Tween.TRANS_QUAD)
		t0.tween_property(Util.achievement_node, "global_position", Vector2(Values.SCREEN_W / 2.0, Values.SCREEN_H / 2.0), Values.ACHIEVEMENT_OBJECT_TIME)
	
	title.text = title_text
	subtitle.text = subtitle_text
	
	var t1 = create_tween()
	t1.set_trans(Tween.TRANS_QUAD)
	t1.tween_property(color_rect, "material:shader_parameter/circle_size", 0.1, Values.ACHIEVEMENT_CIRCLE_TIME)
	await t1.finished
	
	await Util.wait(Values.ACHIEVEMENT_TEXT_DELAY)
	
	var t2 = get_tree().create_tween()
	t2.set_trans(Tween.TRANS_QUAD)
	t2.tween_property(title, "modulate", Color("fff"), Values.ACHIEVEMENT_TEXT_TIME)
	t2.play()
	await t2.finished
	
	await Util.wait(Values.ACHIEVEMENT_TEXT_DELAY)
	
	var t3 = get_tree().create_tween()
	t3.set_trans(Tween.TRANS_QUAD)
	t3.tween_property(subtitle, "modulate", Color("fff"), Values.ACHIEVEMENT_TEXT_TIME)
	t3.play()
	await t3.finished

	await Signals.confirm
	
	var t4 = get_tree().create_tween()
	t4.set_trans(Tween.TRANS_QUAD)
	t4.tween_property(title, "modulate", Color("ffffff00"), Values.ACHIEVEMENT_TEXT_TIME)
	t4.play()
	var t5 = get_tree().create_tween()
	t5.set_trans(Tween.TRANS_QUAD)
	t5.tween_property(subtitle, "modulate", Color("ffffff00"), Values.ACHIEVEMENT_TEXT_TIME)
	t5.play()
	
	if Util.achievement_node != null:
		var t6 = create_tween()
		t6.set_trans(Tween.TRANS_QUAD)
		t6.tween_property(Util.achievement_node, "modulate", Color("ffffff00"), Values.ACHIEVEMENT_TEXT_TIME)
	
	await t5.finished
	
	if Util.achievement_node != null:
		Util.achievement_node.queue_free()
	
	var t6 = create_tween()
	t6.set_trans(Tween.TRANS_QUAD)
	t6.tween_property(color_rect, "material:shader_parameter/circle_size", 1.1, Values.ACHIEVEMENT_TEXT_TIME)
	
	Util.achievement_shown = false
