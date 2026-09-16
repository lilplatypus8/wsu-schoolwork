// Josiah Schmitz

var gl;
var myShaderProgramSquare;
var myShaderProgramTriangle;

function init() {

	
	var canvas=document.getElementById("gl-canvas");
	gl=WebGLUtils.setupWebGL(canvas);
	if (!gl) { 
		alert( "WebGL is not available" );
	}
	
	gl.viewport(0, 0, 1024, 1024);
	gl.clearColor(0.5, 0.5, 0.5, 1.0); // Gray
	gl.clear(gl.COLOR_BUFFER_BIT);
	
	// More than 4 sides
	myShaderProgramPolygon =
	    initShaders(gl,"vertex-shader", "fragment-shader-polygon");
	
	myShaderProgramTriangle =
	    initShaders(gl,"vertex-shader", "fragment-shader-triangle");
		
	myShaderProgramEllipse =
		initShaders(gl,"vertex-shader", "fragment-shader-ellipse");
	
	drawPolygon();
	drawTriangle();
	drawEllipse();
	
}
	
function drawPolygon() {
	
	var polygonPointsArray = [];
	
	// Center of polygon relative to center of canvas
	var centerX = 0.5;
	var centerY = 0.5;
	
	var n = 6; // Number of sides
	var sideLength = 0.25;
	var intAngle = (n-2) * 180 / n; // Calculated interior angle (degrees)
	
	// Add x-y pair of points calculated by dividing circle into n wedges
	// x is determined by cosine of circle's wedge and y by sine of circle's wedge
	for (var i = 0; i < n; i++) {
		polygonPointsArray.push(vec2(centerX + sideLength * Math.cos(i * 2 * Math.PI / n), centerY + sideLength * Math.sin(i * 2 * Math.PI / n)));
	}
	
	polygonPointsArray.push(polygonPointsArray[0]); // Add first point again to close polygon

    var bufferIdSquare = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferIdSquare);
    gl.bufferData(gl.ARRAY_BUFFER,
    				flatten(polygonPointsArray), gl.STATIC_DRAW);
    
    var myPosition = gl.getAttribLocation(myShaderProgramPolygon, "myPosition");
    gl.vertexAttribPointer(myPosition, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(myPosition);
	
	gl.useProgram(myShaderProgramPolygon);
	gl.drawArrays(gl.TRIANGLE_FAN, 0, n + 1); // Add extra point for the center point
    
}

function drawTriangle() {
	
	// Draw right triangle in bottom-left quadrant of canvas
	var point0 = vec2(-0.25,-0.25);
	var point1 = vec2(-0.75,-0.25);
	var point2 = vec2(-0.25,-0.75);
	var trianglePointsArray = [point0, point1, point2, point0]; // Re-adding point0 to close triangle
	
	var bufferIdTriangle = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, bufferIdTriangle);
	gl.bufferData(gl.ARRAY_BUFFER,
					flatten(trianglePointsArray), gl.STATIC_DRAW);
	
	var myPosition = gl.getAttribLocation(myShaderProgramTriangle, "myPosition");
	gl.vertexAttribPointer(myPosition, 2, gl.FLOAT, false, 0, 0);
	gl.enableVertexAttribArray(myPosition);
	
	gl.useProgram(myShaderProgramTriangle);
	gl.drawArrays(gl.LINE_STRIP, 0, 4);
	
}

function drawEllipse() {
    
    var ellipsePointsArray = [];
  
	var n = 50; // Number of points in eclipse
	var thetastep = 2.0 * Math.PI / n; // Angle of circle wedge
	var a = 0.5; // Horizontal offset of the ellipse center
	var b = -0.5; // Vertical offset of the ellipse center
	var c = 0.2; // Horizontal radius of the ellipse
	var d = 0.1; // Vertical radius of the ellipse
	
	// Add center point first for TRIANGLE_FAN
	ellipsePointsArray.push(vec2(a, b));
	
	// Calculates x and y using cosine and sine of theta
	for (var i = 0; i <= n; i++) {
		var theta = i * thetastep;
		var x = a + c * Math.cos(theta);
		var y = b + d * Math.sin(theta);
		var p = vec2(x, y);
		ellipsePointsArray.push(p);
	}
	
	var bufferIdEllipse = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, bufferIdEllipse);
	gl.bufferData(gl.ARRAY_BUFFER,
					flatten(ellipsePointsArray), gl.STATIC_DRAW);

	var myPosition = gl.getAttribLocation(myShaderProgramEllipse, "myPosition");
	gl.vertexAttribPointer(myPosition, 2, gl.FLOAT, false, 0, 0);
	gl.enableVertexAttribArray(myPosition);
    
    gl.useProgram(myShaderProgramEllipse);
    gl.drawArrays(gl.TRIANGLE_FAN, 0, n + 2); // Add two points for center and fully connecting eclipse
}