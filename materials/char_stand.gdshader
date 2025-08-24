shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform float emission : hint_range(0.0, 5.0) = 1.0;

void fragment() {
	vec4 tex_color = texture(tex_albedo, UV);
	if(tex_color.a > 0.3) {
		ALBEDO = tex_color.rgb;
		ALPHA = tex_color.a;
		EMISSION = tex_color.rgb * emission;
	} else {
		discard;
	}
}
