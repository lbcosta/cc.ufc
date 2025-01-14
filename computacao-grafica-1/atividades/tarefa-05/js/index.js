// # Configuração da Cena:
const sphereCenter = [0, 0, -100]
const sphereRadius = 40
const woodTexture = [0.54, 0.27, 0.07]
const params = {
    // Janela:
        windowWidth: 60,
        windowHeight: 60,
        windowPosition: [0, 0, -30],
    // Tela:
        canvasWidth: 500, // pixels
        canvasHeight: 500, // pixels
        nCol: 500, // número de colunas
        nRow: 500, // número de linhas
    // Floor:
        floor_point: [0, -150, 0],
        floor_normal: [0, 1, 0],
        floor_ambientReflection: woodTexture,
        floor_diffuseReflection: woodTexture,
        floor_specularReflection: woodTexture,
        floor_shininess: 1,
    // Right Wall:
        right_wall_point: [200, -150, 0],
        right_wall_normal: [-1, 0, 0],
        right_wall_ambientReflection: [0.686, 0.933, 0.933],
        right_wall_diffuseReflection: [0.686, 0.933, 0.933],
        right_wall_specularReflection: [0.686, 0.933, 0.933],
        right_wall_shininess: 1,
    // Front Wall:
        front_wall_point: [200, -150, -400],
        front_wall_normal: [0, 0, 1],
        front_wall_ambientReflection: [0.686, 0.933, 0.933],
        front_wall_diffuseReflection: [0.686, 0.933, 0.933],
        front_wall_specularReflection: [0.686, 0.933, 0.933],
        front_wall_shininess: 1,
    // Left Wall:
        left_wall_point: [-200, -150, 0],
        left_wall_normal: [1, 0, 0],
        left_wall_ambientReflection: [0.686, 0.933, 0.933],
        left_wall_diffuseReflection: [0.686, 0.933, 0.933],
        left_wall_specularReflection: [0.686, 0.933, 0.933],
        left_wall_shininess: 1,
    // Roof:
        roof_point: [0, 150, 0],
        roof_normal: [0, -1, 0],
        roof_ambientReflection: [0.933, 0.933, 0.933],
        roof_diffuseReflection: [0.933, 0.933, 0.933],
        roof_specularReflection: [0.933, 0.933, 0.933],
        roof_shininess: 1,
    // Cilíndro:
        cilinder_baseCenter: [0, -150, -200],
        cilinder_baseRadius: 5,
        cilinder_height: 90,
        cilinder_direction: [0, 1, 0],
        cilinder_ambientReflection: [0.824, 0.706, 0.549],
        cilinder_diffuseReflection: [0.824, 0.706, 0.549],
        cilinder_specularReflection: [0.824, 0.706, 0.549],
        cilinder_shininess: 10,
    // Cone:
        cone_baseCenter: [0, -60, -200],
        cone_baseRadius: 90,
        cone_height: 150,
        cone_direction: [0, 1, 0],
        cone_ambientReflection: [0, 1, 0.498],
        cone_diffuseReflection: [0, 1, 0.498],
        cone_specularReflection: [0, 1, 0.498],
        cone_shininess: 10,
    // Cubo:
        cube_edge: 40,
        cube_baseCenter: [0, -150, -165],
        cube_baseNormal: [0, 1, 0],
        cube_ambientReflection: [1, 0.078, 0.576],
        cube_diffuseReflection: [1, 0.078, 0.576],
        cube_specularReflection: [1, 0.078, 0.576],
        cube_shininess: 10,
    // Esfera:
        sphere_center: [0, 95, -200],
        sphere_radius: 5,
        sphere_ambientReflection: [0.854, 0.647, 0.125],
        sphere_diffuseReflection: [0.854, 0.647, 0.125],
        sphere_specularReflection: [0.854, 0.647, 0.125],
        sphere_shininess: 10,
    // Raio:
        ray_origin: [0, 0, 0],
    // Luz:
        light_intensity: [0.7, 0.7, 0.7],
        light_position: [-100, 140, -20],
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