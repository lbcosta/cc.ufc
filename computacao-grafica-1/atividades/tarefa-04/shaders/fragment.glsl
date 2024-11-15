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

struct Object {
    int id;
    vec3 position;
    vec3 normal;
    float radius;
    vec3 diffuseReflection;
    vec3 specularReflection;
    vec3 ambientReflection;
    float shininess;
};

// constantes com os ids:
const int SPHERE = 0;
const int FLOOR = 1;
const int BACK_PLANE = 2;

float get_discriminant_from_ray_intersection_with_sphere(vec3 origin, vec3 ray, Object sphere) {
    vec3 oc = origin - sphere.position;
    
    float a = dot(ray, ray);
    float b = 2.0 * dot(oc, ray);
    float c = dot(oc, oc) - pow(sphere.radius, 2.0);

    return b * b - 4.0 * a * c;
}

float get_T_from_ray_intersection_with_sphere(vec3 origin, vec3 ray, Object sphere) {
    vec3 oc = origin - sphere.position;
    
    float a = dot(ray, ray);
    float b = 2.0 * dot(oc, ray);
    float c = dot(oc, oc) - pow(sphere.radius, 2.0);

    float discriminant = b * b - 4.0 * a * c;

    return (-b - sqrt(discriminant)) / (2.0 * a);
}

vec3 get_ray_intersection_point(vec3 origin, vec3 ray, float t) {
    return origin + t * ray;
}

float get_T_from_ray_intersection_with_plane(vec3 origin, vec3 ray, Object plane) {
    float rayNormalProjection = dot(ray, plane.normal);
    // por que não funciona?
    // if (rayNormalProjection <= 0.0) {
    //         // O raio é paralelo ao plano
    //         return 0.0;
    // }

    vec3 rf = plane.position - origin; // Vetor da origem do raio até o ponto do plano
    float t = dot(rf, plane.normal) / rayNormalProjection;

    return t;
}

vec4 getColor(vec3 origin, vec3 intersectionPoint, vec3 normal, Object object) {
    vec3 lightDirection = normalize(lightSourcePosition - intersectionPoint);
    vec3 viewDirection = normalize(origin - intersectionPoint);
    vec3 reflectionDirection = reflect(-lightDirection, normal);

    vec3 ambientIntensity = ambientLightIntensity * object.ambientReflection;
    vec3 diffuseIntensity = lightSourceIntensity * object.diffuseReflection * max(dot(lightDirection, normal), 0.0);
    vec3 specularIntensity = lightSourceIntensity * object.specularReflection * pow(max(dot(reflectionDirection, viewDirection), 0.0), object.shininess);

    vec3 color = ambientIntensity + diffuseIntensity + specularIntensity;
    
    return vec4(color, 1.0);
}

void main() {
    float deltaX = windowWidth / nCol;
    float col = floor(gl_FragCoord.x * (nCol / canvasWidth));
    float x = (-windowWidth / 2.0) + (deltaX / 2.0) + col * deltaX;

    float deltaY = windowHeight / nRow;
    float lin = floor(gl_FragCoord.y * (nRow / canvasHeight));
    float y = (-windowHeight / 2.0) + (deltaY / 2.0) + lin * deltaY; // invertido

    float z = windowPosition.z;

    vec3 ray = vec3(x, y, z);
    ray = normalize(ray);

    Object sphere = Object(SPHERE, sphereCenterPosition, vec3(0.0), sphereRadius, sphereDiffuseReflection, sphereSpecularReflection, sphereAmbientReflection, sphereShininess);
    Object floor = Object(FLOOR, floorPosition, floorNormal, 0.0, floorDiffuseReflection, floorSpecularReflection, floorAmbientReflection, floorShininess);
    Object backPlane = Object(BACK_PLANE, backPlanePosition, backPlaneNormal, 0.0, backPlaneDiffuseReflection, backPlaneSpecularReflection, backPlaneAmbientReflection, backPlaneShininess);

    Object objects[3];
    objects[0] = sphere;
    objects[1] = floor;
    objects[2] = backPlane;

    float t = 0.0;
    vec3 intersectionPoint = vec3(0.0);
    vec3 normal = vec3(0.0);
    Object object = Object(-1, vec3(0.0), vec3(0.0), 0.0, vec3(0.0), vec3(0.0), vec3(0.0), 0.0);

    for (int i = 0; i < 3; i++) {
        Object currentObject = objects[i];
        float currentT = 0.0;

        if (currentObject.id == SPHERE) {
            currentT = get_T_from_ray_intersection_with_sphere(rayOrigin, ray, currentObject);
        } else {
            currentT = get_T_from_ray_intersection_with_plane(rayOrigin, ray, currentObject);
        }

        if (currentT > 0.0 && (t == 0.0 || currentT < t)) {
            t = currentT;
            object = currentObject;
        }
    }

    
    intersectionPoint = get_ray_intersection_point(rayOrigin, ray, t);

    if (object.id == SPHERE) {
        normal = normalize(intersectionPoint - object.position);
    } else if (object.id == FLOOR || object.id == BACK_PLANE) {
        normal = object.normal;

        vec3 lightDirection = normalize(lightSourcePosition - intersectionPoint);
        float lightDiscriminant = get_discriminant_from_ray_intersection_with_sphere(intersectionPoint, lightDirection, sphere);

        if (lightDiscriminant > 0.0) {
            object.diffuseReflection = vec3(0.0);
            object.specularReflection = vec3(0.0);
        }
    } else {}

    vec4 color = getColor(rayOrigin, intersectionPoint, normal, object);

    gl_FragColor = color;
}