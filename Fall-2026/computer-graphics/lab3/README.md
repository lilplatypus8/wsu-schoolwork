# Lab 3: Three-dimensional transformations

The model is an octahedron. Each face has a different uniform color according
to option 2b (blue, orange, red, cyan, yellow, purple, green, magenta).
The transformation matrices are all initialized in a single
function in the JS file. This includes the matrices for scaling,
rotation around each of the three axes, translation, and projection.
The composition order is as follows: scale -> rotateX -> rotateY -> rotateZ -> translate (-> projection). 

The controls as well as the amounts that they rotate/scale/translate the octahedron
by are shown below.

| Key | Effect per keydown |
| --- | --- |
| x | Rotate around X by 5 degrees |
| y | Rotate around Z by 5 degrees |
| z | Rotate around Z by 5 degrees |
| Shift + X / Y / Z | Rotate around axis by -5 degrees |
| Left / Right arrow | Translate in X direction by -0.1 / +0.1 units |
| Down / Up arrow | Translate in Y direction by -0.1 / +0.1 units |
| S | Scale in X axis by 1.05 |
| D | Scale in Y axis by 1.05 |
| Shift + S / D | Scale in X/Y axis by 1/1.05 (~0.95) |
| R or Reset button | Restore initial state |
