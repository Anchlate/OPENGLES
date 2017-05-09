attribute vec4 position;
attribute vec2 texCoord;

varying lowp vec2 coord;

uniform mat4 modelViewProjectionMatrix;

void main () {

    coord = texCoord;
    gl_Position = modelViewProjectionMatrix * position;

}
