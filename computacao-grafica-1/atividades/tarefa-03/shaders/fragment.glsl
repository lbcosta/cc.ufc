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

// iluminação
uniform vec3 lightSourceIntensity;
uniform vec3 lightSourcePosition;
uniform vec3 ambientLightIntensity;
uniform vec3 sphereAmbientReflection;
uniform vec3 sphereDiffuseReflection;
uniform vec3 sphereSpecularReflection;
uniform float sphereShininess;

// // chão
uniform vec3 floorPosition;
uniform vec3 floorNormal;
uniform vec3 floorAmbientReflection;
uniform vec3 floorDiffuseReflection;
uniform vec3 floorSpecularReflection;
uniform float floorShininess;

// plano de fundo
uniform vec3 backgroundPosition;
uniform vec3 backgroundNormal;
uniform vec3 backgroundAmbientReflection;
uniform vec3 backgroundDiffuseReflection;
uniform vec3 backgroundSpecularReflection;
uniform float backgroundShininess;

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
        
        // Iluminação ambiente da esfera
        vec3 ambientLighting = sphereAmbientReflection * ambientLightIntensity; // Iamb = Ka * Ia

        // Iluminação difusa da esfera
        vec3 l = normalize(lightSourcePosition - intersectionPoint); // l é o vetor unitário que aponta para a fonte de luz
        float diffuseAttenuationFactor = max(dot(l, n), 0.0); // Fator de atenuação da luz. Se for 0, a luz não incide na superfície.
        vec3 diffuseLighting = sphereDiffuseReflection * lightSourceIntensity * diffuseAttenuationFactor; // Idif = Kd * I * (l . n)

        // Iluminação especular da esfera
        vec3 r = 2.0 * (dot(l, n)) * n - l; // r é o vetor de reflexão da luz
        vec3 v = normalize(-ray); // v é o vetor unitário que aponta para a câmera
        float specularAttenuationFactor = pow(max(dot(r, v), 0.0), sphereShininess); // Fator de atenuação da luz especular = (r . v)^α
        vec3 specularLighting = sphereSpecularReflection * lightSourceIntensity * specularAttenuationFactor; // Ispec = Ks * I * (r . v)^α

        // Cor final
        vec3 seenColor = ambientLighting + diffuseLighting + specularLighting; // Ieye = Iamb + Idif + Ispec
        gl_FragColor = vec4(seenColor, 1.0);

        return;
    } 

    // Se não houver interseção com a esfera, então verificamos se o raio intercepta o chão.
    // Somente se o raio interceptar o chão, então a cor do chão será exibida.
    if (dot(floorNormal, ray) != 0.0) {
        // Interseção
        float t = dot(floorNormal, floorPosition - origin) / dot(floorNormal, ray);
        vec3 intersectionPoint = origin + t * ray; // p(t) = p0 + t * dr

        // Iluminação ambiente do chão
        vec3 ambientLighting = floorAmbientReflection * ambientLightIntensity; // Iamb = Ka * Ia

        // Iluminação difusa do chão
        vec3 l = normalize(lightSourcePosition - intersectionPoint); // l é o vetor unitário que aponta para a fonte de luz
        float diffuseAttenuationFactor = max(dot(l, floorNormal), 0.0); // Fator de atenuação da luz. Se for 0, a luz não incide na superfície.
        vec3 diffuseLighting = floorDiffuseReflection * lightSourceIntensity * diffuseAttenuationFactor; // Idif = Kd * I * (l . n)

        // Iluminação especular do chão
        vec3 r = 2.0 * (dot(l, floorNormal)) * floorNormal - l; // r é o vetor de reflexão da luz
        vec3 v = normalize(-ray); // v é o vetor unitário que aponta para a câmera
        float specularAttenuationFactor = pow(max(dot(r, v), 0.0), floorShininess); // Fator de atenuação da luz especular = (r . v)^α
        vec3 specularLighting = floorSpecularReflection * lightSourceIntensity * specularAttenuationFactor; // Ispec = Ks * I * (r . v)^α

        // Cor final
        vec3 seenColor = ambientLighting + diffuseLighting + specularLighting; // Ieye = Iamb + Idif + Ispec
        gl_FragColor = vec4(seenColor, 1.0);

        return;
    }

    // Se não houver interseção com a esfera e nem com o chão, então a cor de fundo será exibida.
    // Ou seja, o raio intercepta o plano de fundo.
    // Interseção
    float t = dot(backgroundNormal, backgroundPosition - origin) / dot(backgroundNormal, ray);
    vec3 intersectionPoint = origin + t * ray; // p(t) = p0 + t * dr

    // Iluminação ambiente do plano de fundo
    vec3 ambientLighting = backgroundAmbientReflection * ambientLightIntensity; // Iamb = Ka * Ia

    // Iluminação difusa do plano de fundo
    vec3 l = normalize(lightSourcePosition - intersectionPoint); // l é o vetor unitário que aponta para a fonte de luz
    float diffuseAttenuationFactor = max(dot(l, backgroundNormal), 0.0); // Fator de atenuação da luz. Se for 0, a luz não incide na superfície.
    vec3 diffuseLighting = backgroundDiffuseReflection * lightSourceIntensity * diffuseAttenuationFactor; // Idif = Kd * I * (l . n)

    // Iluminação especular do plano de fundo
    vec3 r = 2.0 * (dot(l, backgroundNormal)) * backgroundNormal - l; // r é o vetor de reflexão da luz
    vec3 v = normalize(-ray); // v é o vetor unitário que aponta para a câmera
    float specularAttenuationFactor = pow(max(dot(r, v), 0.0), backgroundShininess); // Fator de atenuação da luz especular = (r . v)^α
    vec3 specularLighting = backgroundSpecularReflection * lightSourceIntensity * specularAttenuationFactor; // Ispec = Ks * I * (r . v)^α

    // Cor final
    vec3 seenColor = ambientLighting + diffuseLighting + specularLighting; // Ieye = Iamb + Idif + Ispec
    gl_FragColor = vec4(seenColor, 1.0);
}