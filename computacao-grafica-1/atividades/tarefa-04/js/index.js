// # Configuração da Cena:
const params = {
    // Janela:
        windowWidth: 60, // centímetros
        windowHeight: 60, // centímetros
        windowPosition: [0, 0, -15], // centímetros
    // Tela:
        canvasWidth: 500, // pixels
        canvasHeight: 500, // pixels
        nCol: 500, // número de colunas
        nRow: 500, // número de linhas
    // Plano:
        plane_point: [0, 0, 0], // centímetros
        plane_normal: [0, 0, 1], // vetor normal
    // Cilíndro:
        cilinder_baseCenter: [10, 10, 0], // centímetros
        cilinder_topCenter: [10, 10, 6],
        cilinder_baseRadius: 3, // centímetros
    // Esfera:
        sphere_center: [10, 10, 10], // centímetros
        sphere_radius: 5, //
    // Raio:
        ray_origin: [-0.392305, 16, 21], // centímetros
        ray_point: [10, 10, 5], // centímetros
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