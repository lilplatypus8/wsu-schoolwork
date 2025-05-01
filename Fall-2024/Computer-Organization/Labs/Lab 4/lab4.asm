.ORIG x3000
;	Your main() function starts here
LD R6, STACK_PTR			;	LOAD the pointer to the bottom of the stack in R6	(R6 = x6000)
LEA R4, GLOBAL_VARS

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

; push and save SOS array pointer
ADD R6, R6, #-1 ; *array
LEA R0, ARRAY_POINTER
STR R0, R6, #0

; push and save int total
ADD R6, R6, #-1
AND R0, R0, #0
STR R0, R6, #0

; push and save SOS a[]
ADD R6, R6, #-1
LEA R0, ARRAY_POINTER
STR R0, R6, #0

; push and save SOS arraySize
ADD R6, R6, #-1
LDR R0, R4, #0
STR R0, R6, #0

; push SOS return value
ADD R6, R6, #-1

JSR SUMOFSQUARES ;	CALL sumOfSquares() function

; set R0 = SOS return value and save it as total
LDR R0, R6, #0 
STR R0, R5, #-2

; pop sos's rv
ADD R6, R6, #1 

; pop arraySize
ADD R6, R6, #1 

; pop a[]
ADD R6, R6, #1 

; set R0 = total and save it as main's return value
LDR R0, R5, #-2 
STR R0, R5, #2 

; pop total
ADD R6, R6, #1 

; pop *array
ADD R6, R6, #1 

; restore and pop prev frame pointer
LDR R5, R6, #0 
ADD R6, R6, #1 

; restore and pop prev return address
LDR R7, R6, #0 
ADD R6, R6, #1 

HALT

RESULT_MESSAGE .STRINGZ "TOTAL: "
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

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

; push R0
ADD R6, R6, #-1 
STR R0, R6, #0

; push R1
ADD R6, R6, #-1 
STR R1, R6, #0

; push R2
ADD R6, R6, #-1 
STR R2, R6, #0

; push R3
ADD R6, R6, #-1 
STR R3, R6, #0

; push int counter
ADD R6, R6, #-1 
AND R0, R0, #0
STR R0, R6, #0

; push int sum
ADD R6, R6, #-1
STR R0, R6, #0

; start subroutine logic

; load a[] (array location)
LDR R0, R5, #4 

; load arraySize and take two's comp
LDR R1, R5, #3 
NOT R1, R1
ADD R1, R1, #1 

LOOP

    ; push int x and set to a[counter]
    ADD R6, R6, #-1
    LDR R2, R0, #0
    STR R2, R6, #0 
    
    ; push SQUARE's return value
    ADD R6, R6, #-1
    
    JSR SQUARE
    
    ; R2 = sum, R3 = x^2
    LDR R2, R6, #2 
    LDR R3, R6, #0 
    
    ; sum = curr sum + x^2
    ADD R2, R2, R3 
    STR R2, R6, #2 
    
    ; pop SQUARE's return value
    ADD R6, R6, #1 
    
    ; pop x
    ADD R6, R6, #1 
    
    ; a[]++
    ADD R0, R0, #1 
    
    ; decrease arraySize two's comp
    
    ADD R1, R1, #1 
BRnp LOOP

; end subroutine logic

; R0 = sum and save as subroutine's return value
LDR R0, R6, #0 
STR R0, R5, #2 

; pop sum
ADD R6, R6, #1
    
; pop counter
ADD R6, R6, #1
    
; restore and pop R3
LDR R3, R6, #0
ADD R6, R6, #1
    
; restore and pop R2
LDR R2, R6, #0
ADD R6, R6, #1
    
; restore and pop R1
LDR R1, R6, #0
ADD R6, R6, #1
    
; restore and pop R0
LDR R0, R6, #0
ADD R6, R6, #1

; restore and pop prev frame pointer
LDR R5, R6, #0 
ADD R6, R6, #1

; restore and pop return addr
LDR R7, R6, #0 
ADD R6, R6, #1

RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SQUARE

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

; push R0
ADD R6, R6, #-1 
STR R0, R6, #0

; push R1
ADD R6, R6, #-1 
STR R1, R6, #0

; push R2
ADD R6, R6, #-1 
STR R2, R6, #0

; push R3
ADD R6, R6, #-1 
STR R3, R6, #0
AND R3, R3, #0 ; set R3 to 0

; start subroutine logic

; push int product
ADD R6, R6, #-1
AND R0, R0, #0
STR R0, R6, #0

; set R1 to value of x
LDR R1, R5, #3 

; set R2 to two's complement of x to use as counter
ADD R2, R1, #0 
NOT R2, R2
ADD R2, R2, #1

; square
PRODUCT_LOOP

    ; R3 += x and increment counter
    ADD R3, R1, R3 
    ADD R2, R2, #1
    BRnp PRODUCT_LOOP

; product = square
STR R3, R6, #0 

; set return value of SQUARE to product
LDR R0, R6, #0
STR R0, R5, #2 

; pop product
ADD R6, R6, #1

; end subroutine logic
    
; restore and pop R3
LDR R3, R6, #0
ADD R6, R6, #1
    
; restore and pop R2
LDR R2, R6, #0
ADD R6, R6, #1
    
; restore and pop R1
LDR R1, R6, #0
ADD R6, R6, #1
    
; restore and pop R0
LDR R0, R6, #0
ADD R6, R6, #1

; restore and pop prev frame pointer
LDR R5, R6, #0 
ADD R6, R6, #1

; restore and popreturn addr
LDR R7, R6, #0 
ADD R6, R6, #1

RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.END