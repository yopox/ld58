shader_type canvas_item;

void fragment() {
    float alpha = texture(TEXTURE, UV).a;
	if (alpha > 0.01) {
    	COLOR.a = 1.0;
	}
}