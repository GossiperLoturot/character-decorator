shader_type canvas_item;

uniform vec3 channel = vec3(1, 0, 0);
uniform sampler2D gradient;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	col.rgb = texture(gradient, vec2(dot(col.rgb, channel), 0)).rgb;
	COLOR = col;
}
