shader_type spatial;
render_mode cull_disabled, depth_draw_always, depth_test_disabled;

uniform float outline_expand : hint_range(1.0, 1.5) = 1.25;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_size : hint_range(0.0, 10.0) = 3.0;
uniform float outer_glow : hint_range(0.0, 5.0) = 2.5;
uniform vec2 center_point = vec2(0.5, 0.5);

const vec2 offsets[8] = vec2[8](vec2(0.0, -1.0), vec2(-1.0, 0.0), vec2(1.0, 0.0), vec2(0.0, 1.0), vec2(-0.7, -0.7), vec2(0.7, -0.7), vec2(-0.7, 0.7), vec2(0.7, 0.7));

void vertex() {
	VERTEX.xyz *= outline_expand;
	UV.xy = (UV - center_point) * outline_expand + center_point;
}

void fragment() {
	vec4 tex_color = texture(tex_albedo, UV);
	if(tex_color.a > 0.99) {
		float alpha = 0.0;
		for(int i=0; i<4; i++) {
			alpha += texture(tex_albedo, UV + offsets[i] * 0.005).a;
		}
		if(alpha < 3.5) {
			alpha = min(1.0, 1.0-alpha*0.5);
			ALBEDO = outline_color.rgb * alpha;
			ALPHA = outline_color.a * alpha;
			EMISSION = outline_color.rgb * outer_glow;
		} else {
			discard;
		}
	} else {
		vec2 dx = dFdx(UV);
		vec2 dy = dFdy(UV);
		float alpha = 0.0;
		for(int i=0; i<8; i++) {
			vec2 offset = dx * offsets[i].x + dy * offsets[i].y;
			alpha += texture(tex_albedo, UV + offset * outline_size).a;
		}
		if(alpha > 0.01) {
			ALBEDO = outline_color.rgb;
			ALPHA = outline_color.a * min(1.0, alpha * 0.5);
			EMISSION = outline_color.rgb * outer_glow;
		} else {
			discard;
		}
	}
}
