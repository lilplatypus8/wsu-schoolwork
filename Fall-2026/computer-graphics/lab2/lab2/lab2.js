var gl;
var shaderProgramSquare;
var thetaJS;
var thetaUniform;
var stopStartFlag;

var moveX_JS;
var moveY_JS;
var moveUniform;
var inc = 0.002;
var directionX = inc;
var directionY = 0.0;
var speed = 1;
var canvasSize = 1024;

function init() {
    // Set up the canvas
    var canvas=document.getElementById("gl-canvas");
    gl=WebGLUtils.setupWebGL(canvas);
    if (!gl) { alert( "WebGL is not available" ); }
    
    // Set up the viewport
    gl.viewport( 0, 0, canvasSize, canvasSize );   // x, y, width, height
    
    
    // Set up the background color
    gl.clearColor( 0.0, 0.0, 0.5, 0.5 );
    
	
    myShaderProgramPolygon = initShaders(gl,"vertex-shader", "fragment-shader");
    gl.useProgram( myShaderProgramPolygon );
    
	thetaJS = 0.0;
	thetaUniform = gl.getUniformLocation( myShaderProgramPolygon, "theta" );
    gl.uniform1f( thetaUniform, thetaJS );
	stopStartFlag = 1.0;
	
	moveX_JS = 0.0;
	moveY_JS = 0.0;
	moveUniform = gl.getUniformLocation( myShaderProgramPolygon, "move" );
	gl.uniform2f( moveUniform, moveX_JS, moveY_JS );
	
    // Force the WebGL context to clear the color buffer
    gl.clear( gl.COLOR_BUFFER_BIT );
    
    setupShape();
    
    //setInterval( drawSquare, 120 );
	drawShape();
}

function setupShape() {
    
	var polygonPointsArray = [];

	// Center of polygon relative to center of canvas
	var centerX = 0;
	var centerY = 0;

	var n = 5; // Number of sides
	var sideLength = 0.25;
	var intAngle = (n-2) * 180 / n; // Calculated interior angle (degrees)

	// Add x-y pair of points calculated by dividing circle into n wedges
	// x is determined by cosine of circle's wedge and y by sine of circle's wedge
	for (var i = 0; i < n; i++) {
		polygonPointsArray.push(vec2(centerX + sideLength * Math.cos(i * 2 * Math.PI / n), centerY + sideLength * Math.sin(i * 2 * Math.PI / n)));
	}

	polygonPointsArray.push(polygonPointsArray[0]); // Add first point again to close polygon
    
    // Create a buffer on the graphics card,
    // and send array to the buffer for use
    // in the shaders
    var bufferId = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, bufferId );
    gl.bufferData( gl.ARRAY_BUFFER,
					 flatten(polygonPointsArray), gl.STATIC_DRAW );
    
    // Create a pointer that iterates over the
    // array of points in the shader code
	var myPosition = gl.getAttribLocation(myShaderProgramPolygon, "myPosition");
	gl.vertexAttribPointer(myPosition, 2, gl.FLOAT, false, 0, 0);
	gl.enableVertexAttribArray(myPosition);    
}

function drawShape() {
	moveX_JS += directionX * speed;
	moveY_JS += directionY * speed;
	
	gl.clear( gl.COLOR_BUFFER_BIT );
	thetaJS += (0.01 * stopStartFlag);
	gl.uniform1f( thetaUniform, thetaJS );
	gl.uniform2f( moveUniform, moveX_JS, moveY_JS );
    gl.drawArrays( gl.TRIANGLE_FAN, 0, 5);	
    requestAnimFrame( drawShape );
}

function startAnim() {
	stopStartFlag = 1.0;
}

function stopAnim() {
	stopStartFlag = 0.0;
}

function increase() {
	speed *= 2.0;
}

function decrease() {
	speed *= 0.5;
}

function moveSquare(event) {
	var canvasX = event.clientX;
	var canvasY = event.clientY;
	
	moveX_JS =   2.0 * canvasX/canvasSize - 1.0;
	moveY_JS = -(2.0 * canvasY/canvasSize - 1.0);
	gl.uniform2f( moveUniform, moveX_JS, moveY_JS );
}

function moveSquareKeys(event) {
	var theKeyCode = event.keyCode;
	
	if ( theKeyCode == 65 ) {
		directionX = -inc;
		directionY = 0.0;
	} else if ( theKeyCode == 68 ) {
		directionX = inc;
		directionY = 0.0;
	} else if ( theKeyCode == 83 ) {
		directionX = 0.0;
		directionY = -inc;
	} else if ( theKeyCode == 87 ) {
		directionX = 0.0;
		directionY = inc;
	}
		
}
