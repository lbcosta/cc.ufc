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
uniform vec3 sphereDiffuseReflection;
uniform vec3 sphereSpecularReflection;
uniform float sphereShininess;

// cor
uniform vec3 backgroundColor;

// luz
uniform vec3 lightSourcePosition;
uniform vec3 lightSourceIntensity;

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

    if (discriminant < 0.0) {
        // Não há interseção
        gl_FragColor = vec4(backgroundColor, 1.0);
        return;
    }
    
    // Há interseção:
        // Calcula o ponto de interseção
            float t = (-b - sqrt(discriminant)) / (2.0 * a);
            vec3 intersectionPoint = rayOrigin + t * ray;

        // Calcula vetores necessários:
            // Vetor normal à superfície da esfera no ponto de interseção (n)
            vec3 normal = normalize(intersectionPoint - sphereCenterPosition);

            // Vetor que aponta para a fonte de luz (l)
            vec3 lightDirection = normalize(lightSourcePosition - intersectionPoint);

            // Vetor que aponta para o observador (v)
            vec3 viewDirection = normalize(rayOrigin - intersectionPoint);

            // Vetor que representa a reflexão da luz (r = 2 * (l . n) * n - l)
            vec3 reflectionDirection = reflect(-lightDirection, normal);

        // Calcula componentes da cor:
            // Intensidade da luz difusa (Id = Kd * I * (l . n))
            vec3 diffuseIntensity = lightSourceIntensity * sphereDiffuseReflection * max(dot(lightDirection, normal), 0.0);

            // Intensidade da luz especular (Ie = Ks * I * (v . r)^m)
            vec3 specularIntensity = lightSourceIntensity * sphereSpecularReflection * pow(max(dot(reflectionDirection, viewDirection), 0.0), sphereShininess);

        // Cor final Ieye = Id + Ie
        vec3 finalColor = diffuseIntensity + specularIntensity;

        gl_FragColor = vec4(finalColor, 1.0);
}