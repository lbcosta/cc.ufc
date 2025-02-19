precision mediump float;

#define NUMBER_OF_OBJECTS 5

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

    // Object 4: Cilinder
        uniform vec3 cilinder_baseCenter;
        uniform float cilinder_baseRadius;
        uniform float cilinder_height;
        uniform vec3 cilinder_direction;
        uniform vec3 cilinder_ambientReflection;
        uniform vec3 cilinder_diffuseReflection;
        uniform vec3 cilinder_specularReflection;
        uniform float cilinder_shininess;

    // Object 5: Cone
        uniform float cone_baseRadius;
        uniform float cone_height;
        uniform vec3 cone_direction;
        uniform vec3 cone_ambientReflection;
        uniform vec3 cone_diffuseReflection;
        uniform vec3 cone_specularReflection;
        uniform float cone_shininess;

    // Light (Point)
        uniform vec3 light_position;
        uniform vec3 light_intensity;
        uniform vec3 ambient_light;

    // Camera (Observer) or Ray
        uniform vec3 ray_origin;

// --- Structs ---
    struct Ray {
        vec3 origin;
        vec3 at;
        vec3 direction;
    };

    struct Plane {
        vec3 point;
        vec3 normal;
    };

    struct Cilinder {
        vec3 baseCenter;
        float baseRadius;
        float height;
        vec3 direction;
    };

    struct Sphere {
        vec3 centerPos;
        float radius;
    };

    struct Cone {
        vec3 baseCenter;
        float baseRadius;
        float height;
        vec3 direction;
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
    // Ray
        Ray CreateRay(vec3 origin, vec3 at);
    // Plane
        Object CreatePlane(int id, Plane plane, Material material);
        float Plane_RayIntersection(Ray ray, Plane plane);
    // Cilinder
        Object CreateCilinder(int id, Cilinder cilinder, Material material);
        mat3 Cilinder_ProjectionMatrix(Cilinder cilinder);
        bool Cilinder_ValidateIntersectionPoint(Cilinder cilinder, vec3 intersectionPoint);
        float Cilinder_RayIntersection(Ray ray, Cilinder cilinder);
        vec3 Cilinder_Normal(Cilinder cilinder, Ray ray);
    // Sphere
        Object CreateSphere(int id, Sphere sphere, Material material);
        float Sphere_RayIntersection(Ray ray, Sphere sphere);
        vec3 Sphere_Normal(Sphere sphere, Ray ray);
    // Cone
        Object CreateCone(int id, Cone cone, Material material);
        bool Cone_ValidateIntersectionPoint(Cone cone, vec3 intersectionPoint);
        float Cone_RayIntersection(Ray ray, Cone cone);
        vec3 Cone_Normal(Cone cone, Ray ray);
    // Object
        float Object_RayIntersection(Object object, Ray ray);
        vec3 Object_Normal(Object object, Ray ray);
        Object Objects_GetClosest(Object objects[NUMBER_OF_OBJECTS], Ray ray);
    // Light
        bool Light_IsObstructed(int closestObjectId, vec3 lightPosition, vec3 intersectionPoint, Object objects[NUMBER_OF_OBJECTS]);
        vec3 CalculatePhongLighting(Ray ray, Object closestObject, Object sceneObjects[NUMBER_OF_OBJECTS]);

// --- Main ---
    void main() {
        Ray ray = CreateRay(ray_origin, CurrentPosition());

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

        // --- Cilinder ---
            objects[3] = CreateCilinder(
                3,
                Cilinder(cilinder_baseCenter, cilinder_baseRadius, cilinder_height, cilinder_direction),
                Material(cilinder_ambientReflection, cilinder_diffuseReflection, cilinder_specularReflection, cilinder_shininess)
            );

        // --- Cone ---
            vec3 coneBaseCenter = cilinder_baseCenter + cilinder_height * cilinder_direction;
            objects[4] = CreateCone(
                4,
                Cone(coneBaseCenter, cone_baseRadius, cone_height, cone_direction),
                Material(cone_ambientReflection, cone_diffuseReflection, cone_specularReflection, cone_shininess)
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

    // Ray
    Ray CreateRay(vec3 origin, vec3 at) {
        Ray ray;
        ray.origin = origin;
        ray.at = at;
        ray.direction = normalize(at - origin);

        return ray;
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
        vec3 planeToOrigin = ray.origin - plane.point;
        float numerator = dot(planeToOrigin, plane.normal);
        float denominator = dot(ray.direction, plane.normal);

        if (denominator == 0.0) {
            return -1.0;
        }

        return -numerator / denominator;
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
        
        vec3 cylinderAxis = normalize(cilinder.direction);
        mat3 cylinderAxisMatrix = outerProduct(cylinderAxis, cylinderAxis);

        mat3 projectionMatrix = identityMatrix - cylinderAxisMatrix;
        return projectionMatrix;
    }

    bool Cilinder_ValidateIntersectionPoint(Cilinder cilinder, vec3 intersectionPoint) {
        vec3 baseToIntersection = intersectionPoint - cilinder.baseCenter;
        float projection = dot(baseToIntersection, cilinder.direction);
        return projection >= 0.0 && projection <= cilinder.height;
    }

    float Cilinder_RayIntersection(Ray ray, Cilinder cilinder) {
        mat3 M = Cilinder_ProjectionMatrix(cilinder);
        vec3 v = ray.origin - cilinder.baseCenter;

        float a = dot(M * ray.direction, ray.direction);
        float b = 2.0 * dot(M * ray.direction, v);
        float c = dot(M * v, v) - pow(cilinder.baseRadius, 2.0);

        if (a == 0.0) {
            float t = -c / b;
            vec3 intersectionPoint = ray.origin + t * ray.direction;
            bool isValidIntersectionPoint = Cilinder_ValidateIntersectionPoint(cilinder, intersectionPoint);

            if (isValidIntersectionPoint) {
                return t;
            } else {
                return -1.0;
            }
        }

        float discriminant = b * b - 4.0 * a * c;

        if (discriminant < 0.0) {
            return -1.0;
        }

        if (discriminant == 0.0) {
            float t = -b / (2.0 * a);
            vec3 intersectionPoint = ray.origin + t * ray.direction;
            bool isValidIntersectionPoint = Cilinder_ValidateIntersectionPoint(cilinder, intersectionPoint);

            if (isValidIntersectionPoint) {
                return t;
            } else {
                return -1.0;
            }
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
        float t = Cilinder_RayIntersection(ray, cilinder);
        vec3 intersectionPoint = ray.origin + t * ray.direction;
        vec3 baseToIntersection = intersectionPoint - cilinder.baseCenter;
        vec3 projection = dot(cilinder.direction, baseToIntersection) * cilinder.direction;
        vec3 normal = normalize(baseToIntersection - projection);

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
        float c = dot(v, v) - pow(sphere.radius, 2.0);

        float discriminant = b * b - 4.0 * a * c;

        if (discriminant <= 0.0) {
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

    bool Cone_ValidateIntersectionPoint(Cone cone, vec3 intersectionPoint) {
        vec3 baseToIntersection = intersectionPoint - cone.baseCenter;
        float projection = dot(baseToIntersection, cone.direction);
        return projection >= 0.0 && projection <= cone.height;
    }

    float Cone_RayIntersection(Ray ray, Cone cone) {
        vec3 coneAxis = normalize(cone.direction);
        mat3 Q = outerProduct(coneAxis, coneAxis);
        mat3 M = mat3(1.0) - Q;
        vec3 s = ray.origin - cone.baseCenter;

        // a = (d.M.d.h^2) - (d.Q.d.r^2)
        float a1 = (dot(M * ray.direction, ray.direction) * pow(cone.height, 2.0));
        float a2 = (dot(Q * ray.direction, ray.direction) * pow(cone.baseRadius, 2.0));
        float a = a1 - a2;

        // b = (2.d.M.s.h^2) + (2.d.Q.d.H.r^2) - (2.d.Q.s.r^2)
        float b1 = 2.0 * dot(M * ray.direction, s) * pow(cone.height, 2.0);
        float b2 = 2.0 * dot(Q * cone.direction, ray.direction) * cone.height * pow(cone.baseRadius, 2.0);
        float b3 = 2.0 * dot(Q * ray.direction, s) * pow(cone.baseRadius, 2.0);
        float b = b1 + b2 - b3;

        // c = (s.M.s.h^2) + (2.d.Q.s.h.r^2) - (s.Q.s.r^2) - (h^2.r^2)
        float c1 = dot(M * s, s) * pow(cone.height, 2.0);
        float c2 = 2.0 * dot(Q * s, cone.direction) * cone.height * pow(cone.baseRadius, 2.0);
        float c3 = dot(Q * s, s) * pow(cone.baseRadius, 2.0);
        float c4 = pow(cone.height, 2.0) * pow(cone.baseRadius, 2.0);
        float c = c1 + c2 - c3 - c4;

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

        if (discriminant == 0.0) {
            float t = -b / (2.0 * a);
            vec3 intersectionPoint = ray.origin + t * ray.direction;
            bool isValidIntersectionPoint = Cone_ValidateIntersectionPoint(cone, intersectionPoint);

            if (isValidIntersectionPoint) {
                return t;
            } else {
                return -1.0;
            }
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
        float t = Cone_RayIntersection(ray, cone);
        vec3 intersectionPoint = ray.origin + t * ray.direction;
        vec3 baseToIntersection = intersectionPoint - cone.baseCenter;
        vec3 projection = dot(cone.direction, baseToIntersection) * cone.direction;
        vec3 normal = normalize(baseToIntersection - projection);

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

    bool Light_IsObstructed(int closestObjectId, vec3 lightPosition, vec3 intersectionPoint, Object objects[NUMBER_OF_OBJECTS]) {
        Ray lightRay = CreateRay(lightPosition, intersectionPoint);
        Object closestObjectToLightRay = Objects_GetClosest(objects, lightRay);
        float lightT = Object_RayIntersection(closestObjectToLightRay, lightRay);
        
        bool isLightTValid = lightT > 0.0;
        bool isClosestObjectToLightRayDifferent = closestObjectToLightRay.id != closestObjectId;
        bool isLightRayTooLong = lightT < length(lightPosition - intersectionPoint);

        return isLightTValid && isClosestObjectToLightRayDifferent && isLightRayTooLong;
    }

    vec3 CalculatePhongLighting(Ray ray, Object closestObject, Object sceneObjects[NUMBER_OF_OBJECTS]) {
        float t = Object_RayIntersection(closestObject, ray);
        vec3 p = ray.origin + t * ray.direction;
        
        vec3 ambient = closestObject.material.ambientReflection * ambient_light;
        vec3 diffuse = vec3(0.0);
        vec3 specular = vec3(0.0);

        bool isLightObstructed = Light_IsObstructed(closestObject.id, light_position, p, sceneObjects);

        if (!isLightObstructed) {
            // light vectors
                vec3 v = -ray.direction;
                vec3 n = Object_Normal(closestObject, ray);
                vec3 l = normalize(light_position - p);
                vec3 r = 2.0 * dot(n, l) * n - l;

            // atenuation factors
                float fd = max(dot(n, l), 0.0);
                float fs = pow(max(dot(v, r), 0.0), closestObject.material.shininess);

            diffuse = closestObject.material.diffuseReflection * light_intensity * fd;
            specular = closestObject.material.specularReflection * light_intensity * fs;
        }


        return ambient + diffuse + specular;
    }