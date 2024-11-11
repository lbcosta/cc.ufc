class Renderer {
    #gl
    #program
    #numVertices
    #canvasWidth
    #canvasHeight

    constructor() {
        const canvas = document.getElementById("canvas");
        if (!canvas) {
            console.error("Canvas não encontrado.");
            return;
        }

        this.#canvasWidth = canvas.width;
        this.#canvasHeight = canvas.height;
        
        this.#gl = canvas.getContext('webgl');
        if (!this.#gl) {
            throw new Error("Seu navegador não suporta WebGL.");
        }

        this.programReady = this.#init();

        return new Proxy(this, {
            get: (target, prop) => {
                const value = target[prop];
                if (typeof value === 'function' && prop !== '#init' && prop !== '#createShader' && prop !== '#createProgram') {
                    return async (...args) => {
                        await target.programReady;
                        return value.apply(target, args);
                    };
                }
                return value;
            }
        });
    }

    async #init() {
        const vertexShader = await this.#createShader(this.#gl.VERTEX_SHADER, "shaders/vertex.glsl");
        if (!vertexShader) {
            throw new Error("Erro ao criar o Vertex Shader.");
        }

        const fragmentShader = await this.#createShader(this.#gl.FRAGMENT_SHADER, "shaders/fragment.glsl");
        if (!fragmentShader) {
            throw new Error("Erro ao criar o Fragment Shader.");
        }

        this.#program = this.#createProgram(this.#gl, vertexShader, fragmentShader);
        if (!this.#program) {
            throw new Error("Erro ao criar o Programa.");
        }

        this.#gl.useProgram(this.#program);
    }

    async #createShader(type, shaderPath) {
        let source;
        try {
            const response = await fetch(shaderPath);
            if (!response.ok) {
                throw new Error(`Failed to load shader: ${response.statusText}`);
            }
            source = await response.text();
        } catch (error) {
            console.error(error);
            return null;
        }

        const shader = this.#gl.createShader(type);
        this.#gl.shaderSource(shader, source);
        this.#gl.compileShader(shader);
        if (!this.#gl.getShaderParameter(shader, this.#gl.COMPILE_STATUS)) {
            console.error(this.#gl.getShaderInfoLog(shader));
            this.#gl.deleteShader(shader);
            return null;
        }
        
        return shader;
    }

    #createProgram(gl, vertexShader, fragmentShader) {
        const program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        gl.linkProgram(program);
        if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
            console.error(gl.getProgramInfoLog(program));
            gl.deleteProgram(program);
            return null;
        }

        return program;
    }

    setPositionBuffer(positions) {
        const positionAttributeLocation = this.#gl.getAttribLocation(this.#program, "a_position");
        const positionBuffer = this.#gl.createBuffer();
        this.#gl.bindBuffer(this.#gl.ARRAY_BUFFER, positionBuffer);
        this.#gl.bufferData(this.#gl.ARRAY_BUFFER, new Float32Array(positions), this.#gl.STATIC_DRAW);
        this.#gl.enableVertexAttribArray(positionAttributeLocation);
        this.#gl.vertexAttribPointer(positionAttributeLocation, 2, this.#gl.FLOAT, false, 0, 0);
        
        this.#numVertices = positions.length;
    }

    setParams(params) {
        if (typeof params !== 'object') {
            throw new Error("Params deve ser um objeto.");
        }

        for (const [name, dv] of Object.entries(params)) {
            if (dv.length !== 2) {
                throw new Error("Dimensões ou valor inválidos.");
            }

            const [dimensions, value] = dv;
            const location = this.#gl.getUniformLocation(this.#program, name);
            switch (dimensions) {
                case 1: this.#gl.uniform1f(location, value); break;
                case 2: this.#gl.uniform2fv(location, value); break;
                case 3: this.#gl.uniform3fv(location, value); break;
                case 4: this.#gl.uniform4fv(location, value); break;
                default: throw new Error("Dimensões inválidas.");
            }
        }

        this.#gl.uniform1f(this.#gl.getUniformLocation(this.#program, "canvasWidth"), this.#canvasWidth);
        this.#gl.uniform1f(this.#gl.getUniformLocation(this.#program, "canvasHeight"), this.#canvasHeight);
    }

    clear(color) {
        this.#gl.clearColor(color.r, color.g, color.b, 1);
        this.#gl.clear(this.#gl.COLOR_BUFFER_BIT);
    }

    render() {
        this.#gl.drawArrays(this.#gl.TRIANGLES, 0, this.#numVertices);
    }
}
