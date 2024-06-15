shader_type canvas_item;

uniform sampler2D noise : repeat_enable;

void fragment() {
	float sample = texture(noise, 0.33 * UV + vec2(0., 1.) * TIME).x;
	COLOR.a *= pow(UV.y, 1.5) - sample * 0.5 - pow(abs(0.5 - UV.x), 1.5) * 2.;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
