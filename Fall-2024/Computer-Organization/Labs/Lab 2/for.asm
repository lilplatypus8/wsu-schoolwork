.ORIG x3000
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0

; R0 = number of iterations
; R1 = i
; R2 = var to subtract iterations from i
; R3 = result value
LD R0, ITERATIONS ; load ITERATIONS into R3
ADD R2, R0, #0
NOT R2, R2 
ADD R2, R2, #1 ; Two's Complement of R0

FORLOOP
    ADD R3, R3, #5 ; counter += 5
    ADD R1, R1, #1 ; i++
    ADD R4, R1, R2 ; R4 = i - num of iterations
    BRz LOOPDONE ; if zero, exit loop
BRnzp FORLOOP

LOOPDONE

RETURN
STI R3, RESULTS ; store R3 in RESULTs
HALT

ITERATIONS .FILL #7
INTCOUNTER .FILL x4000
RESULTS .FILL x8001
.END