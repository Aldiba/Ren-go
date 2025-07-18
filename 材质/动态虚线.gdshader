shader_type canvas_item;
uniform vec4 color : source_color = vec4(1.0);
uniform float inner_stroke_thickness = 1.0; // Inner stroke thickness, adjust according to sprite size
uniform float inner_stroke_opacity = 1.0; // Inner stroke opacity, ranges from 0.0 to 1.0
uniform float inside_opacity = 0.0;
uniform float frequency = 8.0; // Controls the number of dotted lines
uniform float phase_speed = 1.0; // Controls the rotation of the border

uniform vec2 rect_size = vec2(0.3, 0.3); // 矩形大小
uniform vec2 rect_position = vec2(0.5, 0.5); // 矩形位置

void fragment() {
  // Final outputs
  vec4 inner_stroke;
  vec4 circle_outline;

  // INNER STROKE
  float radius = inner_stroke_thickness / float(textureSize(TEXTURE, 0).x);
  // Initialize alpha to maximum
  float minAlpha = 1.0;

  // Sample a grid around the pixel based on the defined radius to find the minimum alpha
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      vec2 offset = vec2(float(x), float(y)) * radius;
      float sampleAlpha = texture(TEXTURE, UV + offset).a;
      minAlpha = min(minAlpha, sampleAlpha);
    }
  }

  // Get the original alpha value at the fragment
  float originalAlpha = texture(TEXTURE, UV).a;
  // Compare and apply the inner stroke color if in the inner stroke region
  if (originalAlpha > minAlpha) {
    float innerStrokeAlpha = originalAlpha * (originalAlpha - minAlpha) * inner_stroke_opacity; // Blend the inner stroke alpha based on the difference in alpha and opacity setting
    inner_stroke = vec4(1.0, 1.0, 1.0, innerStrokeAlpha);
  } else {
    float insideAlpha = originalAlpha * inside_opacity; // Blend the inner stroke alpha based on the difference in alpha and opacity setting
    inner_stroke = vec4(1.0, 1.0, 1.0, insideAlpha);
  }
  // INNER STROKE END

  // CIRCLE OUTLINE
  vec2 pos = UV - vec2(0.5);
  float outer_radius = inner_stroke_thickness / 2.0;
  float inner_radius = outer_radius - inner_stroke_opacity;
  float outer_circle = step(length(pos), outer_radius);
  float inner_circle = step(length(pos), inner_radius);

  float angle = atan(pos.y, pos.x);
  if (angle < 0.0) {
    angle += 2.0 * PI;
  }

  float wave = 0.5 * sin(frequency * angle + TIME * phase_speed) + 0.5;
  float ring = outer_circle - inner_circle;
  ring *= step(0.5, wave);

  circle_outline = vec4(color.rgb, ring * color.a);
  // CIRCLE OUTLINE END

  // 计算矩形区域
  vec2 uv_offset = UV - rect_position;
  float rect_alpha = 1.0 - step(abs(uv_offset.x), rect_size.x/2.0) * step(abs(uv_offset.y), rect_size.y/2.0);
  vec4 m = vec4(-1,-1,-1,1);
  vec4 outline_color = inner_stroke * circle_outline * vec4(1.0, 1.0, 1.0, rect_alpha);
  outline_color.r = outline_color.r*outline_color.a;
  outline_color.g = outline_color.g*outline_color.a;
  outline_color.b = outline_color.b*outline_color.a;

  COLOR.rgb = COLOR.rgb+outline_color.rgb;
}