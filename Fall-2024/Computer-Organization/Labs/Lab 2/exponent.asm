.ORIG x3000
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0

; R0 = x
; R1 = y
; R2 = multiplication counter
; R3 = power counter
; R4 = current sum
; R5 = current product
LD R0, X_VALUE ; load X_VALUE into R0
LD R1, Y_VALUE ; load Y_VALUE into R1
ADD R2, R0, #-1 ; load X_VALUE into R2
ADD R3, R1, #-1 ; load Y_VALUE into R3
LD R4, X_VALUE;

; Checking 0^y
ADD R1, R1, #0 ; R1 + 0
BRz YZERO

; Checking x^0
ADD R0, R0, #0 ; R0 + 0
BRz XZERO

MULTLOOP
    ADD R4, R4, R0 ; curr sum + x
    ADD R2, R2, #-1 ; decrement counter
    BRz POWERLOOP
BRnp MULTLOOP

POWERLOOP
    ADD R5, R4, R5 ; sum + curr product
    ADD R3, R3, #-1 ; decrement counter
    BRn LOOPDONE ; if zero, exit loop
BRnp POWERLOOP

YZERO
    ADD R5, R5, #1 ; R4 += 1
BRnzp LOOPDONE
XZERO
    Add R5, R5, #0 ; R4 += 0

LOOPDONE

STI R5, RESULTS ; store R4 in RESULTs
HALT

X_VALUE .FILL #0
Y_VALUE .FILL #0
RESULTS .FILL x8000
.END