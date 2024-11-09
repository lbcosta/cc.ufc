// Seleciona o canvas e inicializa o contexto WebGL
const canvas = document.getElementById("canvas");
const gl = canvas.getContext("webgl");

if (!gl) {
    console.error("Seu navegador não suporta WebGL.");
}

// Configurações básicas da esfera e janela
const wJanela = 4;
const hJanela = 3;
const dJanela = 5;
const rEsfera = 1.5;
const zCentroEsfera = -8;
const esfColor = [1.0, 0.0, 0.0];      // cor da esfera (vermelho)
const bgColor = [0.39, 0.39, 0.39];    // cor do fundo (cinza)

// Código do Vertex Shader
const vertexShaderSource = `
attribute vec4 a_position;
void main() {
    gl_Position = a_position;
}
`;

// Código do Fragment Shader
const fragmentShaderSource = `
precision mediump float;

// Variáveis para a esfera e a câmera
uniform vec3 u_esfColor;
uniform vec3 u_bgColor;
uniform float u_rEsfera;
uniform vec3 u_centroEsfera;
uniform float u_dJanela;

void main() {
    // Direção do raio
    vec3 origem = vec3(0.0, 0.0, 0.0);
    vec3 direcao = vec3(gl_FragCoord.x / 400.0 - 1.0, 1.0 - gl_FragCoord.y / 300.0, -u_dJanela);
    
    // Normaliza a direção
    direcao = normalize(direcao);

    // Calcula interseção do raio com a esfera
    vec3 oc = origem - u_centroEsfera;
    float a = dot(direcao, direcao);
    float b = 2.0 * dot(oc, direcao);
    float c = dot(oc, oc) - u_rEsfera * u_rEsfera;
    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        // Sem interseção, retorna cor do fundo
        gl_FragColor = vec4(u_bgColor, 1.0);
    } else {
        // Interseção, retorna cor da esfera
        gl_FragColor = vec4(u_esfColor, 1.0);
    }
}
`;

// Funções auxiliares para compilação de shaders
function createShader(gl, type, source) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
        console.error(gl.getShaderInfoLog(shader));
        gl.deleteShader(shader);
        return null;
    }
    return shader;
}

function createProgram(gl, vertexShader, fragmentShader) {
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

// Compilação dos shaders e criação do programa
const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
const program = createProgram(gl, vertexShader, fragmentShader);

// Configura o WebGL para usar nosso programa e os dados da esfera
gl.useProgram(program);

const positionAttributeLocation = gl.getAttribLocation(program, "a_position");
const positionBuffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
    -1, -1,
     1, -1,
    -1,  1,
    -1,  1,
     1, -1,
     1,  1
]), gl.STATIC_DRAW);

// Configuração da geometria e do buffer de posições
gl.enableVertexAttribArray(positionAttributeLocation);
gl.vertexAttribPointer(positionAttributeLocation, 2, gl.FLOAT, false, 0, 0);

// Passando variáveis uniformes para o shader
gl.uniform3fv(gl.getUniformLocation(program, "u_esfColor"), esfColor);
gl.uniform3fv(gl.getUniformLocation(program, "u_bgColor"), bgColor);
gl.uniform1f(gl.getUniformLocation(program, "u_rEsfera"), rEsfera);
gl.uniform3fv(gl.getUniformLocation(program, "u_centroEsfera"), [0, 0, zCentroEsfera]);
gl.uniform1f(gl.getUniformLocation(program, "u_dJanela"), dJanela);

// Renderiza a cena
gl.clearColor(bgColor[0], bgColor[1], bgColor[2], 1);
gl.clear(gl.COLOR_BUFFER_BIT);
gl.drawArrays(gl.TRIANGLES, 0, 6);
