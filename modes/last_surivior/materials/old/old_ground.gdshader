shader_type spatial;
render_mode cull_disabled, depth_draw_always, depth_test_disabled;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_size : hint_range(0.0, 10.0) = 3.0;
uniform float emission : hint_range(0.0, 5.0) = 2.5;

const vec2 offsets[8] = vec2[8](vec2(0.0, -1.0), vec2(-1.0, 0.0), vec2(1.0, 0.0), vec2(0.0, 1.0), vec2(-0.85, -0.85), vec2(0.85, -0.85), vec2(-0.85, 0.85), vec2(0.85, 0.85));

void fragment() {
	vec4 tex_color = texture(tex_albedo, UV);
	if(tex_color.a > 0.3) {
		vec2 dx = dFdx(UV);
		vec2 dy = dFdy(UV);
		float alpha = 0.0;
		for(int i=0; i<8; i++) {
			vec2 offset = dx * offsets[i].x + dy * offsets[i].y;
			vec2 pos = UV + offset * outline_size;
			if(pos.x > 0.005 && pos.y > 0.005 && pos.x < 0.995 && pos.y < 0.995) {
				alpha += textureLod(tex_albedo, UV + offset * outline_size, 1.0).a;
				//alpha += texture(tex_albedo, pos).a;
			}
		}
		if(alpha < 7.9) {
			ALBEDO = outline_color.rgb;
			ALPHA = outline_color.a;
			EMISSION = outline_color.rgb * emission;
		} else {
			discard;
		}
	} else {
		discard;
	}
}
