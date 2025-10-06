extends Location

@onready var light_1: PointLight2D = $Light1
@onready var light_2: PointLight2D = $Light2
@onready var light_3: PointLight2D = $Light3
@onready var light_4: PointLight2D = $Light4
@onready var light_5: PointLight2D = $Light5

@onready var eiffel_piece: Sprite2D = $EiffelPiece

var lights = [false, false, false, false, false]


func _ready() -> void:
	inverse([])


func _on_statue_1_interact() -> void:
	inverse([2, 3, 4])


func _on_statue_2_interact() -> void:
	inverse([0, 1, 3])


func _on_statue_3_interact() -> void:
	inverse([1, 2, 4])


func _on_statue_4_interact() -> void:
	inverse([0, 2, 4])


func inverse(indices: Array[int]) -> void:
	for i in indices:
		lights[i] = not lights[i]
	
	(light_1.texture as GradientTexture2D).gradient.set_color(0, get_color(0))
	(light_2.texture as GradientTexture2D).gradient.set_color(0, get_color(1))
	(light_3.texture as GradientTexture2D).gradient.set_color(0, get_color(2))
	(light_4.texture as GradientTexture2D).gradient.set_color(0, get_color(3))
	(light_5.texture as GradientTexture2D).gradient.set_color(0, get_color(4))


func get_color(i: int) -> Color:
	if lights[i]: return Color("#6bc96c")
	return Color("#a32858")
