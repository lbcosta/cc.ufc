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
    