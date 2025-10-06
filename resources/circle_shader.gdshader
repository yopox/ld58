shader_type canvas_item;

uniform float circle_size : hint_range(0.0, 1.1) = 0.1;
uniform float ratio_width = 320.0;
uniform float ratio_height = 180.0;

void fragment() {
	float ratio = ratio_width / ratio_height;
	float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, ratio), UV.y));
	vec4 orig_color = texture(TEXTURE, UV);
	COLOR.a = step(circle_size, dist) * orig_color.a;
}