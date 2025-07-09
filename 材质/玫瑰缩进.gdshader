shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,filter_linear_mipmap;

// 随机函数
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 噪声函数
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// 分形布朗运动
const int OCTAVES = 4;
float fbm(vec2 st) {
    st /= 2.0;
    st += TIME/8.0; // 修改点[1]：iTime→TIME
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value/2000.0;
}

// 旋转矩阵
mat2 rot(float a) {
    return mat2(vec2(cos(a), -sin(a)), vec2(sin(a), cos(a)));
}

// 阴影圆形函数
float shadowCircle(vec2 p, float r, float i) {
    p += vec2(0.02, 0.02) * rot(TIME/100.0); // 修改点[1]
    float a = atan(p.y, p.x);
    float shape = fbm(p);
    float ss = 0.07;
    float k = 1.0 - smoothstep(r-ss, r+ss, max(abs(p.x),abs(p.y))-0.2+shape);
    return pow(k,1.1);
}

float rimCircle(vec2 p, float r, float i) {
    float a = atan(p.y,p.x);
    float shape = fbm(p);
    float ss = 0.004;
    float rim = 0.004;
    float k = smoothstep(r-ss, r+ss, max(abs(p.x),abs(p.y))-0.2+shape);
    float k2 = smoothstep(r-ss+rim, r+ss+rim, max(abs(p.x),abs(p.y))-0.2+shape);
    return clamp((k-k2)/2.0, 0.0, 1.0);
}

float Circle(vec2 p, float r, float i) {
    float ss = 0.009;
    float shape = fbm(p);
    float k = smoothstep(r-ss, r+ss, max(abs(p.x),abs(p.y))-0.2+shape);
    return k + rimCircle(p, r-0.001, i);
}

void fragment() {
    // 替换输入参数
    vec2 uv = FRAGCOORD.xy / (1.0/SCREEN_PIXEL_SIZE).xy;
    uv = uv * 2.0 - 1.0;
    uv.x *= (1.0/SCREEN_PIXEL_SIZE).x/(1.0/SCREEN_PIXEL_SIZE).y;
    uv /= 1.5;

    // 替换纹理采样方式 hint_screen_texture
    float t1 = textureLod(SCREEN_TEXTURE, uv, 0.0).r;
    float t2 = textureLod(SCREEN_TEXTURE, uv*0.5, 0.0).r;

    vec3 col = vec3(0.9);
    vec3 col2 = vec3(0.0);
    float num = 20.0;
    float minWidth = -0.2;

    for(float i = 0.0; i < num; i++){
        //uv /= 0.9 + mod(fract(i + TIME/20.0), 0.4);
		uv /= 0.9 + mod(TIME/10.0, 0.4);
        //uv *= rot(i + TIME/30.0 * random(vec2(i*8.0+1.0, i+1.0)) * 2.0);
		uv *= rot(TIME * 0.5 + random(vec2(i*8.0+1.0, i+1.0)) * 2.0);

        // 更新颜色混合逻辑
        //col *= shadowCircle(uv, minWidth+i/num, i);
        col2 = vec3(pow(i/num,4.0), pow(i/num,2.0), pow(i/num,1.5)) + 0.65;

        //col = mix(col, col2 - t1*step(1.0,mod(i,2.0)) - t2*1.2*(1.0-step(1.0,mod(i,2.0))),
                 //Circle(uv, minWidth+i/num, i));
        col = mix(col, col2, rimCircle(uv, minWidth+i/num, i)*i/num);
    }

    //col = sin(col + 0.05);
	col = vec3(1,1,1) - col;
	col = 1.1 *col;
	//col *= 1.0 + TIME * 0.01; // 随时间缓慢提亮
	col = pow(col * 2.0, vec3(1.2));       // 增强亮部[1][9]
	//col = (col - 0.3) / 0.4;               // 拉伸中间调[7]
	//col = smoothstep(0.0, 1.0, col * 1.1); // S曲线压缩[7]
    COLOR = vec4(pow(col, vec3(1.0)), 1.0);
}