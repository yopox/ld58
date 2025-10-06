extends Node2D

const INTRO: Resource = preload("uid://rsmqadxb46ht")
const OUTRO: Resource = preload("uid://tqj0txmixujs")
const PARIS: Resource = preload("uid://dwge4gdfmiw6k")
const PLACE: Resource = preload("uid://c20p8uid5qfsa")
const TITLE: Resource = preload("uid://vuuh8jo82i3")

var scene: Util.Scenes = Util.Scenes.TITLE

@onready var scene_node: Node = $scene


func _ready() -> void:
	change_scene(scene)
	Signals.change_scene.connect(change_scene)


func change_scene(new_scene: Util.Scenes) -> void:
	for node in scene_node.get_children():
		node.queue_free()
	var s = get_scene(new_scene)
	Log.info("Changing scene to", new_scene)
	var s_node = s.instantiate()
	scene_node.add_child(s_node)


func get_scene(s: Util.Scenes) -> Resource:
	match s:
		Util.Scenes.INTRO:
			return INTRO
		Util.Scenes.OUTRO:
			return OUTRO
		Util.Scenes.PARIS_MAP:
			return PARIS
		Util.Scenes.PLACE:
			return PLACE
		_:
			return TITLE


func _on_exit_pressed() -> void:
	get_tree().quit()
