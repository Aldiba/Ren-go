shader_type spatial;
render_mode cull_disabled, unshaded;

uniform sampler2D albedo_texture;
uniform float dissolve_progress : hint_range(0, 1) = 0.0;
uniform vec3 particle_color = vec3(0.4, 0.6, 1.0);

void vertex() {
    // 随机消散方向
    float seed = fract(float(INSTANCE_ID) * 0.317);
    vec3 dir = normalize(vec3(seed, seed*0.7, seed*0.3));

    // 粒子运动
    VERTEX += dir * dissolve_progress * 2.0;

    // 大小衰减
    VERTEX *= 1.0 - dissolve_progress * 0.5;
}

void fragment() {
    // 基础颜色
    vec4 tex = texture(albedo_texture, UV);

    // 消散边缘光
    float edge = smoothstep(0.4, 0.6, dissolve_progress + UV.y * 0.3);

    // 粒子化
    float noise = fract(sin(dot(UV, vec2(12.9898,78.233))) * 43758.5453);
    if(noise > dissolve_progress * 1.2) discard;

    // 颜色混合
    ALBEDO = mix(tex.rgb, particle_color, edge);
    EMISSION = particle_color * edge * 2.0;
    ALPHA = tex.a * (1.0 - dissolve_progress);
}