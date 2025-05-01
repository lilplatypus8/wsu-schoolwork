.ORIG x3000
LD R6, STACK_BASE

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

; set x (5)
AND R0, R0, #0
ADD R0, R0, #5
ADD R6, R6, #-1
STR R0, R6, #0

; set y (3)
AND R0, R0, #0
ADD R0, R0, #3
ADD R6, R6, #-1
STR R0, R6, #0

JSR POWER

; store POWER's return val in x6000
LDR R0, R6, #0
STR R0, R6, #5
ADD R6, R6, #5

HALT

STACK_BASE .FILL x6000

POWER

; push and save return addr
ADD R6, R6, #-2 
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

; push result
AND R0, R0, #0		
ADD R0, R0, #1	
ADD R6, R6, #-1	
STR R0, R6, #0

AND R1, R1, #0
AND R2, R2, #0

; set R3 to y
LDR R3, R5, #3

POWERLOOP
LDR R0, R5, #4 ; set R0 to x
LDR R1, R5, #-5 ; set R1 to result
AND R2, R2, #0

MULTLOOP
    ADD R2, R1, R2 ; curr sum + x
    ADD R0, R0, #-1 ; decrement counter
BRp MULTLOOP

STR R2, R5, #-5
ADD R3, R3, #-1
BRz POWERLOOP

LDR R0, R5, #-5 ; set R0 to result
STR R0, R5, #2

; restore and pop R3
ADD R6, R6, #1
LDR R3, R6, #0

; restore and pop R2
ADD R6, R6, #1
LDR R2, R6, #0
    
; restore and pop R1
ADD R6, R6, #1
LDR R1, R6, #0
    
; restore and pop R0
ADD R6, R6, #1
LDR R0, R6, #0

; restore and pop prev frame pointer
ADD R6, R6, #1
LDR R5, R6, #0 

; restore and pop return addr
ADD R6, R6, #1
LDR R7, R6, #0 

ADD R6, R6, #1

RET

.END