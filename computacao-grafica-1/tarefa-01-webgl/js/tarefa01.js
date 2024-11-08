// 1) Defina uma janela através da qual o pintor verá a esfera
//      >> A largura da janela, em metros, será armazenada na variável wJanela
const wJanela = 5 // metros
//      >> A altura da janela, em metros, será armazenada na variável hJanela
const hJanela = 3 // metros
//      >> O centro da janela está sobre o eixo Z do sistema de coordenadas na posição (0, 0, -dJanela) em metros.
//         Assim, todos os pontos no plano da janela terão coordenada z = -dJanela
const dJanela = 5 // metros
const wCenter = new Point(0,0,-dJanela)

// 2) O olho do pintor está na origem do sistema de coordenadas (0,0,0)
const eye = new Point(0,0,0)

// 3) O raio da esfera deve ser armazenad na variável rEsfera
const rEsfera = 1 // metro

// 4) O centro da esfera deve estar sobre o eixo z com coordenada z < -(dJanela+rEsfera)
const cEsfera = new Point(0,0,-8)

// 5) A cor da esfera deve ser esfColor = 255,0,0
const esfColor = [255,0,0]

// 6) A cor de background deve ser cinza bgColor = 100,100,100
const bgColor = [100,100,100]

// 7) Defina o número de colunas nCol e o número de linhas nLin da matriz de cores da imagem
//      >> nCol e nLin representam o número de colunas e linhas do quadriculado que o pintor marcou a lápis no Canvas de pintura
const nCol = 500
const nLin = 300

// As dimensões dos retângulos da tela são:
const dx = wJanela / nCol // = 5 / 500 = 0,01m
const dy = hJanela / nLin // = 3 / 300 = 0,01m

class Point {
    constructor(x,y,z) {
        this.x = x
        this.y = y
        this.z = z
    }

    subtract(b) {
        return new Point(
            this.x - b.x,
            this.y - b.y,
            this.z - b.z
        )
    }

    norm() {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z)
    }

    normalize() {
        const n = this.norm()
        return new Point(this.x / n, this.y / n, this.z / n)
    }

    dot(b) {
       return this.x * b.x + this.y * b.y + this.z * b.z 
    }
}

// Cada raio (semireta) parte do olho do pintor E = (0,0,0) e passa pelo ponto (x,y,-dJanela)
function CastRays() {
    for(let l = 0; l < nLin; l++) {
        for (let c = 0; c < nCol; c++) {
            const x = (-wJanela / 2) + dx/2 + c*dx
            const y = hJanela/2 - dy/2 - l*dy
           
            const p = new Point(x,y,-dJanela)
            const dr = p.subtract(eye)
            const color = castRay(dr)

            paint(color)
        }
    }
}

function castRay(dr) {
    const v = eye.subtract(cEsfera)

    const a = dr.normalize().dot(dr.normalize())
    const b = 2*(v.dot(dr))
    const c = v.normalize().dot(v.normalize()) - (rEsfera * rEsfera)

    const delta = (b*b) - 4*a*c

    if (delta > 0) {
        return esfColor
    } 

    return bgColor
}


// todo
function paint(l, c, color) {
    var canvas = document.querySelector("#c");

    var gl = canvas.getContext("webgl");
    
    if (!gl) {
        throw new Error("WebGL not supported");
    }
    
    var program = webglUtils.createProgramFromScripts(gl, ["vertex-shader-2d", "fragment-shader-2d"]);
    
    var positionAttributeLocation = gl.getAttribLocation(program, "a_position");
    
    var positionBuffer = gl.createBuffer();
    
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    
    var positions = [
        0, 0,
        0, 0.5,
        0.7, 0,
    ];
    
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);
    
    webglUtils.resizeCanvasToDisplaySize(gl.canvas);
    
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height); 
    
    gl.clearColor(0, 0, 0, 0); 
    gl.clear(gl.COLOR_BUFFER_BIT); 
    
    gl.useProgram(program);
    
    gl.enableVertexAttribArray(positionAttributeLocation);
    
    var size = 2;
    var type = gl.FLOAT;
    var normalize = false;
    var stride = 0;
    var offset = 0;        
    gl.vertexAttribPointer(positionAttributeLocation, size, type, normalize, stride, offset)
        
    var primitiveType = gl.TRIANGLES;
    var offset = 0;
    var count = 3;
    gl.drawArrays(primitiveType, offset, count);    
}