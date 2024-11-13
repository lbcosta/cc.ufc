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
uniform vec3 sphereAmbientReflection;
uniform float sphereShininess;

// cor
uniform vec3 backgroundColor;

// fonte de luz
uniform vec3 lightSourcePosition;
uniform vec3 lightSourceIntensity;
uniform vec3 ambientLightIntensity;

// chão
uniform vec3 floorPosition;
uniform vec3 floorNormal;
uniform vec3 floorDiffuseReflection;
uniform vec3 floorSpecularReflection;
uniform vec3 floorAmbientReflection;
uniform float floorShininess;

// plano de fundo
uniform vec3 backPlanePosition;
uniform vec3 backPlaneNormal;
uniform vec3 backPlaneDiffuseReflection;
uniform vec3 backPlaneSpecularReflection;
uniform vec3 backPlaneAmbientReflection;
uniform float backPlaneShininess;

float getSphereIntersectionMoment(vec3 origin, vec3 ray, vec3 center, float radius) {
    vec3 oc = origin - center;
    
    float a = dot(ray, ray);
    float b = 2.0 * dot(oc, ray);
    float c = dot(oc, oc) - pow(radius, 2.0);

    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        return 0.0;
    }

    float t = (-b - sqrt(discriminant)) / (2.0 * a);
    return t;
}

vec3 getSphereIntersection(vec3 origin, vec3 ray, float t) {
    if (t == 0.0) {
        return vec3(0.0);
    }

    return rayOrigin + t * ray;
}

float getPlaneIntersectionMoment(vec3 origin, vec3 ray, vec3 planePosition, vec3 planeNormal) {
    float rayNormalProjection = dot(ray, planeNormal);
    if (rayNormalProjection <= 0.0) {
            // O raio é paralelo ao plano
            return 0.0;
    }

    vec3 rf = planePosition - origin; // Vetor da origem do raio até o ponto do plano
    float t = dot(rf, planeNormal) / rayNormalProjection;

    return t;
}

vec3 getPlaneIntersection(vec3 origin, vec3 ray, float t) {
    if (t <= 0.0) { 
        // O plano está atrás da origem do raio
        return vec3(0.0);
    }

    return origin + t * ray;
}

vec4 getColor(vec3 origin, vec3 intersectionPoint, vec3 normal, vec3 diffuseReflection, vec3 specularReflection, vec3 ambientReflection, float shininess) {
    vec3 lightDirection = normalize(lightSourcePosition - intersectionPoint);
    vec3 viewDirection = normalize(origin - intersectionPoint);
    vec3 reflectionDirection = reflect(-lightDirection, normal);

    vec3 ambientIntensity = ambientLightIntensity * ambientReflection;
    vec3 diffuseIntensity = lightSourceIntensity * diffuseReflection * max(dot(lightDirection, normal), 0.0);
    vec3 specularIntensity = lightSourceIntensity * specularReflection * pow(max(dot(reflectionDirection, viewDirection), 0.0), shininess);

    vec3 color = ambientIntensity + diffuseIntensity + specularIntensity;
    
    return vec4(color, 1.0);
}

void main() {
    // Calcula a direção do raio emitido:
    // X do raio emitido
    float deltaX = windowWidth / nCol;
    float col = floor(gl_FragCoord.x * (nCol / canvasWidth));
    float x = (-windowWidth / 2.0) + (deltaX / 2.0) + col * deltaX;

    // Y do raio emitido
    float deltaY = windowHeight / nRow;
    float lin = floor(gl_FragCoord.y * (nRow / canvasHeight));
    float y = (-windowHeight / 2.0) + (deltaY / 2.0) + lin * deltaY; // invertido???

    // Z do raio emitido
    float z = windowPosition.z;

    // Raio emitido
    vec3 ray = vec3(x, y, z);
    ray = normalize(ray);

    // Calcula a interseção com a esfera:
    float tSphere = getSphereIntersectionMoment(rayOrigin, ray, sphereCenterPosition, sphereRadius);
    vec3 sphereIntersectionPoint = getSphereIntersection(rayOrigin, ray, tSphere);

    // Calcula a interseção com o chão:
    float tFloor = getPlaneIntersectionMoment(rayOrigin, ray, floorPosition, floorNormal);
    vec3 floorIntersectionPoint = getPlaneIntersection(rayOrigin, ray, tFloor);

    // Calcula a interseção com o plano de fundo:
    float tBackPlane = getPlaneIntersectionMoment(rayOrigin, ray, backPlanePosition, backPlaneNormal);
    vec3 backPlaneIntersectionPoint = getPlaneIntersection(rayOrigin, ray, tBackPlane);

    bool isRayIntersectingSphere = sphereIntersectionPoint != vec3(0.0);
    bool isRayIntersectingFloor = floorIntersectionPoint != vec3(0.0);
    bool isRayIntersectingBackPlane = backPlaneIntersectionPoint != vec3(0.0);

    if (isRayIntersectingSphere) {
        gl_FragColor = getColor(rayOrigin, sphereIntersectionPoint, normalize(sphereIntersectionPoint - sphereCenterPosition), sphereDiffuseReflection, sphereSpecularReflection, sphereAmbientReflection, sphereShininess);
        return;
    } 

    gl_FragColor = vec4(backgroundColor, 1.0);
}