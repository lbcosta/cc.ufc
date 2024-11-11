precision mediump float;

// tela
uniform float canvasWidth; // pixels
uniform float canvasHeight; // pixels
uniform float nCol; // número de colunas
uniform float nLin; // número de linhas

// camera
uniform float wJanela; // metros
uniform float hJanela; // metros
uniform float dJanela; // metros

// esfera
uniform float rEsfera; // metros
uniform vec3 centroEsfera;

// cores
uniform vec3 esfColor;
uniform vec3 bgColor;

// iluminação
uniform vec3 lightIntensity;
uniform vec3 lightPosition;
uniform vec3 diffuseReflection;
uniform vec3 specularReflection;
uniform float materialShininess;

void main() {
    // camera
    vec3 origin = vec3(0.0, 0.0, 0.0);

    // X do raio emitido
    float deltaX = wJanela / nCol;
    float col = floor(gl_FragCoord.x * (nCol / canvasWidth));
    float x = (-wJanela / 2.0) + (deltaX / 2.0) + col * deltaX;

    // Y do raio emitido
    float deltaY = hJanela / nLin;
    float lin = floor(gl_FragCoord.y * (nLin / canvasHeight));
    float y = (hJanela / 2.0) - (deltaY / 2.0) - lin * deltaY;

    // Z do raio emitido
    float z = -dJanela;

    // Raio emitido
    vec3 ray = vec3(x, y, z);
    ray = normalize(ray);

    // Raio retornado
    vec3 reflectedRay = origin - centroEsfera;

    // Coeficientes da equação do 2º grau
    float a = dot(ray, ray);
    float b = 2.0 * dot(reflectedRay, ray);
    float c = dot(reflectedRay, reflectedRay) - rEsfera * rEsfera;

    // Delta da equação do 2º grau
    float delta = b * b - 4.0 * a * c;

    // Se delta >= 0, então existem pontos que satisfazem a equação do 2º grau, ou seja, o raio intercepta a esfera.
    if (delta >= 0.0) {
        // Interseção
        float distance = (-b - sqrt(delta)) / (2.0 * a);
        vec3 intersectionPoint = origin + distance * ray; // p(t) = p0 + t * dr
        vec3 n = normalize(intersectionPoint - centroEsfera);

        // Iluminação difusa
        vec3 l = normalize(lightPosition - intersectionPoint); // l é o vetor unitário que aponta para a fonte de luz
        float diffuseAttenuationFactor = max(dot(l, n), 0.0); // Fator de atenuação da luz. Se for 0, a luz não incide na superfície.
        vec3 diffuseLighting = diffuseReflection * lightIntensity * diffuseAttenuationFactor; // Idif = Kd * I * (l . n)

        // Iluminação especular
        vec3 r = 2.0 * (dot(l, n)) * n - l; // r é o vetor de reflexão da luz
        vec3 v = normalize(-ray); // v é o vetor unitário que aponta para a câmera
        float specularAttenuationFactor = pow(max(dot(r, v), 0.0), materialShininess); // Fator de atenuação da luz especular = (r . v)^α
        vec3 specularLighting = specularReflection * lightIntensity * specularAttenuationFactor; // Ispec = Ks * I * (r . v)^α

        // Cor final
        vec3 seenColor = diffuseLighting + specularLighting; // Ieye = Idif + Ispec
        gl_FragColor = vec4(seenColor, 1.0);
    } else {
        // Sem interseção
        gl_FragColor = vec4(bgColor, 1.0);
    }
}