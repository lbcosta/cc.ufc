class Point {
    constructor(x, y, z) {
        this.x = x
        this.y = y
        this.z = z
    }

    sub(p) {
        return new Point(this.x - p.x, this.y - p.y, this.z - p.z)
    }

    dot(p) {
        return this.x * p.x + this.y * p.y + this.z * p.z
    }

    norm() {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z)
    }

    normalize() {
        const n = this.norm()
        return new Point(this.x / n, this.y / n, this.z / n)
    }
}

class Color {
    constructor(r, g, b) {
        this.r = r
        this.g = g
        this.b = b
    }
}

const wJanela = 3 // metros
const hJanela = 3 // metros
const dJanela = 1 // metro
const z = -dJanela

const observer = new Point(0, 0, 0)

// Raio da esfera
const rEsfera = 0.5 // metros
// Centro da Esfera
const centroEsfera = new Point(0, 0, -1.5)
// Cor da esfera
const esfColor = new Color(255,0,0)
// Cor do fundo
const bgColor = new Color(100,100,100)

// Canvas
const nCol = 150
const nLin = 150

// Dimensões dos retângulos
const dx = wJanela / nCol
const dy = hJanela / nLin

function createCanvas() {
    const CANVAS_ID = 'canvas'
    const canvas = document.getElementById(CANVAS_ID)
    canvas.style.borderSpacing = 0

    for (let l = 0; l < nLin; l++) {
        const row = canvas.insertRow(l)
        for (let c = 0; c < nCol; c++) {
            const cell = row.insertCell(c)
            cell.id = `(${l},${c},${z})`
            cell.style.width = `1px`
            cell.style.height = `1px`
            cell.style.backgroundColor = `rgb(${bgColor.r},${bgColor.g},${bgColor.b})`
        }
    }
}

// d é o vetor que vai do observador ao ponto da tela
function traceRay(d) {
    // v = E - C, onde E é o observador e C é o centro da esfera. Ou seja, v é o vetor que vai do centro da esfera ao observador.
    const v = observer.sub(centroEsfera)
    
    // a = d.d
    const a = d.dot(d) 
    
    // b = 2v.d
    const b = 2 * v.dot(d) 

    // c = v.v - r^2
    const c = v.dot(v) - rEsfera * rEsfera 

    const delta = b * b - 4 * a * c
    if (delta < 0) {
        return bgColor
    } else {
        return esfColor
    }
}


// Pinta o pixel da tela
function paintPixel(l, c, color) {
    const cell = document.getElementById(`(${l},${c},${z})`)
    cell.style.backgroundColor = `rgb(${color.r},${color.g},${color.b})`
}

// Pinta a tela
function paintScreen() {
    for (let l = 0; l < nLin; l++) {
        for (let c = 0; c < nCol; c++) {
            const x = (-wJanela / 2) + (dx/2) + (c * dx)
            const y = (hJanela / 2) - (dy/2) - (l * dy)
            const d = new Point(x, y, z).sub(observer)
            const color = traceRay(d)
            paintPixel(l, c, color)
        }
    }
}

createCanvas()
paintScreen()