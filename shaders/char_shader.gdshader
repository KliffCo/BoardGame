shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform float outline_expand : hint_range(1.0, 1.5) = 1.2;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float outline_size : hint_range(0.001, 0.05) = 0.01;
uniform float glow_strength : hint_range(0.0, 5.0) = 1.5;
uniform float inner_glow : hint_range(0.0, 5.0) = 1.0;

//const vec2 offsets[12] = vec2[12](vec2(0.0, -1.7), vec2(-1.0, -1.0), vec2(0.0, -1.0), vec2(1.0, -1.0), vec2(-1.7, 0.0), vec2(-1.0, 0.0), vec2(1.0, 0.0), vec2(1.7, 0.0), vec2(-1.0, 1.0), vec2(0.0, 1.0), vec2(1.0, 1.0), vec2(0.0, 1.7));
const vec2 offsets[8] = vec2[8](vec2(-0.7, -0.7), vec2(0.0, -1.0), vec2(0.7, -0.7), vec2(-1.0, 0.0), vec2(1.0, 0.0), vec2(-0.7, 0.7), vec2(0.0, 1.0), vec2(0.7, 0.7));

void vertex() {
	VERTEX.xz *= outline_expand;
	UV.xy = (UV - vec2(0.5)) * outline_expand + vec2(0.5);
}

void fragment() {
	vec4 tex_color = texture(tex_albedo, UV);
	if(tex_color.a > 0.99) {
		ALBEDO = tex_color.rgb;
		ALPHA = 1.0;
		EMISSION = tex_color.rgb * inner_glow;
	} else {
		float alpha = 0.0;
		for(int i=0; i<8; i++) {
			alpha += texture(tex_albedo, UV + offsets[i] * outline_size).a;
		}
		//for(float x = -1.0; x <= 1.0; x++) {
			//for(float y = -1.0; y <= 1.0; y++) {
				//if(x != 0.0 || y != 0.0) {
					//vec2 offset = vec2(x, y) * outline_size;
					////alpha = max(alpha, texture(tex_albedo, UV + offset).a);
					//alpha += texture(tex_albedo, UV + offset).a;
				//}
			//}
		//}
		if(alpha > 0.01) {
			ALBEDO = outline_color.rgb;
			ALPHA = outline_color.a * min(1.0, alpha * 0.5);
			EMISSION = outline_color.rgb * glow_strength;
		} else {
			discard;
		}
	}
}
