shader_type spatial;
render_mode cull_disabled, depth_test_disabled, depth_draw_never;

uniform sampler2D tex_noise : source_color, repeat_enable, filter_linear;
uniform vec4 stroke_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float emission : hint_range(0.0, 5.0) = 2.5;
uniform bool noise = false;
uniform bool fill = false;

uniform float inner_radius : hint_range(0.0, 1.0) = 0.3;
uniform float outer_radius : hint_range(0.0, 1.0) = 0.32;
uniform float speed : hint_range(0.0, 5.0) = 0.35;
uniform float scale : hint_range(0.0, 1.0) = 0.15;
uniform float density : hint_range(0.0, 10.0) = 7.0;
uniform float add : hint_range(-0.25, 0.25) = -0.1;

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
	float inner_sq = inner_radius*inner_radius;
	float outer_sq = outer_radius*outer_radius;
	float radius_sq = (UV.x-0.5)*(UV.x-0.5)+(UV.y-0.5)*(UV.y-0.5);
	if(radius_sq < outer_sq) {
		if(radius_sq > inner_sq) {
			ALBEDO = stroke_color.rgb;
			if(noise) {
				ALPHA = stroke_color.a * noise_at(UV);
			} else {
				ALPHA = stroke_color.a;
			}
			EMISSION = ALBEDO * emission;
		} else if(fill) {
			ALBEDO = fill_color.rgb;
			ALPHA = (1.0-radius_sq) * noise_at(UV + vec2(0.5)) * fill_color.a;
			EMISSION = ALBEDO * ALPHA * emission;
		} else {
			discard;
		}
	} else {
		discard;
	}
}
