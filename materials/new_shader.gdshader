shader_type spatial;

render_mode unshaded, cull_disabled, depth_draw_opaque;

uniform sampler2D tex : source_color, repeat_disable;
uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform int outline_size : hint_range(0, 10) = 3;

void fragment() {
    vec4 tex_col = texture(tex, UV);
    float alpha = tex_col.a;

    // Derivative of UV across screen pixels
    vec2 dx = dFdx(UV);
    vec2 dy = dFdy(UV);

    float max_alpha = alpha;
    for (int x = -outline_size; x <= outline_size; x++) {
        for (int y = -outline_size; y <= outline_size; y++) {
            vec2 offset = dx * float(x) + dy * float(y);
            max_alpha = max(max_alpha, texture(tex, UV + offset).a);
        }
    }

    if (max_alpha > 0.1 && alpha < 0.1) {
        ALBEDO = outline_color.rgb;
        ALPHA  = outline_color.a;
    } else {
        ALBEDO = tex_col.rgb;
        ALPHA  = tex_col.a;
    }
}