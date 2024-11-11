class Point {
    constructor(x, y, z) {
        this.x = x
        this.y = y
        this.z = z
    }

    toArray() {
        return [this.x, this.y, this.z]
    }
}

class Color {
    constructor(r, g, b) {
        this.r = r
        this.g = g
        this.b = b
    }

    toArray() {
        return [this.r, this.g, this.b]
    }
}

class Renderer {
    #gl
    #program
    #numVertices
    #canvasWidth
    #canvasHeight

    constructor() {
        const canvas = document.getElementById("canvas")
        if (!canvas) {
            console.error("Canvas não encontrado.")
        }

        this.#canvasWidth = canvas.width
        this.#canvasHeight = canvas.height
        
        this.#gl = canvas.getContext('webgl')
        if (!this.#gl) {
            throw new Error("Seu navegador não suporta WebGL.")
        }

        const vertexShader = this.#createShader(this.#gl.VERTEX_SHADER, "vertex-shader-2d")
        if (!vertexShader) {
            throw new Error("Erro ao criar o Vertex Shader.")
        }

        const fragmentShader = this.#createShader(this.#gl.FRAGMENT_SHADER, "fragment-shader-2d")
        if (!fragmentShader) {
            throw new Error("Erro ao criar o Fragment Shader.")
        }

        this.#program = this.#createProgram(this.#gl, vertexShader, fragmentShader)
        if (!this.#program) {
            throw new Error("Erro ao criar o Programa.")
        }

        this.#gl.useProgram(this.#program)
    }

    #createShader(type, sourceId) {
        const source = document.getElementById(sourceId).text
        if (!source) {
            return null
        }

        const shader = this.#gl.createShader(type)
        this.#gl.shaderSource(shader, source)
        this.#gl.compileShader(shader)
        if (!this.#gl.getShaderParameter(shader, this.#gl.COMPILE_STATUS)) {
            console.error(this.#gl.getShaderInfoLog(shader))
            this.#gl.deleteShader(shader)
            return null
        }
        
        return shader
    }

    #createProgram(gl, vertexShader, fragmentShader) {
        const program = gl.createProgram()
        gl.attachShader(program, vertexShader)
        gl.attachShader(program, fragmentShader)
        gl.linkProgram(program)
        if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
            console.error(gl.getProgramInfoLog(program))
            gl.deleteProgram(program)
            return null
        }

        return program
    }

    setPositionBuffer(positions) {
        const positionAttributeLocation = this.#gl.getAttribLocation(this.#program, "a_position")
        const positionBuffer = this.#gl.createBuffer()
        this.#gl.bindBuffer(this.#gl.ARRAY_BUFFER, positionBuffer)
        this.#gl.bufferData(this.#gl.ARRAY_BUFFER, new Float32Array(positions), this.#gl.STATIC_DRAW)
        this.#gl.enableVertexAttribArray(positionAttributeLocation)
        this.#gl.vertexAttribPointer(positionAttributeLocation, 2, this.#gl.FLOAT, false, 0, 0);
        
        this.#numVertices = positions.length
    }

    // params = { name: [dimensions, value], ... }
    setParams(params) {
        if (typeof params !== 'object') {
            throw new Error("Params deve ser um objeto.")
        }

        for (const [name, dv] of Object.entries(params)) {
            if (dv.length !== 2) {
                throw new Error("Dimensões ou valor inválidos.")
            }

            const [dimensions, value] = dv
            const location = this.#gl.getUniformLocation(this.#program, name)
            switch (dimensions) {
                case 1: this.#gl.uniform1f(location, value); break;
                case 2: this.#gl.uniform2fv(location, value); break;
                case 3: this.#gl.uniform3fv(location, value); break;
                case 4: this.#gl.uniform4fv(location, value); break;
                default: throw new Error("Dimensões inválidas.")
            }
        }

        this.#gl.uniform1f(this.#gl.getUniformLocation(this.#program, "canvasWidth"), this.#canvasWidth)
        this.#gl.uniform1f(this.#gl.getUniformLocation(this.#program, "canvasHeight"), this.#canvasHeight)
    }

    clear(color) {
        this.#gl.clearColor(color.r, color.g, color.b, 1)
        this.#gl.clear(this.#gl.COLOR_BUFFER_BIT)
    }

    render() {
        this.#gl.drawArrays(this.#gl.TRIANGLES, 0, this.#numVertices)
    }
}