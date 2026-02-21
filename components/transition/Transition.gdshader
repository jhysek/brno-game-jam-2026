shader_type canvas_item;
  render_mode unshaded;

  // Transition progress: 0.0 = fully transparent, 1.0 = fully black
  // Black grows inward from screen edges toward center
  uniform float position: hint_range(0.0, 1.0) = 0.0;
  // Size of the pixel blocks used for dithering
  uniform float pixel_size: hint_range(1.0, 100.0, 1.0) = 8.0;
  // Viewport resolution
  uniform vec2 resolution = vec2(400.0, 400.0);
  // Offset between the two dither samples (odd/even gives different looks)
  uniform vec2 dither_offset = vec2(2.0, 0.0);
  // Size of the dither matrix to use (2x2, 4x4, or 8x8)
  uniform int bayer_size: hint_enum("2x2", "4x4", "8x8") = 2;
  // Whether to interpolate and blend dither values
  uniform bool interpolate = true;
  // Controls the sharpness of the dithered gradient at the transition edge
  uniform float falloff: hint_range(0.1, 10.0) = 2.5;
  // Width of the dithered transition band (in normalized distance units)
  uniform float edge_width: hint_range(0.01, 1.0) = 0.2;
  // Fill color
  uniform vec4 color: source_color = vec4(0.0, 0.0, 0.0, 1.0);

  const int bayer2[4] = {
      0, 2,
      3, 1
  };

  const int bayer4[16] = {
      0, 8, 2, 10,
      12, 4, 14, 6,
      3, 11, 1, 9,
      15, 7, 13, 5
  };

  const int bayer8[64] = {
      0, 32,  8, 40,  2, 34, 10, 42,
      48, 16, 56, 24, 50, 18, 58, 26,
      12, 44,  4, 36, 14, 46,  6, 38,
      60, 28, 52, 20, 62, 30, 54, 22,
      3, 35, 11, 43,  1, 33,  9, 41,
      51, 19, 59, 27, 49, 17, 57, 25,
      15, 47,  7, 39, 13, 45,  5, 37,
      63, 31, 55, 23, 61, 29, 53, 21
  };

  float get_bayer2(vec2 coord) {
      int x = int(mod(coord.x, 2.0));
      int y = int(mod(coord.y, 2.0));
      return (float(bayer2[y * 2 + x]) + 0.5) / 4.0;
  }

  float get_bayer4(vec2 coord) {
      int x = int(mod(coord.x, 4.0));
      int y = int(mod(coord.y, 4.0));
      return (float(bayer4[y * 4 + x]) + 0.5) / 16.0;
  }

  float get_bayer8(vec2 coord) {
      int x = int(mod(coord.x, 8.0));
      int y = int(mod(coord.y, 8.0));
      return (float(bayer8[y * 8 + x]) + 0.5) / 64.0;
  }

  float get_bayer(vec2 coord) {
      if (bayer_size == 0) return get_bayer2(coord);
      else if (bayer_size == 1) return get_bayer4(coord);
      else return get_bayer8(coord);
  }

  float get_dither(vec2 uv, vec2 step_size) {
      vec2 bayer_coord = floor(uv / step_size + 1.0e-5);
      vec2 grid_uv = bayer_coord * step_size + step_size * 0.5;

      // Aspect-ratio-corrected distance from screen center so the sweep looks circular
      float aspect = resolution.x / resolution.y;
      vec2 to_center = grid_uv - vec2(0.5, 0.5);
      to_center.x *= aspect;
      float dist = length(to_center);

      // Maximum possible distance (center to farthest corner, aspect-corrected)
      float max_dist = length(vec2(0.5 * aspect, 0.5));

      // Normalized distance: 0.0 at screen center, 1.0 at the farthest corner
      float norm_dist = clamp(dist / max_dist, 0.0, 1.0);

      // The sweep front travels from outside the screen inward as position goes 0 -> 1.
      // At position=0: front sits beyond all corners -> screen fully transparent.
      // At position=1: front sits below center     -> screen fully black.
      float front = mix(1.0 + edge_width, -edge_width, position);

      // Coverage: 0 = transparent, 1 = black; equals 0.5 exactly at the front.
      float coverage = clamp((norm_dist - front) / edge_width + 0.5, 0.0, 1.0);
      coverage = pow(coverage, falloff);

      float threshold = get_bayer(bayer_coord);
      return step(threshold, coverage);
  }

  float get_mask(vec2 uv, vec2 step_size, vec2 offset) {
      float d1 = get_dither(uv, step_size);
      float d2 = get_dither(uv - offset, step_size);
      return max(d1, d2);
  }

  void fragment() {
      vec2 uv_step = pixel_size / resolution;
      vec2 raw_offset_uv = round(dither_offset) * uv_step;
      vec2 effective_offset = interpolate ? raw_offset_uv * 0.5 : raw_offset_uv;
      vec2 centered_uv = UV + effective_offset * 0.5;

      float dither;
      if (interpolate) {
          vec2 sub_step = uv_step * 0.5;
          vec2 quantized_uv = floor(centered_uv / uv_step) * uv_step;

          vec2 q1 = vec2(uv_step.x * 0.25, uv_step.y * 0.25);
          vec2 q3 = vec2(uv_step.x * 0.75, uv_step.y * 0.75);

          float v1 = get_mask(quantized_uv + q1, sub_step, effective_offset);
          float v2 = get_mask(quantized_uv + vec2(q3.x, q1.y), sub_step, effective_offset);
          float v3 = get_mask(quantized_uv + vec2(q1.x, q3.y), sub_step, effective_offset);
          float v4 = get_mask(quantized_uv + q3, sub_step, effective_offset);

          dither = (v1 + v2 + v3 + v4) * 0.25;
      } else {
          vec2 quantized_uv = floor(centered_uv / uv_step) * uv_step;
          dither = get_mask(quantized_uv, uv_step, effective_offset);
      }

      COLOR = vec4(color.rgb, dither * color.a);
  }