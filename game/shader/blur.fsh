
varying LOWP vec4 colorVarying;
varying MEDP vec2 uvVarying;
 
uniform sampler2D sampler;
 
uniform LOWP float blurSize;
uniform MEDP float xOverY;
 
void main() {
        MEDP vec4 sum = vec4(0.0);
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y - 4.0*blurSize*xOverY)) * 0.05;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y - 3.0*blurSize*xOverY)) * 0.09;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y - 2.0*blurSize*xOverY)) * 0.12;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y - blurSize*xOverY)) * 0.15;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y)) * 0.16;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y + blurSize*xOverY)) * 0.15;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y + 2.0*blurSize*xOverY)) * 0.12;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y + 3.0*blurSize*xOverY)) * 0.09;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y + 4.0*blurSize*xOverY)) * 0.05;
        sum += texture2D(sampler, vec2(uvVarying.x - 4.0*blurSize, uvVarying.y)) * 0.05;
        sum += texture2D(sampler, vec2(uvVarying.x - 3.0*blurSize, uvVarying.y)) * 0.09;
        sum += texture2D(sampler, vec2(uvVarying.x - 2.0*blurSize, uvVarying.y)) * 0.12;
        sum += texture2D(sampler, vec2(uvVarying.x - blurSize, uvVarying.y)) * 0.15;
        sum += texture2D(sampler, vec2(uvVarying.x, uvVarying.y)) * 0.16;
        sum += texture2D(sampler, vec2(uvVarying.x + blurSize, uvVarying.y)) * 0.15;
        sum += texture2D(sampler, vec2(uvVarying.x + 2.0*blurSize, uvVarying.y)) * 0.12;
        sum += texture2D(sampler, vec2(uvVarying.x + 3.0*blurSize, uvVarying.y)) * 0.09;
        sum += texture2D(sampler, vec2(uvVarying.x + 4.0*blurSize, uvVarying.y)) * 0.05;
        gl_FragColor = sum * colorVarying;
}