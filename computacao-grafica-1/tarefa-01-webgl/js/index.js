function createShader(gl, type, source) {
    var shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    var success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
    if (success) {
        return shader;
    }

    console.log(gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);
}

function createProgram(gl, vertexShader, fragmentShader) {
    var program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    var success = gl.getProgramParameter(program, gl.LINK_STATUS);
    if (success) {
        return program;
    }

    console.log(gl.getProgramInfoLog(program));
    gl.deleteProgram(program);
}


/**
 * INITIALIZATION
 */
    var canvas = document.querySelector("#c");

    var gl = canvas.getContext("webgl");
        if (!gl) {
        // no webgl for you!
        throw new Error("WebGL not supported");
        }

    // CREATE SHADERS
    var vertexShaderSource = document.querySelector("#vertex-shader-2d").text;
    var fragmentShaderSource = document.querySelector("#fragment-shader-2d").text;

    var vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
    var fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);

    // CREATE PROGRAM
    var program = createProgram(gl, vertexShader, fragmentShader);

    // LOOK UP THE LOCATION OF THE "POSITION ATTRIBUTE"
    /*
    Looking up attribute locations (and uniform locations) is something you should do during initialization, not in your render loop.
    */
    var positionAttributeLocation = gl.getAttribLocation(program, "a_position");

    // CREATE A BUFFER FOR THE POSITION ATTRIBUTE
    var positionBuffer = gl.createBuffer();

    // BIND IT TO ARRAY_BUFFER (ARRAY_BUFFER IS A GLOBAL STATE)
    /*
    WebGL lets us manipulate many WebGL resources on global bind points.
    You can think of bind points as internal global variables inside WebGL.
    First you bind a resource to a bind point.
    Then, all other functions refer to the resource through the bind point.
    So, let's bind the position buffer.
    */
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);

    // PUT DATA INTO THE POSITION BUFFER
    /*
    Now that we have a buffer we need to put data into it.
    We do that by calling gl.bufferData.
    */

    // three 2d points
    var positions = [
        0, 0,
        0, 0.5,
        0.7, 0,
        ];

    // bufferData(target, data, usage)
    /* 
        Since we binded the buffer to the ARRAY_BUFFER bind point, we're telling WebGL that this data is for the positionAttribute.
        We're also telling WebGL the data is a Float32Array, because that's what our positions are.
        The usage hint is a performance hint that tells WebGL how you expect to use the data.
        WebGL can use this hint to optimize performance.
        In this case we're saying the data won't change.
        This is a good default because it's the least restrictive.
    */
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);

/**
 * END OF INITIALIZATION
 */


/**
 * RENDER
 */

    webglUtils.resizeCanvasToDisplaySize(gl.canvas);

    // This tells WebGL the -1 +1 clip space maps to 0 <-> gl.canvas.width for x and 0 <-> gl.canvas.height for y.
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

    // Clear the canvas
    gl.clearColor(0, 0, 0, 0); // gl.clearColor is a function that sets the color that WebGL uses to clear the canvas.
    gl.clear(gl.COLOR_BUFFER_BIT); // gl.COLOR_BUFFER_BIT is a buffer that holds the color of the canvas.

    // Tell it to use our program (pair of shaders)
    gl.useProgram(program);

    // Turn on the attribute
    // enableVertexAttribArray tells WebGL which position to pull from the buffer.
    // It's like a pointer to the buffer.
    gl.enableVertexAttribArray(positionAttributeLocation);

    // Bind the position buffer.
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    
    // Tell the attribute how to get data out of positionBuffer (ARRAY_BUFFER)
    var size = 2;          // 2 components per iteration
    var type = gl.FLOAT;   // the data is 32bit floats
    var normalize = false; // don't normalize the data
    var stride = 0;        // 0 = move forward size * sizeof(type) each iteration to get the next position
    var offset = 0;        // start at the beginning of the buffer
    gl.vertexAttribPointer(positionAttributeLocation, size, type, normalize, stride, offset)

    /**
     * A hidden part of gl.vertexAttribPointer is that it binds the current ARRAY_BUFFER to the attribute.
     * In other words now this attribute is bound to positionBuffer.
     * That means we're free to bind something else to the ARRAY_BUFFER bind point.
     * The attribute will continue to use positionBuffer.
     * 
     * 
     * note that from the point of view of our GLSL vertex shader the a_position attribute is a vec4.
     * vec4 is a 4 float value. In JavaScript you could think of it something like a_position = {x: 0, y: 0, z: 0, w: 0}.
     * Above we set size = 2. Attributes default to 0, 0, 0, 1 so this attribute will get its first 2 values (x and y) from our buffer.
     * The z, and w will be the default 0 and 1 respectively.
     * 
     * After all that we can finally ask WebGL to execute our GLSL program.
     */

    var primitiveType = gl.TRIANGLES;
    var offset = 0;
    var count = 3;
    gl.drawArrays(primitiveType, offset, count);


/**
 * END OF RENDER
 */