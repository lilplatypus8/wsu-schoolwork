Josiah Schmitz
Lab 2 - Computer Graphics

I set up the polygon to be a regular pentagon that is centered at the origin.
The rotation is started automatically and is accomplished by applying a rotation matrix to the polygon's coordinates in lab2.html, using thetaJS for the angle of rotation every frame.
 
The keyboard-controlled movement is done by incrementing or decrementing the x or y coordinates of the polygon's vertices based on the corresponding keys pressed.

The changing speed of the movement is achieved by multiplying the speed variable (which is multiplied by the directional change of the shape) by either 2 or 0.5 when the corresponding button is pressed.

The position change by clicking the canvas is done by simply setting the x and y coordinates of the polygon's center to the mouse click position on the canvas.

The rotation is stopped or started by toggling the startStopFlag variable when the corresponding button is pressed.