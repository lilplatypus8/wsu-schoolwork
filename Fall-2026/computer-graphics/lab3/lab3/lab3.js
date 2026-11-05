
function init() {
    var canvas = document.getElementById("gl-canvas");
    gl = WebGLUtils.setupWebGL(canvas);

	if (!gl) { alert( "WebGL is not available" ); }

	gl.clearColor(0.0, 0.0, 0.0, 1.0);

    myShaderProgram =
		initShaders( gl, "vertex-shader", "fragment-shader" );
	gl.useProgram(myShaderProgram);

    gl.enable(gl.DEPTH_TEST);

    return {canvas, gl, myShaderProgram};
}

function transformationMatrices(state, aspect) {
    const radians = state.angles.map(
        degrees => degrees * Math.PI / 180
    );

    const [cx, cy, cz] = radians.map(Math.cos);
    const [sx, sy, sz] = radians.map(Math.sin);

    return {
        uScale: [
            state.size[0], 0,             0, 0,
            0,             state.size[1], 0, 0,
            0,             0,             1, 0,
            0,             0,             0, 1
        ],

        uRotateX: [
            1,  0,   0, 0,
            0, cx,  sx, 0,
            0, -sx, cx, 0,
            0,  0,   0, 1
        ],

        uRotateY: [
            cy, 0, -sy, 0,
             0, 1,   0, 0,
            sy, 0,  cy, 0,
             0, 0,   0, 1
        ],

        uRotateZ: [
             cz, sz, 0, 0,
            -sz, cz, 0, 0,
              0,  0, 1, 0,
              0,  0, 0, 1
        ],

        uTranslation: [
            1,                 0,                 0, 0,
            0,                 1,                 0, 0,
            0,                 0,                 1, 0,
            state.position[0], state.position[1], 0, 1
        ],

        // Orthographic view:
        // X = +/-3 * aspect, Y = +/-3, Z = +/-10.
        uProjection: [
            1 / (3 * aspect), 0,     0,       0,
            0,                1 / 3, 0,       0,
            0,                0,     -1 / 10, 0,
            0,                0,     0,       1
        ]
    };
}

function initialState() {
    return {
        angles: [10, 20, 30],
        position: [0, 0],
        size: [1, 1]
    };
}

// Each keydown, including held-key repeats, performs one step.
function applyKey(state, key, reverse) {
    const rotationAxes = {
        88: 0, // x
        89: 1, // y
        90: 2  // z
    };

    const axis = rotationAxes[key];

    if (axis !== undefined) {
		// rotate by 5 degrees per keydown depending on whether shift is held down
        const rotationStep = reverse ? -5 : 5; 

        state.angles[axis] =
            (state.angles[axis] + rotationStep) % 360;

        return true;
    }

    switch (key) {
        case 37: // left arrow
            state.position[0] -= 0.1;
            break;

        case 39: // right arrow
            state.position[0] += 0.1;
            break;

        case 38: // up arrow
            state.position[1] += 0.1;
            break;

        case 40: // down arrow
            state.position[1] -= 0.1;
            break;

        case 83: // s key
        case 65: { // a key
            const scaleAxis = key === 83 ? 0 : 1;
            const scaleFactor = reverse ? 1 / 1.05 : 1.05;
            const newSize = state.size[scaleAxis] * scaleFactor;

            state.size[scaleAxis] = Math.max(
                0.1,
                Math.min(5, newSize)
            );

            break;
        }

        default:
            return false;
    }

    return true;
}

function main() {
    const app = init();

    const { canvas, gl, myShaderProgram } = app;

    const vertices = [
        [ 0,  1,  0],
        [ 0, -1,  0],
        [ 1,  0,  0],
        [ 0,  0,  1],
        [-1,  0,  0],
        [ 0,  0, -1]
    ];

    const faces = [
        [0, 2, 3],
        [0, 3, 4],
        [0, 4, 5],
        [0, 5, 2],
        [1, 3, 2],
        [1, 4, 3],
        [1, 5, 4],
        [1, 2, 5]
    ];

    const colors = [
        [1.00, 0.25, 0.30, 1],
        [1.00, 0.60, 0.12, 1],
        [1.00, 0.90, 0.20, 1],
        [0.25, 0.85, 0.40, 1],
        [0.10, 0.80, 0.90, 1],
        [0.20, 0.40, 1.00, 1],
        [0.65, 0.30, 0.95, 1],
        [1.00, 0.35, 0.75, 1]
    ];

    // Expand the indexed faces into a flat list of coordinates.
    const points = faces.flatMap(
        face => face.flatMap(index => vertices[index])
    );

    const positionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.bufferData( gl.ARRAY_BUFFER, new Float32Array(points), gl.STATIC_DRAW);

    const positionLocation = gl.getAttribLocation( myShaderProgram, "myPosition" );
    gl.vertexAttribPointer( positionLocation, 3, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(positionLocation);

    let state = initialState();

    const locations = {};
    const matrices = transformationMatrices(state, 1);

    for (const name of Object.keys(matrices)) {
        locations[name] = gl.getUniformLocation(myShaderProgram, name);
    }

    const faceColorLocation = gl.getUniformLocation(
        myShaderProgram,
        "uFaceColor"
    );
	
	function render() {
	    gl.viewport(0, 0, canvas.width, canvas.height);
	    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

	    const aspect = canvas.width / canvas.height;
	    const currentMatrices = transformationMatrices(state, aspect);

	    for (const [name, matrix] of Object.entries(currentMatrices)) {
	        gl.uniformMatrix4fv(
	            locations[name],
	            false,
	            new Float32Array(matrix)
	        );
	    }

	    // Draw each triangle with its own uniform color.
	    faces.forEach((face, index) => {
	        gl.uniform4fv(faceColorLocation, colors[index]);
	        gl.drawArrays(gl.TRIANGLES, index * 3, 3);
	    });

	}

	function reset() {
	    state = initialState();
	    render();
	}

    document.getElementById("reset").addEventListener("click", reset);

    window.addEventListener("keydown", event => {

        const key = event.keyCode

        if (key == 82) { // r key
            reset();
        } else if (applyKey(state, key, event.shiftKey)) {
            render();
        }
    });

    render();
}

window.addEventListener("load", main);
