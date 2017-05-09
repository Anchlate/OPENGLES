
varying lowp vec2 coord;

uniform sampler2D colorMap;

void main() {

    gl_FragColor = texture2D(colorMap, coord.st);

}