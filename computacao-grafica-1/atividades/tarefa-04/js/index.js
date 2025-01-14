// # Configuração da Cena:
const sphereCenter = [0, 0, -100]
const sphereRadius = 40
const params = {
    // Janela:
        windowWidth: 60, // centímetros
        windowHeight: 60, // centímetros
        windowPosition: [0, 0, -30], // centímetros
    // Tela:
        canvasWidth: 500, // pixels
        canvasHeight: 500, // pixels
        nCol: 500, // número de colunas
        nRow: 500, // número de linhas
    // Floor:
        floor_point: [0, -40, 0], // centímetros
        floor_normal: [0, 1, 0], // vetor normal
        floor_ambientReflection: [0.2, 0.7, 0.2],
        floor_diffuseReflection: [0.2, 0.7, 0.2],
        floor_specularReflection: [0.0, 0.0, 0.0],
        floor_shininess: 1,
    // Wall:
        wall_point: [0, 0, -200], // centímetros
        wall_normal: [0, 0, 1], // vetor normal
        wall_ambientReflection: [0.3, 0.3, 0.7],
        wall_diffuseReflection: [0.3, 0.3, 0.7],
        wall_specularReflection: [0.0, 0.0, 0.0],
        wall_shininess: 1,
    // Cilíndro:
        cilinder_baseCenter: sphereCenter, // centímetros
        cilinder_baseRadius: sphereRadius/3, // centímetros
        cilinder_height: 3*sphereRadius,
        cilinder_direction: [-1/Math.sqrt(3), 1/Math.sqrt(3), -1/Math.sqrt(3)],
        cilinder_ambientReflection: [0.2, 0.3, 0.8],
        cilinder_diffuseReflection: [0.2, 0.3, 0.8],
        cilinder_specularReflection: [0.2, 0.3, 0.8],
        cilinder_shininess: 10,
    // Esfera:
        sphere_center: sphereCenter, // centímetros
        sphere_radius: sphereRadius, //
        sphere_ambientReflection: [0.7, 0.2, 0.2],
        sphere_diffuseReflection: [0.7, 0.2, 0.2],
        sphere_specularReflection: [0.7, 0.2, 0.2],
        sphere_shininess: 10,
    // Raio:
        ray_origin: [0, 0, 0], // centímetros
    // Cone:
        // cone_baseCenter will be calculated.
        cone_baseRadius: 1.5*sphereRadius,
        cone_height: (1.5*sphereRadius)/3,
        cone_direction: [-1/Math.sqrt(3), 1/Math.sqrt(3), -1/Math.sqrt(3)],
        cone_ambientReflection: [0.8, 0.3, 0.2],
        cone_diffuseReflection: [0.8, 0.3, 0.2],
        cone_specularReflection: [0.8, 0.3, 0.2],
        cone_shininess: 10,
    // Luz:
        light_position: [0, 60, -30],
        light_intensity: [0.7, 0.7, 0.7],
        ambient_light: [0.3, 0.3, 0.3],
}

const vertices = [
    // Dois triângulos
    // x,  y
      -1,  1,
       1,  1,
       1, -1,
      -1, -1,
      -1,  1,
       1, -1,
]

var renderer = new Renderer(params.canvasWidth, params.canvasHeight)
renderer.render(vertices, params)