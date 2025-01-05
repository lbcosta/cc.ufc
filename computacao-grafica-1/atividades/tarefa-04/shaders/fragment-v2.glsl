precision mediump float;

// constant
float k = 5;

// --- Inputs ---

// Object 1: Plane
in vec3 plane__point; // (0,0,0)
in vec3 plane__normal; // (0,0,1)

// Object 2: Cilinder (with no top and bottom planes)
in vec3 cilinder__baseCenterPos; // (10,10,0)
in vec3 cilinder__topCenterPos; // (10,10,6)
in float cilinder__baseRadius; // 3

// Object 3: Sphere
in vec3 sphere__centerPos; // (10,10,10)
in float sphere__radius; // 5

// Object 4: Cone (with no bottom plane)
in vec3 cone__baseCenterPos; // (10,10,14)
in vec3 cone__vertexPos; // (10,10,18)
in float cone__baseRadius; // 3

// Light (Point)
in vec3 light__position; // (10+12cos(k*(pi/6), 10+12sin(k*(pi/6)), 12)
in vec3 light_intensity; // (1,1,1)

// Camera (Observer) or Ray
in vec3 ray__origin; // (10+12cos(k*(pi/6)), 10+12sin(k*(pi/6)), 21)
in vec3 ray__point; // (10,10,5)

// All objects are made by the same material
in vec3 object__diffuseReflection; // (0.5,0.25,0.5)
in vec3 object__specularReflection; // (0.5,0.25,0.5)
in float object__shininess; // 2

// --- Outputs ---
out vec4 fragColor;

// --- Functions ---

// -- Main -- 
void main {

}