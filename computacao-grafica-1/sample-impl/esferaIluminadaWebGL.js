// Seleciona o canvas e inicializa o contexto WebGL
const canvas = document.getElementById("canvas");
const gl = canvas.getContext("webgl");

if (!gl) {
    console.error("Seu navegador não suporta WebGL.");
}

// Configurações básicas da esfera, janela e luz
const wJanela = 4;
const hJanela = 3;
const dJanela = 5;
const rEsfera = 0.5;
const zCentroEsfera = -8;
const esfColor = [1.0, 0.0, 0.0];      // cor base da esfera
const bgColor = [0.39, 0.39, 0.39];    // cor do fundo

// Configurações da luz
const l_F = [0.7, 0.7, 0.7];         // intensidade da fonte de luz
const P_F = [0, 5, 0];               // posição da fonte de luz
const K_d = [1.0, 0.0, 0.0];         // coeficiente de difusão (vermelho)
const K_s = [1.0, 1.0, 1.0];         // coeficiente de especularidade (branco)
const m = 20.0;                      // shininess da esfera

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

// Variáveis para a esfera, câmera, e luz
uniform vec3 u_esfColor;
uniform vec3 u_bgColor;
uniform float u_rEsfera;
uniform vec3 u_centroEsfera;
uniform float u_dJanela;
uniform vec3 u_l_F;
uniform vec3 u_P_F;
uniform vec3 u_K_d;
uniform vec3 u_K_s;
uniform float u_m;

void main() {
    // Configuração do ponto de origem e direção do raio
    vec3 origem = vec3(0.0, 0.0, 0.0);
    vec3 direcao = vec3(gl_FragCoord.x / 400.0 - 1.0, 1.0 - gl_FragCoord.y / 300.0, -u_dJanela);
    direcao = normalize(direcao);

    // Equação para calcular a interseção com a esfera
    vec3 oc = origem - u_centroEsfera;
    float a = dot(direcao, direcao);
    float b = 2.0 * dot(oc, direcao);
    float c = dot(oc, oc) - u_rEsfera * u_rEsfera;
    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        // Sem interseção: fundo
        gl_FragColor = vec4(u_bgColor, 1.0);
    } else {
        // Calcula o ponto de interseção mais próximo
        float t = (-b - sqrt(discriminant)) / (2.0 * a);
        vec3 Pl = origem + t * direcao;
        vec3 n = normalize(Pl - u_centroEsfera);

        // Iluminação Difusa
        vec3 l = normalize(u_P_F - Pl);
        float diff = max(dot(l, n), 0.0);
        vec3 l_d = u_l_F * u_K_d * diff;

        // Iluminação Especular
        vec3 v = normalize(-direcao);
        vec3 r = reflect(-l, n);
        float spec = pow(max(dot(v, r), 0.0), u_m);
        vec3 l_e = u_l_F * u_K_s * spec;

        // Cor Final
        vec3 cor = l_d + l_e;
        gl_FragColor = vec4(cor, 1.0);
    }
}
`;

// Funções para criar shaders e programa WebGL
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

// Usa o programa WebGL e carrega as variáveis da esfera e luz
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

gl.enableVertexAttribArray(positionAttributeLocation);
gl.vertexAttribPointer(positionAttributeLocation, 2, gl.FLOAT, false, 0, 0);

// Uniforms para o shader
gl.uniform3fv(gl.getUniformLocation(program, "u_esfColor"), esfColor);
gl.uniform3fv(gl.getUniformLocation(program, "u_bgColor"), bgColor);
gl.uniform1f(gl.getUniformLocation(program, "u_rEsfera"), rEsfera);
gl.uniform3fv(gl.getUniformLocation(program, "u_centroEsfera"), [0, 0, zCentroEsfera]);
gl.uniform1f(gl.getUniformLocation(program, "u_dJanela"), dJanela);
gl.uniform3fv(gl.getUniformLocation(program, "u_l_F"), l_F);
gl.uniform3fv(gl.getUniformLocation(program, "u_P_F"), P_F);
gl.uniform3fv(gl.getUniformLocation(program, "u_K_d"), K_d);
gl.uniform3fv(gl.getUniformLocation(program, "u_K_s"), K_s);
gl.uniform1f(gl.getUniformLocation(program, "u_m"), m);

// Renderiza a cena
gl.clearColor(bgColor[0], bgColor[1], bgColor[2], 1);
gl.clear(gl.COLOR_BUFFER_BIT);
gl.drawArrays(gl.TRIANGLES, 0, 6);
