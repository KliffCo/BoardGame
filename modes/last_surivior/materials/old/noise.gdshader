shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D tex_noise : source_color, repeat_enable, filter_linear;
uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float scale : hint_range(0.0, 1.0) = 0.1;
uniform float factor : hint_range(0.0, 10.0) = 1.0;
uniform float add : hint_range(-0.25, 0.25) = 0.1;
uniform vec4 color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
	float t = TIME * speed * scale;
	vec2 uv = UV * scale;
	vec2 uv1 = vec2(uv.x + t * 1.3, uv.y);
	vec2 uv2 = vec2(uv.x - t * 0.77, uv.y - t * 1.12);
	vec2 uv3 = vec2(uv.x, uv.y + t * 0.9);
	float r = texture(tex_noise, uv1).r;
	float g = texture(tex_noise, uv2).g;
	float b = texture(tex_noise, uv3).b;
	ALBEDO = vec3(1.0);
	ALPHA = r*g*b*factor*factor+add;
}
