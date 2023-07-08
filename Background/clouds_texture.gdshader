shader_type canvas_item;

varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
}


void fragment() {
	vec4 cl =  texture(TEXTURE, UV + vec2(1.0,0.0) * TIME * .01);
	COLOR = cl * modulate;
}
