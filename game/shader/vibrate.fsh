
varying LOWP vec4 colorVarying;
varying MEDP vec2 uvVarying;
 
uniform sampler2D sampler;
 
uniform LOWP float intensity;
 
void main() {
        MEDP float hazeOffset = fract(sin(dot(uvVarying.xy,vec2(12.9898,78.233))) * 43758.5453) - 0.5;
        MEDP vec4 sum = texture2D(sampler,vec2((uvVarying.x-.5)*(1.0+intensity)+.5+hazeOffset * intensity,uvVarying.y));
        gl_FragColor = sum * colorVarying;
}