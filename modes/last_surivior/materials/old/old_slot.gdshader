shader_type spatial;
render_mode cull_back, depth_draw_always;

/* ---- Controls ---- */
uniform float scale = 1.0;       // frequency scaler
uniform float amplitude = 1.0;   // overall contrast
uniform float speed = 1.0;       // animation speed
uniform vec2 offset = vec2(0.0); // static offset

/* ---- Helpers ---- */
float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 fade2(vec2 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float grad(vec2 cell, vec2 rel) {
    float h = hash21(cell) * 6.2831853; // angle in radians
    vec2 g = vec2(cos(h), sin(h));
    return dot(g, rel);
}

/* Classic 2D Perlin, returns [-1,1] */
float perlin2(vec2 p) {
    vec2 pf = floor(p);
    vec2 pr = p - pf;
    vec2 w  = fade2(pr);

    float n00 = grad(pf + vec2(0.0, 0.0), pr - vec2(0.0, 0.0));
    float n10 = grad(pf + vec2(1.0, 0.0), pr - vec2(1.0, 0.0));
    float n01 = grad(pf + vec2(0.0, 1.0), pr - vec2(0.0, 1.0));
    float n11 = grad(pf + vec2(1.0, 1.0), pr - vec2(1.0, 1.0));

    float nx0 = mix(n00, n10, w.x);
    float nx1 = mix(n01, n11, w.x);

    return mix(nx0, nx1, w.y);
}

void fragment() {
    // Animate the offset along a looping "random-ish" path
    vec2 animated_offset = offset;
    animated_offset.x += sin(TIME * speed * 0.7) * 10.0;
    animated_offset.y += cos(TIME * speed * 1.3) * 10.0;

    // Sample domain
    vec2 domain = UV * max(scale, 1e-5) + animated_offset;

    float n = perlin2(domain);
    float N = clamp(0.5 * n + 0.5, 0.0, 1.0); // map [-1,1] → [0,1]

    ALPHA = N * amplitude;
}
