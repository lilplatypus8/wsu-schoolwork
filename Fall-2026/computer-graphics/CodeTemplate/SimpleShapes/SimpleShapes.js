var gl;
var myShaderProgramSquare;
var myShaderProgramTriangle;

function init() {

	var canvas=document.getElementById("gl-canvas");
	gl=WebGLUtils.setupWebGL(canvas);
	if (!gl) { alert( "WebGL is not available" ); }
	
	gl.viewport( 0, 0, 1024, 1024 );
	
	gl.clearColor( 0.5, 0.5, 0.5, 1.0 );
	
	gl.clear( gl.COLOR_BUFFER_BIT );
	
	myShaderProgramSquare =
	    initShaders( gl,"vertex-shader", "fragment-shader-square" );
	
	myShaderProgramTriangle =
	    initShaders( gl,"vertex-shader", "fragment-shader-triangle" );
	
	drawSquare();
	
	drawTriangle();
	
}
	
function drawSquare() {
    
	var point0 = vec2(0,0);
	var point1 = vec2(0,1);
	var point2 = vec2(1,0);
	var point3 = vec2(1,1);
	var arrayOfPointsForSquare = [point0, point1, point2, point3];
    
    var bufferIdSquare = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, bufferIdSquare );
    gl.bufferData( gl.ARRAY_BUFFER,
    				flatten(arrayOfPointsForSquare), gl.STATIC_DRAW );
    
    var myPosition = gl.getAttribLocation( myShaderProgramSquare, "myPosition" );
    gl.vertexAttribPointer( myPosition, 2, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( myPosition );
	
	gl.useProgram( myShaderProgramSquare );
    
	gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
    
}

function drawTriangle() {
	
	var point0 = vec2(0,0);
	var point1 = vec2(-1,0);
	var point2 = vec2(0,-1);
	var arrayOfPointsForTriangle = [point0, point1, point2];
	
	var bufferIdTriangle = gl.createBuffer();
	gl.bindBuffer( gl.ARRAY_BUFFER, bufferIdTriangle);
	gl.bufferData( gl.ARRAY_BUFFER,
					flatten(arrayOfPointsForTriangle), gl.STATIC_DRAW);
	
	var myPosition = gl.getAttribLocation(myShaderProgramTriangle, "myPosition");
	gl.vertexAttribPointer(myPosition, 2, gl.FLOAT, false, 0, 0);
	gl.enableVertexAttribArray(myPosition);
	
	gl.useProgram( myShaderProgramTriangle );
	
	gl.drawArrays(gl.TRIANGLES, 0, 3);
	
}