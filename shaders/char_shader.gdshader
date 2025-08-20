shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque;

uniform sampler2D tex_albedo : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0); // glowing orange
uniform float outline_size : hint_range(0.001, 0.05) = 0.01;
uniform float glow_strength : hint_range(0.0, 5.0) = 1.5;

void fragment() {
    vec4 tex_color = texture(tex_albedo, UV);

    if (tex_color.a > 0.0) {
        // Sprite body
        ALBEDO = tex_color.rgb;
        ALPHA = tex_color.a;
        EMISSION = tex_color.rgb * glow_strength; // make inside glow too
    } else {
        // Check neighbors for outline
        float alpha = 0.0;
        for (float x = -1.0; x <= 1.0; x++) {
            for (float y = -1.0; y <= 1.0; y++) {
                vec2 offset = vec2(x, y) * outline_size;
                alpha = max(alpha, texture(tex_albedo, UV + offset).a);
            }
        }

        if (alpha > 0.0) {
            // Outline
            ALBEDO = outline_color.rgb;
            ALPHA = outline_color.a;
            EMISSION = outline_color.rgb * glow_strength;
        } else {
            discard; // fully transparent
        }
    }
}
