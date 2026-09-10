function drawTriangle() {
	
	var canvas=document.getElementById("gl-canvas");
	var gl=WebGLUtils.setupWebGL(canvas);
	if (!gl) { alert( "WebGL is not available" ); }
	
	gl.viewport( 0, 0, 1024, 1024 );
	
	gl.clearColor( 1.0, 0.0, 0.0, 1.0 );
	
	gl.clear( gl.COLOR_BUFFER_BIT );
	
	var point0 = vec2(0,0);
	var point1 = vec2(0,1);
	var point2 = vec2(1,0);
	
	var arrayOfPointsForTriangle = [point0, point1, point2];
	
	var bufferId = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, bufferId);
	gl.bufferData(gl.ARRAY_BUFFER, flatten(arrayOfPointsForTriangle), gl.STATIC_DRAW);
	
	var myShaderProgram = initShaders(gl, "vertex-shader", "fragment-shader");
	gl.useProgram(myShaderProgram);
	
	var myPosition = gl.getAttribLocation(myShaderProgram, "myPosition");
	gl.vertexAttribPointer(myPosition, 2, gl.FLOAT, false, 0, 0);
	gl.enableVertexAttribArray(myPosition);
	
	gl.drawArrays(gl.TRIANGLES, 0, 3);
	
}