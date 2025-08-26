shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

uniform bool animated = false;
uniform float dir_speed = 0.5;   // how fast the direction rotates
uniform float speed = 2.0;      // speed of ripple
uniform float wavelength = 2.0; // how stretched the wave is across UV space
uniform float min_alpha = 0.2;
uniform float max_alpha = 1.0;

void fragment() {
    vec4 tex_color = texture(tex_albedo, UV);
	float alpha = 1.0;
	if(animated) {
	    //float diagonal = (UV.x + UV.y) * 0.5;
	    //float wave = sin(TIME * speed - diagonal * wavelength);
	    //alpha = mix(min_alpha, max_alpha, (wave + 1.0) * 0.5);
		float angle = sin(TIME * 0.7) * 1.2
                + sin(TIME * 1.3) * 0.7
                + cos(TIME * 0.5) * 0.5;
	    vec2 dir = vec2(cos(angle), sin(angle));
	    float proj = dot(UV, dir);
	    float wave = sin(TIME * speed - proj * wavelength);
	    alpha = (wave + 1.0) * 0.5;
	}

    ALBEDO = tex_color.rgb * outline_color.rgb;
    ALPHA = tex_color.a * outline_color.a * alpha;
}