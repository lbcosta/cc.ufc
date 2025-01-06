// # Configuração da Cena:
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
        // cilinder_baseCenter: [10, 10, 0], // centímetros
        // cilinder_topCenter: [10, 10, 6],
        // cilinder_baseRadius: 3, // centímetros
    // Esfera:
        sphere_center: [0, 0, -100], // centímetros
        sphere_radius: 40, //
        sphere_ambientReflection: [0.7, 0.2, 0.2],
        sphere_diffuseReflection: [0.7, 0.2, 0.2],
        sphere_specularReflection: [0.7, 0.2, 0.2],
        sphere_shininess: 10,
    // Raio:
        ray_origin: [0, 0, 0], // centímetros
    // Cone:
        // cone_baseCenter: [10, 10, 14], // centímetros
        // cone_vertex: [10, 10, 18],
        // cone_baseRadius: 3, // centímetros
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