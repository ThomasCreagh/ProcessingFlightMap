#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 resolution;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const float scanlineIntensity = 0.1f;
const int scanlineSpacing = 3;
const float bleedIntensity = 0.004f;

void main() {
  	vec2 uv = gl_FragCoord.xy / resolution.xy;

    int index = int(gl_FragCoord.y) / scanlineSpacing;
    float scanline = mod(float(index), 2.0f) * scanlineIntensity;
    vec3 texColor = texture2D(texture, uv).rgb;
    texColor.rgb -= scanline;

    vec3 bleedColor = texture2D(texture, uv + vec2(bleedIntensity, 0)).rgb +
    texture2D(texture, uv + vec2(0, bleedIntensity)).rgb +
    texture2D(texture, uv + vec2(-bleedIntensity, 0)).rgb + 
    texture2D(texture, uv + vec2(0, -bleedIntensity)).rgb;
    bleedColor /= 4.0f;
    texColor = mix(texColor, bleedColor, 0.5f);

    gl_FragColor = vec4(texColor, 1);
} 

// Shaders written by Finn Wright