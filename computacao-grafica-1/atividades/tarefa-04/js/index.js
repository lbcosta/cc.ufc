// # Configuração da Cena:

let sphereCenterPosition = [0, 0, -100] // centímetros
let lightSourcePosition = [0, 60, -30] // centímetros
let sphereRadius = 40 // centímetros
const windowDepth = 30 // centímetros
const params = {
    // Tela:
        canvasWidth: 500, // pixels
        canvasHeight: 500, // pixels
        nCol: 500, // número de colunas
        nRow: 500, // número de linhas
    // Esfera:
        sphereCenterPosition,
        sphereRadius,
        sphereDiffuseReflection: [0.7, 0.2, 0.2], // cor = vermelho
        sphereSpecularReflection: [0.7, 0.2, 0.2], // cor = vermelho
        sphereAmbientReflection: [0.7, 0.2, 0.2], // cor = vermelho
        sphereShininess: 10.0, // brilho
    // Janela:
        windowWidth: 60, // centímetros
        windowHeight: 60, // centímetros
        windowDepth, // centímetros
        windowPosition: [0, 0, -windowDepth], // centímetros
    // Origem do raio:
        rayOrigin: [0, 0, 0], // centímetros
    // Fonte de Luz:
        lightSourcePosition,
        lightSourceIntensity: [0.7, 0.7, 0.7], // cor = branco
        ambientLightIntensity: [0.3, 0.3, 0.3], // cor = cinza
    // Plano do chão:
        floorPosition: [0, -sphereRadius, 0], // centímetros
        floorNormal: [0, 1, 0], // vetor normal
        floorDiffuseReflection: [0.2, 0.7, 0.2], // cor = verde
        floorSpecularReflection: [0.0, 0.0, 0.0], // cor = preto
        floorAmbientReflection: [0.2, 0.7, 0.2], // cor = verde
        floorShininess: 1.0, // brilho
    // Plano do fundo:
        backPlanePosition: [0, 0, -200], // centímetros
        backPlaneNormal: [0, 0, 1], // vetor normal
        backPlaneDiffuseReflection: [0.3, 0.3, 0.7], // cor = azul
        backPlaneSpecularReflection: [0.0, 0.0, 0.0], // cor = preto
        backPlaneAmbientReflection: [0.3, 0.3, 0.7], // cor = azul
        backPlaneShininess: 1.0, // brilho
    // Cilindro:
        cilinderBaseCenterPosition: sphereCenterPosition, // centímetros
        cilinderBaseRadius: sphereRadius / 3, // centímetros
        cilinderHeight: sphereRadius * 3, // centímetros
        cilinderDirection: [-1/Math.sqrt(3), 1/Math.sqrt(3), -1/Math.sqrt(3)], // vetor direção
        cilinderDiffuseReflection: [0.2, 0.3, 0.8], // cor = azul
        cilinderSpecularReflection: [0.2, 0.3, 0.8], 
        cilinderAmbientReflection: [0.2, 0.3, 0.8], 
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