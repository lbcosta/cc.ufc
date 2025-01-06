precision mediump float;

// --- Inputs ---

// window
uniform float windowWidth; // 20
uniform float windowHeight; // 20
uniform vec3 windowPosition; // (10,10,20)

// canvas
uniform float canvasWidth; // 800
uniform float canvasHeight; // 800
uniform float nCol; // 8
uniform float nRow; // 8

// Object 1: Plane
uniform vec3 plane_point; // (0,0,0)
uniform vec3 plane_normal; // (0,0,1)

// Object 2: Cilinder (with no top and bottom planes)
uniform vec3 cilinder_baseCenter; // (10,10,0)
uniform vec3 cilinder_topCenter; // (10,10,6)
uniform float cilinder_baseRadius; // 3

// Object 3: Sphere
uniform vec3 sphere_center; // (10,10,10)
uniform float sphere_radius; // 5

// Object 4: Cone (with no bottom plane)
uniform vec3 cone_baseCenterPos; // (10,10,14)
uniform vec3 cone_vertexPos; // (10,10,18)
uniform float cone_baseRadius; // 3

// Light (Point)
uniform vec3 light_position; // (10+12cos(k*(pi/6), 10+12sin(k*(pi/6)), 12)
uniform vec3 light_intensity; // (1,1,1)

// Camera (Observer) or Ray
uniform vec3 ray_origin; // (-0.392305, 16, 21)
uniform vec3 ray_point; // (10,10,5)

// All objects are made by the same material
uniform vec3 object_diffuseReflection; // (0.5,0.25,0.5)
uniform vec3 object_specularReflection; // (0.5,0.25,0.5)
uniform float object_shininess; // 2

// --- Structs ---
struct Ray {
    vec3 origin;
    vec3 direction;
};

struct Plane {
    vec3 point;
    vec3 normal;
};

struct Cilinder {
    vec3 baseCenterPos;
    vec3 topCenterPos;
    float baseRadius;
};

struct Sphere {
    vec3 centerPos;
    float radius;
};

struct Cone {
    vec3 baseCenterPos;
    vec3 vertexPos;
    float baseRadius;
};


// --- Functions ---
mat3 outerProduct(vec3 a, vec3 b) {
    return mat3(
        a.x * b.x, a.x * b.y, a.x * b.z,
        a.y * b.x, a.y * b.y, a.y * b.z,
        a.z * b.x, a.z * b.y, a.z * b.z
    );
}

vec3 CurrentPosition() {
    float deltaX = windowWidth / nCol;
    float col = floor(gl_FragCoord.x * (nCol / canvasWidth));
    float x = (-windowWidth / 2.0) + (deltaX / 2.0) + col * deltaX;

    float deltaY = windowHeight / nRow;
    float lin = floor(gl_FragCoord.y * (nRow / canvasHeight));
    float y = (-windowHeight / 2.0) + (deltaY / 2.0) + lin * deltaY; // invertido

    float z = windowPosition.z;

    return vec3(x, y, z);
}

vec3 Ray_Direction(Ray ray, vec3 point) {
    return normalize(point - ray.origin);
}

float Plane_RayIntersection(Ray ray, Plane plane) {
    return dot(plane.point - ray.origin, plane.normal) / dot(ray.direction, plane.normal);
}

mat3 Cilinder_ProjectionMatrix(Cilinder cilinder) {
    mat3 identityMatrix = mat3(1.0);
    
    vec3 baseToTop = cilinder.topCenterPos - cilinder.baseCenterPos;
    vec3 baseToTopNormalized = normalize(baseToTop);
    mat3 baseToTopMatrix = outerProduct(baseToTopNormalized, baseToTopNormalized);

    mat3 projectionMatrix = identityMatrix - baseToTopMatrix;
    return projectionMatrix;
}

vec3 Cilinder_BaseCenterToRayOrigin(Cilinder cilinder, Ray ray) {
    return ray.origin - cilinder.baseCenterPos;
}

bool Cilinder_ValidateIntersectionPoint(Cilinder cilinder, vec3 intersectionPoint) {
    vec3 baseToTop = cilinder.topCenterPos - cilinder.baseCenterPos;
    vec3 baseToIntersection = intersectionPoint - cilinder.baseCenterPos;

    float projection = dot(baseToTop, baseToIntersection);
    return projection >= 0.0 && projection <= dot(baseToTop, baseToTop);
}

float Cilinder_RayIntersectionWithSurface(Ray ray, Cilinder cilinder) {
    mat3 projectionMatrix = Cilinder_ProjectionMatrix(cilinder);
    vec3 baseToRayOrigin = Cilinder_BaseCenterToRayOrigin(cilinder, ray);

    float a = dot(projectionMatrix * ray.direction, ray.direction);
    float b = 2.0 * dot(projectionMatrix * ray.direction, baseToRayOrigin);
    float c = dot(projectionMatrix * baseToRayOrigin, baseToRayOrigin) - pow(cilinder.baseRadius, 2.0);

    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        return -1.0;
    }

    // calculate t values
    float t1 = (-b - sqrt(discriminant)) / (2.0 * a);
    float t2 = (-b + sqrt(discriminant)) / (2.0 * a);

    // calculate intersection points
    vec3 intersectionPoint1 = ray.origin + t1 * ray.direction;
    vec3 intersectionPoint2 = ray.origin + t2 * ray.direction;

    // validate intersection points
    bool isValidIntersectionPoint1 = Cilinder_ValidateIntersectionPoint(cilinder, intersectionPoint1);
    bool isValidIntersectionPoint2 = Cilinder_ValidateIntersectionPoint(cilinder, intersectionPoint2);

    if (isValidIntersectionPoint1 && isValidIntersectionPoint2) {
        return t1 < t2 ? t1 : t2;
    } else if (isValidIntersectionPoint1) {
        return t1;
    } else if (isValidIntersectionPoint2) {
        return t2;
    } else {
        return -1.0;
    }   
}

float Sphere_RayIntersection(Ray ray, Sphere sphere) {
    vec3 v = ray.origin - sphere.centerPos;

    float a = dot(ray.direction, ray.direction);
    float b = 2.0 * dot(v, ray.direction);
    float c = dot(v, v) - sphere.radius * sphere.radius;

    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        return -1.0;
    }

    float t1 = (-b - sqrt(discriminant)) / (2.0 * a);
    float t2 = (-b + sqrt(discriminant)) / (2.0 * a);

    return t1 < t2 ? t1 : t2;
}

void main() {
    // --- Ray ---
    Ray ray = Ray(ray_origin, CurrentPosition());

    // --- Plane ---
    Plane plane = Plane(plane_point, plane_normal);

    float tPlane = Plane_RayIntersection(ray, plane);

    // --- Cilinder ---
    Cilinder cilinder = Cilinder(cilinder_baseCenter, cilinder_topCenter, cilinder_baseRadius);

    float tCilinder = Cilinder_RayIntersectionWithSurface(ray, cilinder);

    // --- Sphere ---

    Sphere sphere = Sphere(sphere_center, sphere_radius);

    float tSphere = Sphere_RayIntersection(ray, sphere);

    if (tPlane > 0.0 && (tCilinder < 0.0 || tPlane < tCilinder) && (tSphere < 0.0 || tPlane < tSphere)) {
        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    } else if (tCilinder > 0.0 && (tSphere < 0.0 || tCilinder < tSphere)) {
        gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
    } else if (tSphere > 0.0) {
        gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}