shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform float outline_expand : hint_range(1.0, 1.5) = 1.2;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float outline_size : hint_range(0.001, 0.05) = 0.01;
uniform float outer_glow : hint_range(0.0, 5.0) = 1.5;
uniform float inner_glow : hint_range(0.0, 5.0) = 1.0;

const vec2 offsets[8] = vec2[8](vec2(0.0, -1.0), vec2(-1.0, 0.0), vec2(1.0, 0.0), vec2(0.0, 1.0), vec2(-0.7, -0.7), vec2(0.7, -0.7), vec2(-0.7, 0.7), vec2(0.7, 0.7));

void vertex() {
	VERTEX.xz *= outline_expand;
	UV.xy = (UV - vec2(0.5)) * outline_expand + vec2(0.5);
}

void fragment() {
	vec4 tex_color = texture(tex_albedo, UV);
	float alpha = 0.0;
	if(tex_color.a > 0.99) {
		for(int i=0; i<4; i++) {
			alpha += texture(tex_albedo, UV + offsets[i] * 0.005).a;
		}
		if(alpha > 3.85) {
			ALBEDO = tex_color.rgb;
			ALPHA = 1.0;
			EMISSION = tex_color.rgb * inner_glow;
		} else {
			alpha *= 0.05;
			float inva = 1.0 - alpha;
			ALBEDO = outline_color.rgb * inva + tex_color.rgb * alpha;
			ALPHA = outline_color.a * inva + alpha;
			EMISSION = outline_color.rgb * outer_glow;
			//ALBEDO = outline_color.rgb;
			//ALPHA = outline_color.a * min(1.0, alpha * 0.5);
			//EMISSION = outline_color.rgb * outer_glow;
		}
	} else {
		for(int i=0; i<8; i++) {
			alpha += texture(tex_albedo, UV + offsets[i] * outline_size).a;
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
