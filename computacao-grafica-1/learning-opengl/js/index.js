/**
 ##############  I N I T I A L I Z A T I O N  ##############
 */

    // 1) Get Canvas and WebGL Context
    {

        var canvas = document.querySelector("#c");

        var gl = canvas.getContext("webgl");

        if (!gl) {
            throw new Error("WebGL not supported");
        }
    }

    // 2) Create Shaders
    {
        var vertexShaderSource = document.querySelector("#vertex-shader-2d").text;
        var fragmentShaderSource = document.querySelector("#fragment-shader-2d").text;
            
        var vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
        var fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
    }
    

    // 3) Create Program
    var program = createProgram(gl, vertexShader, fragmentShader);
    

    // Vertex Shader code:
    /**
     * 
     *      attribute vec4 a_position;
     * 
     *      void main() {
     *          gl_Position = a_position;
     *      }
     * 
     */


    // 4) Look up the location of the "position" attribute ("a_position" on the vertex shader)
    var positionAttributeLocation = gl.getAttribLocation(program, "a_position");

    // 5) Create a buffer for the position attribute
    var positionBuffer = gl.createBuffer();

    // 6) Bind it to ARRAY_BUFFER (ARRAY_BUFFER is a global state)
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);

    // 7) Define the geometry. In this case, a triangle.
    var positions = [
        0, 0,       // first point: x = 0, y = 0
        0, 0.5,     // second point: x = 0, y = 0.5
        0.7, 0,     // third point: x = 0.7, y = 0
    ];

    // 8) Put data into the position buffer (which is bound to ARRAY_BUFFER)
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);


/**
 * ##############  R E N D E R  ##############
 */

    // 1) Resize the canvas to match the display size
    webglUtils.resizeCanvasToDisplaySize(gl.canvas);


    // 2) Set the viewport (the area of the canvas where we'll draw to) to match the canvas size.
    //    This tells WebGL the (-1 <-> +1) Clip Space maps to (0 <-> gl.canvas.width) for X and (0 <-> gl.canvas.height) for Y.
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height); 


    // 3) Clear the canvas
    {
        // 3.1) Set the clear color to black
        gl.clearColor(0, 0, 0, 0); 

        // 3.2) Clear the canvas
        gl.clear(gl.COLOR_BUFFER_BIT); 
    }


    // 4) Tell it to use our program (pair of shaders)
    gl.useProgram(program);


    // 5) Turn on the attribute (even though we already loaded the data into the buffer, it won't be used unless we turn on the attribute)
    gl.enableVertexAttribArray(positionAttributeLocation);

    
    // 6) Tell the attribute how to get data out of positionBuffer (ARRAY_BUFFER)
    {
        // We set size = 2. 
        // Attributes default to 0, 0, 0, 1 so this attribute will get its first 2 values (x and y) from our buffer. The z, and w will be the default 0 and 1 respectively.
        var size = 2;

        // Data is 32bit floats
        var type = gl.FLOAT;

        // Don't normalize the data
        var normalize = false;

        // 0 = move forward [size * sizeof(type)] each iteration to get the next position
        var stride = 0;

        // Start at the beginning of the buffer
        var offset = 0;
        
        gl.vertexAttribPointer(positionAttributeLocation, size, type, normalize, stride, offset)
    }


    /**
     * A hidden part of gl.vertexAttribPointer is that it binds the current ARRAY_BUFFER to the attribute.
     * In other words now this attribute is bound to positionBuffer.
     * That means we're free to bind something else to the ARRAY_BUFFER bind point.
     * The attribute will continue to use positionBuffer.
     */


    // 7) Ask WebGL to execute our GLSL program
    {
        // 7.1) We're drawing triangles
        var primitiveType = gl.TRIANGLES;

        // 7.2) Start at the beginning of the buffer
        var offset = 0;

        // 7.3) Draw 3 vertices
        var count = 3;

        gl.drawArrays(primitiveType, offset, count);
    }
