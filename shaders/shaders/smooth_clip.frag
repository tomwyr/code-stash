#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;

  float transp;
  transp = uv.x - uTime;
  transp = mod(transp, 1);
  transp = abs(transp - 0.5) * 2;
 
  transp = smoothstep(0.8, 1, transp) * transp;
  transp = min(transp * 2, 1);
  
  transp = 1 - transp;
  
  fragColor = vec4(vec3(0), transp);
}
