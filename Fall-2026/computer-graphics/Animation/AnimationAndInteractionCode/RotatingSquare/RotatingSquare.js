var gl;
var shaderProgramSquare;
var thetaJS;
var thetaUniform;
var stopStartFlag;

var moveX_JS;
var moveY_JS;
var moveUniform;

function init() {
    // Set up the canvas
    var canvas=document.getElementById("gl-canvas");
    gl=WebGLUtils.setupWebGL(canvas);
    if (!gl) { alert( "WebGL is not available" ); }
    
    // Set up the viewport
    gl.viewport( 0, 0, 512, 512 );   // x, y, width, height
    
    
    // Set up the background color
    gl.clearColor( 1.0, 0.0, 0.0, 1.0 );
    
	
    shaderProgramSquare = initShaders( gl, "vertex-shader-square",
                                      "fragment-shader-square" );
    gl.useProgram( shaderProgramSquare );
    
	thetaJS = 0.0;
	thetaUniform = gl.getUniformLocation( shaderProgramSquare, "theta" );
    gl.uniform1f( thetaUniform, thetaJS );
	stopStartFlag = 1.0;
	
	moveX_JS = 0.0;
	moveY_JS = 0.0;
	moveUniform = gl.getUniformLocation( shaderProgramSquare, "move" );
	gl.uniform2f( moveUniform, moveX_JS, moveY_JS );
	
    // Force the WebGL context to clear the color buffer
    gl.clear( gl.COLOR_BUFFER_BIT );
    
    setupSquare();
    
    //setInterval( drawSquare, 120 );
	drawSquare();
}

function setupSquare() {
    
    // Enter array set up code here
    var p0 = vec2( .2, .2 );
    var p1 = vec2( -.2, .2 );
    var p2 = vec2( -.2, -.2 );
    var p3 = vec2( .2, -.2 );
    var arrayOfPoints = [p0, p1, p2, p3];
    
    // Create a buffer on the graphics card,
    // and send array to the buffer for use
    // in the shaders
    var bufferId = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
    gl.bufferData( gl.ARRAY_BUFFER, flatten(arrayOfPoints), gl.STATIC_DRAW );
    
    // Create a pointer that iterates over the
    // array of points in the shader code
    var myPositionAttribute = gl.getAttribLocation( shaderProgramSquare, "myPosition" );
    gl.vertexAttribPointer( myPositionAttribute, 2, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( myPositionAttribute );    
}

function drawSquare() {
	
	gl.clear( gl.COLOR_BUFFER_BIT );
	thetaJS += (0.03 * stopStartFlag);
	gl.uniform1f( thetaUniform, thetaJS );	
    gl.drawArrays( gl.TRIANGLE_FAN, 0, 4 );	
    requestAnimFrame( drawSquare );
}

function stopOrStartAnim() {
	if (stopStartFlag < 0.5) {
		stopStartFlag = 1.0;
	} else {
		stopStartFlag = 0.0;
	}
		
}

function moveSquare(event) {
	var canvasX = event.clientX;
	var canvasY = event.clientY;
	
	moveX_JS =   2.0 * canvasX/512.0 - 1.0;
	moveY_JS = -(2.0 * canvasY/512.0 - 1.0);
	gl.uniform2f( moveUniform, moveX_JS, moveY_JS );
}

function moveSquareKeys(event) {
	var theKeyCode = event.keyCode;
	var inc = 0.01;
	
	if ( theKeyCode == 65 ) {
		moveX_JS -= inc;
	} else if ( theKeyCode == 68 ) {
		moveX_JS += inc;
	} else if ( theKeyCode == 83 ) {
		moveY_JS -= inc;
	} else if ( theKeyCode == 87 ) {
		moveY_JS += inc;
	}
		
	
	gl.uniform2f( moveUniform, moveX_JS, moveY_JS );
}
