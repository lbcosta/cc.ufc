// # Configuração da Cena:

let sphereCenterPosition = [0, 0, -100] // centímetros
let lightSourcePosition = [0, 50, 0] // centímetros
const windowDepth = 30 // centímetros
const params = {
    // Tela:
        canvasWidth: 500, // pixels
        canvasHeight: 500, // pixels
        nCol: 500, // número de colunas
        nRow: 500, // número de linhas
    // Esfera:
        sphereCenterPosition,
        sphereRadius: 40, // centímetros
        sphereDiffuseReflection: [1.0, 0.0, 0.0], // cor = vermelho
        sphereSpecularReflection: [1.0, 1.0, 1.0], // cor = branco
        sphereShininess: 20.0, // brilho
    // Janela:
        windowWidth: 60, // centímetros
        windowHeight: 60, // centímetros
        windowDepth, // centímetros
        windowPosition: [0, 0, -windowDepth], // centímetros
    // Origem do raio:
        rayOrigin: [0, 0, 0], // centímetros
    // Cores:
        backgroundColor: [0.39, 0.39, 0.39], // cinza
    // Luminosidade:
        lightSourcePosition,
        lightSourceIntensity: [0.7, 0.7, 0.7], // cor = branco
}

const vertices = [
    // Dois triângulos
    // x,  y
      -1, -1,
       1, -1,
      -1,  1,
      -1,  1,
       1, -1,
       1,  1,
]

var renderer = new Renderer(params.canvasWidth, params.canvasHeight)
renderer.render(vertices, params)

// # Interação com a cena:

const [X, Y, Z] = [0, 1, 2]

document.getElementById('sphereX').value = sphereCenterPosition[0]
document.getElementById('sphereY').value = sphereCenterPosition[1]
document.getElementById('sphereZ').value = sphereCenterPosition[2]
document.addEventListener('input', (event) => {
    const target = event.target
    const value = parseInt(target.value)
    switch (target.id) {
        case 'sphereX':
            sphereCenterPosition[X] = value
            break
        case 'sphereY':
            sphereCenterPosition[Y] = value
            break
        case 'sphereZ':
            sphereCenterPosition[Z] = value
            break
    }
    renderer.render(vertices, params)
})


document.getElementById('lightX').value = lightSourcePosition[0]
document.getElementById('lightY').value = lightSourcePosition[1]
document.getElementById('lightZ').value = lightSourcePosition[2]
document.addEventListener('input', (event) => {
    const target = event.target
    const value = parseInt(target.value)
    switch (target.id) {
        case 'lightX':
            lightSourcePosition[X] = value
            break
        case 'lightY':
            lightSourcePosition[Y] = value
            break
        case 'lightZ':
            lightSourcePosition[Z] = value
            break
    }
    renderer.render(vertices, params)
})