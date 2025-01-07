precision mediump float;

#define NUMBER_OF_OBJECTS 3

// --- object types ---
    #define PLANE 1
    #define CILINDER 2
    #define SPHERE 3
    #define CONE 4

// --- Inputs ---
    // window
        uniform float windowWidth;
        uniform float windowHeight;
        uniform vec3 windowPosition;

    // canvas
        uniform float canvasWidth;
        uniform float canvasHeight;
        uniform float nCol;
        uniform float nRow;

    // Object 1: Floor
        uniform vec3 floor_point;
        uniform vec3 floor_normal;
        uniform vec3 floor_ambientReflection;
        uniform vec3 floor_diffuseReflection;
        uniform vec3 floor_specularReflection;
        uniform float floor_shininess;

    // Object 2: Wall
        uniform vec3 wall_point;
        uniform vec3 wall_normal;
        uniform vec3 wall_ambientReflection;
        uniform vec3 wall_diffuseReflection;
        uniform vec3 wall_specularReflection;
        uniform float wall_shininess;

    // Object 3: Sphere
        uniform vec3 sphere_center;
        uniform float sphere_radius;
        uniform vec3 sphere_ambientReflection;
        uniform vec3 sphere_diffuseReflection;
        uniform vec3 sphere_specularReflection;
        uniform float sphere_shininess;

    // Light (Point)
        uniform vec3 light_position;
        uniform vec3 light_intensity;
        uniform vec3 ambient_light;

    // Camera (Observer) or Ray
        uniform vec3 ray_origin;

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
        vec3 baseCenter;
        vec3 vertex;
        float baseRadius;
    };

    struct Material {
        vec3 ambientReflection;
        vec3 diffuseReflection;
        vec3 specularReflection;
        float shininess;
    };

    struct Object {
        int id;
        int type;
        /* an Object can be { */
            Plane plane;
            Cilinder cilinder;
            Sphere sphere;
            Cone cone;
        /* } */
        Material material;
    };

// --- Functions ---
    // General
        mat3 outerProduct(vec3 a, vec3 b);
        vec3 CurrentPosition();
    // Plane
        Object CreatePlane(int id, Plane plane, Material material);
        float Plane_RayIntersection(Ray ray, Plane plane);
    // Cilinder
        Object CreateCilinder(int id, Cilinder cilinder, Material material);
        mat3 Cilinder_ProjectionMatrix(Cilinder cilinder);
        vec3 Cilinder_BaseCenterToRayOrigin(Cilinder cilinder, Ray ray);
        bool Cilinder_ValidateIntersectionPoint(Cilinder cilinder, vec3 intersectionPoint);
        float Cilinder_RayIntersection(Ray ray, Cilinder cilinder);
        vec3 Cilinder_Normal(Cilinder cilinder, Ray ray);
    // Sphere
        Object CreateSphere(int id, Sphere sphere, Material material);
        float Sphere_RayIntersection(Ray ray, Sphere sphere);
        vec3 Sphere_Normal(Sphere sphere, Ray ray);
    // Cone
        Object CreateCone(int id, Cone cone, Material material);
        mat3 Cone_ProjectionMatrixQ(Cone cone);
        mat3 Cone_ProjectionMatrixM(Cone cone);
        bool Cone_ValidateIntersectionPoint(Cone cone, vec3 intersectionPoint);
        float Cone_RayIntersection(Ray ray, Cone cone);
        vec3 Cone_Normal(Cone cone, Ray ray);
    // Object
        float Object_RayIntersection(Object object, Ray ray);
        vec3 Object_Normal(Object object, Ray ray);
        Object Objects_GetClosest(Object objects[NUMBER_OF_OBJECTS], Ray ray);
    // Light
        bool Light_IsObstructed(vec3 lightPosition, vec3 intersectionPoint, Object objects[NUMBER_OF_OBJECTS]);
        vec3 CalculatePhongLighting(Ray ray, Object closestObject, Object sceneObjects[NUMBER_OF_OBJECTS]);

// --- Main ---
    void main() {
        Ray ray = Ray(ray_origin, CurrentPosition());

        Object objects[NUMBER_OF_OBJECTS];
        // --- Floor ---
            objects[0] = CreatePlane(
                0, 
                Plane(floor_point, floor_normal),
                Material(floor_ambientReflection, floor_diffuseReflection, floor_specularReflection, floor_shininess)
            );

        // --- Wall ---
            objects[1] = CreatePlane(
                1, 
                Plane(wall_point, wall_normal),
                Material(wall_ambientReflection, wall_diffuseReflection, wall_specularReflection, wall_shininess)
            );

        // --- Sphere ---
            objects[2] = CreateSphere(
                2,
                Sphere(sphere_center, sphere_radius),
                Material(sphere_ambientReflection, sphere_diffuseReflection, sphere_specularReflection, sphere_shininess)
            );

        // --- Intersection ---
        Object closestObject = Objects_GetClosest(objects, ray);
        vec3 color = CalculatePhongLighting(ray, closestObject, objects);

        gl_FragColor = vec4(color, 1.0);
    }

// --- Function Implementations ---
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

    Object CreatePlane(int id, Plane plane, Material material) {
        Object object;
        object.id = id;
        object.type = PLANE;
        object.plane = plane;
        object.material = material;

        return object;
    }

    float Plane_RayIntersection(Ray ray, Plane plane) {
        return dot(plane.point - ray.origin, plane.normal) / dot(ray.direction, plane.normal);
    }

    Object CreateCilinder(int id, Cilinder cilinder, Material material) {
        Object object;
        object.id = id;
        object.type = CILINDER;
        object.cilinder = cilinder;
        object.material = material;

        return object;
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

    float Cilinder_RayIntersection(Ray ray, Cilinder cilinder) {
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

    vec3 Cilinder_Normal(Cilinder cilinder, Ray ray) {
        vec3 baseToTop = cilinder.topCenterPos - cilinder.baseCenterPos;
        vec3 baseToRayOrigin = ray.origin - cilinder.baseCenterPos;

        vec3 projection = dot(baseToRayOrigin, baseToTop) * baseToTop;
        vec3 normal = normalize(baseToRayOrigin - projection);

        return normal;
    }

    Object CreateSphere(int id, Sphere sphere, Material material) {
        Object object;
        object.id = id;
        object.type = SPHERE;
        object.sphere = sphere;
        object.material = material;

        return object;
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

    vec3 Sphere_Normal(Sphere sphere, Ray ray) {
        vec3 p = ray.origin + Sphere_RayIntersection(ray, sphere) * ray.direction;
        vec3 n = normalize(p - sphere.centerPos);

        return n;
    }

    Object CreateCone(int id, Cone cone, Material material) {
        Object object;
        object.id = id;
        object.type = CONE;
        object.cone = cone;
        object.material = material;

        return object;
    }

    mat3 Cone_ProjectionMatrixQ(Cone cone) {
        vec3 baseToVertex = cone.vertex - cone.baseCenter;
        vec3 baseToVertexNormalized = normalize(baseToVertex);
        mat3 baseToVertexMatrix = outerProduct(baseToVertexNormalized, baseToVertexNormalized);

        return baseToVertexMatrix;
    }

    mat3 Cone_ProjectionMatrixM(Cone cone) {
        mat3 identityMatrix = mat3(1.0);
        mat3 baseToVertexMatrix = Cone_ProjectionMatrixQ(cone);

        mat3 projectionMatrix = identityMatrix - baseToVertexMatrix;
        return projectionMatrix;
    }

    bool Cone_ValidateIntersectionPoint(Cone cone, vec3 intersectionPoint) {
        vec3 coneHeight = cone.vertex - cone.baseCenter;
        vec3 baseToIntersection = intersectionPoint - cone.baseCenter;

        float projection = dot(coneHeight, baseToIntersection);
        return projection >= 0.0 && projection <= dot(coneHeight, coneHeight);
    }

    float Cone_RayIntersection(Ray ray, Cone cone) {
        mat3 projectionMatrixM = Cone_ProjectionMatrixM(cone);
        mat3 projectionMatrixQ = Cone_ProjectionMatrixQ(cone);
        vec3 baseToRayOrigin = ray.origin - cone.baseCenter;

        float coneHeight = length(cone.vertex - cone.baseCenter);

        // a = (d.M.d.h^2) - (d.Q.d.r^2)
        float a = (dot(projectionMatrixM * ray.direction, ray.direction) * pow(coneHeight, 2.0)) - (dot(projectionMatrixQ * ray.direction, ray.direction) * pow(cone.baseRadius, 2.0));

        // b = (2.d.M.s.h^2) + (2.d.Q.d.H.r^2) - (2.d.Q.s.r^2)
        float b = (2.0 * dot(projectionMatrixM * ray.direction, baseToRayOrigin) * pow(coneHeight, 2.0)) 
        + (2.0 * dot(projectionMatrixQ * ray.direction, ray.direction) * coneHeight * pow(cone.baseRadius, 2.0)) 
        - (2.0 * dot(projectionMatrixQ * ray.direction, baseToRayOrigin) * pow(cone.baseRadius, 2.0));

        // c = (s.M.s.h^2) + (2.d.Q.s.h.r^2) - (s.Q.s.r^2) - (h^2.r^2)
        float c = (dot(projectionMatrixM * baseToRayOrigin, baseToRayOrigin) * pow(coneHeight, 2.0))
        + (2.0 * dot(projectionMatrixQ * baseToRayOrigin, ray.direction) * coneHeight * pow(cone.baseRadius, 2.0))
        - (dot(projectionMatrixQ * baseToRayOrigin, baseToRayOrigin) * pow(cone.baseRadius, 2.0))
        - (pow(coneHeight, 2.0) * pow(cone.baseRadius, 2.0));

        if (a == 0.0) {
            float t1 = -c / b;
            vec3 intersectionPoint1 = ray.origin + t1 * ray.direction;
            bool isValidIntersectionPoint1 = Cone_ValidateIntersectionPoint(cone, intersectionPoint1);

            if (isValidIntersectionPoint1) {
                return t1;
            } else {
                return -1.0;
            }
        }

        float discriminant = b * b - 4.0 * a * c;

        if (discriminant < 0.0) {
            return -1.0;
        }

        float t1 = (-b - sqrt(discriminant)) / (2.0 * a);
        float t2 = (-b + sqrt(discriminant)) / (2.0 * a);

        vec3 intersectionPoint1 = ray.origin + t1 * ray.direction;
        vec3 intersectionPoint2 = ray.origin + t2 * ray.direction;

        bool isValidIntersectionPoint1 = Cone_ValidateIntersectionPoint(cone, intersectionPoint1);
        bool isValidIntersectionPoint2 = Cone_ValidateIntersectionPoint(cone, intersectionPoint2);

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

    vec3 Cone_Normal(Cone cone, Ray ray) {
        vec3 p = ray.origin + Cone_RayIntersection(ray, cone) * ray.direction;
        vec3 coneHeight = cone.vertex - cone.baseCenter;
        vec3 baseToP = p - cone.baseCenter;

        vec3 projection = dot(coneHeight, baseToP) * coneHeight;
        vec3 normal = normalize(baseToP - projection);

        return normal;
    }

    float Object_RayIntersection(Object object, Ray ray) {
        if (object.type == PLANE) return Plane_RayIntersection(ray, object.plane);
        else if (object.type == CILINDER) return Cilinder_RayIntersection(ray, object.cilinder);
        else if (object.type == SPHERE) return Sphere_RayIntersection(ray, object.sphere);
        else if (object.type == CONE) return Cone_RayIntersection(ray, object.cone);
    }

    vec3 Object_Normal(Object object, Ray ray) {
        if (object.type == PLANE) return object.plane.normal;
        else if (object.type == CILINDER) return Cilinder_Normal(object.cilinder, ray);
        else if (object.type == SPHERE) return Sphere_Normal(object.sphere, ray);
        else if (object.type == CONE) return Cone_Normal(object.cone, ray);
    }

    Object Objects_GetClosest(Object objects[NUMBER_OF_OBJECTS], Ray ray) {
        Object closestObject;
        float tClosestObject = -1.0;

        for (int i = 0; i < NUMBER_OF_OBJECTS; i++) {
            Object object = objects[i];
            float t = Object_RayIntersection(object, ray);
            
            if (t > 0.0 && (tClosestObject < 0.0 || t < tClosestObject)) {
                closestObject = object;
                tClosestObject = t;
            }
        }

        return closestObject;
    }

    bool Light_IsObstructed(vec3 lightPosition, vec3 intersectionPoint, Object objects[NUMBER_OF_OBJECTS]) {
        Ray ray = Ray(intersectionPoint, lightPosition - intersectionPoint);
        Object closestObject = Objects_GetClosest(objects, ray);
        float t = Object_RayIntersection(closestObject, ray);
        return t > 0.0 && t < 1.0;
    }

    vec3 CalculatePhongLighting(Ray ray, Object closestObject, Object sceneObjects[NUMBER_OF_OBJECTS]) {
        float objectIntersection = Object_RayIntersection(closestObject, ray);
        vec3 intersectionPoint = ray.origin + objectIntersection * ray.direction;
        
        vec3 ambient = closestObject.material.ambientReflection * ambient_light;
        vec3 diffuse = vec3(0.0);
        vec3 specular = vec3(0.0);

        bool isLightObstructed = Light_IsObstructed(light_position, intersectionPoint, sceneObjects);

        if (!isLightObstructed) {
            // light vectors
                vec3 v = normalize(ray.origin - intersectionPoint);
                vec3 n = Object_Normal(closestObject, ray);
                vec3 l = normalize(light_position - intersectionPoint);
                vec3 r = reflect(-l, n);

            // atenuation factors
                float fd = max(dot(n, l), 0.0);
                float fs = pow(max(dot(r, v), 0.0), closestObject.material.shininess);

            diffuse = closestObject.material.diffuseReflection * light_intensity * fd;
            specular = closestObject.material.specularReflection * light_intensity * fs;
        }


        return ambient + diffuse + specular;
    }