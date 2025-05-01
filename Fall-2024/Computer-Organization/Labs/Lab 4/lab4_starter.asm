;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x3000
;	Your main() function starts here
LD R6, STACK_PTR			;	LOAD the pointer to the bottom of the stack in R6	(R6 = x6000)
LEA R4, GLOBAL_VARS			;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))

JSR SUMOFSQUARES			;	CALL sumOfSquares() function

HALT

GLOBAL_VARS					;	Your global variables start here
MAX_ARRAY_SIZE	.FILL x0005	;	MAX_ARRAY_SIZE is a global variable and predefined
ARRAY_POINTER	.FILL x0002	;	ARRAY_POINTER points to the top of your array (5 elements)
				.FILL x0003
				.FILL x0005
				.FILL x0000
				.FILL x0001
STACK_PTR		.FILL x6000	;	STACK_PTR is a pointer to the bottom of the stack (x6000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SUMOFSQUARES
;	Your sumOfSquares() function starts here
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SQUARE
;	Your square() function starts here
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.END