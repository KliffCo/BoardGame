shader_type spatial;
render_mode cull_disabled, depth_test_disabled, depth_draw_never;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform sampler2D tex_noise : source_color, repeat_enable, filter_linear;

uniform vec4 stroke_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float stroke_size : hint_range(0.0, 0.1) = 0.01;
uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
//uniform float inner_radius : hint_range(0.0, 1.0) = 0.3;
uniform float emission : hint_range(0.0, 5.0) = 2.5;
uniform bool fill = false;

uniform float speed : hint_range(0.0, 5.0) = 0.7;
uniform float scale : hint_range(0.0, 1.0) = 0.15;
uniform float density : hint_range(0.0, 10.0) = 6.0;
uniform float add : hint_range(-0.25, 0.25) = -0.1;

const vec2 offsets[8] = vec2[8](vec2(0.0, -1.0), vec2(-1.0, 0.0), vec2(1.0, 0.0), vec2(0.0, 1.0), vec2(-0.85, -0.85), vec2(0.85, -0.85), vec2(-0.85, 0.85), vec2(0.85, 0.85));

float noise_at(vec2 src) {
	vec2 uv = src * scale;
	float t = TIME * speed * scale;
	vec2 uv1 = vec2(uv.x + t * 1.3, uv.y);
	vec2 uv2 = vec2(uv.x - t * 0.77, uv.y - t * 1.12);
	vec2 uv3 = vec2(uv.x, uv.y + t * 0.9);
	float r = texture(tex_noise, uv1).r;
	float g = texture(tex_noise, uv2).g;
	float b = texture(tex_noise, uv3).b;
	return r*g*b*density*density+add;
}

void fragment() {
	vec4 tex_color = texture(tex_albedo, UV);
	if(tex_color.a > 0.9) {
		float alpha = 0.0;
		for(int i=0; i<8; i++) {
			vec2 offset = offsets[i];
			vec2 pos = UV + offset * stroke_size;
			if(pos.x > 0.005 && pos.y > 0.005 && pos.x < 0.995 && pos.y < 0.995) {
				alpha += textureLod(tex_albedo, UV + offset * stroke_size, 1.0).a;
			}
		}
		if(alpha < 7.9) {
			ALBEDO = stroke_color.rgb;
			ALPHA = stroke_color.a * noise_at(UV);
			EMISSION = ALBEDO * emission;
		} else {
			if(fill) {
				ALBEDO = fill_color.rgb;
				ALPHA = fill_color.a * noise_at(UV + vec2(0.5));
				//EMISSION = vec3(a) * emission;
			} else {
				discard;
			}
		}
	} else {
		discard;
	}
}
