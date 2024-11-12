precision mediump float;

// janela
uniform float windowWidth;
uniform float windowHeight;
uniform vec3 windowPosition;

// tela
uniform float canvasWidth;
uniform float canvasHeight;
uniform float nCol;
uniform float nRow;

// camera (origem do raio)
uniform vec3 rayOrigin;

// esfera
uniform float sphereRadius;
uniform vec3 sphereCenterPosition;

// cores
uniform vec3 sphereColor;
uniform vec3 backgroundColor;

void main() {
    // X do raio emitido
    float deltaX = windowWidth / nCol;
    float col = floor(gl_FragCoord.x * (nCol / canvasWidth));
    float x = (-windowWidth / 2.0) + (deltaX / 2.0) + col * deltaX;

    // Y do raio emitido
    float deltaY = windowHeight / nRow;
    float lin = floor(gl_FragCoord.y * (nRow / canvasHeight));
    float y = (windowHeight / 2.0) - (deltaY / 2.0) - lin * deltaY;

    // Z do raio emitido
    float z = windowPosition.z;

    // Raio emitido
    vec3 ray = vec3(x, y, z);
    ray = normalize(ray);

    // Raio retornado
    vec3 reflectedRay = rayOrigin - sphereCenterPosition;

    // Coeficientes da equação do 2º grau
    float a = dot(ray, ray);
    float b = 2.0 * dot(reflectedRay, ray);
    float c = dot(reflectedRay, reflectedRay) - pow(sphereRadius, 2.0);

    // Delta da equação do 2º grau
    float discriminant = b * b - 4.0 * a * c;

    // Se delta >= 0, então existem pontos que satisfazem a equação do 2º grau, ou seja, o raio intercepta a esfera.
    if (discriminant >= 0.0) {
        // Interseção
        gl_FragColor = vec4(sphereColor, 1.0);
    } else {
        // Sem interseção
        gl_FragColor = vec4(backgroundColor, 1.0);
    }
}