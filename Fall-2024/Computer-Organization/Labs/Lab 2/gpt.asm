.ORIG x3000
AND R0, R0, #0    ; Clear R0
AND R1, R1, #0    ; Clear R1
AND R2, R2, #0    ; Clear R2
AND R3, R3, #0    ; Clear R3
AND R4, R4, #0    ; Clear R4
AND R5, R5, #0    ; Clear R5

; R0 = x
; R1 = y
; R2 = multiplication counter
; R3 = power counter
; R4 = current product
; R5 = final result

LD R0, X_VALUE     ; Load X_VALUE into R0 (base)
LD R1, Y_VALUE     ; Load Y_VALUE into R1 (exponent)
AND R4, R4, #0     ; Clear R4 (current product)
AND R5, R5, #0     ; Clear R5 (final result)

; If exponent is 0, result is 1 (x^0 = 1)
ADD R3, R1, #-1    ; R3 = y - 1
BRz SET_ONE        ; If y == 0, jump to SET_ONE

; Initialize result to 1
LD R5, ONE         ; R5 = 1 (initial result value)

; Power Loop
POWERLOOP
    AND R4, R4, #0    ; Clear R4 for the product calculation
    ADD R4, R0, #0    ; R4 = x (start of multiplication)

    ; Multiplication Loop
    ADD R2, R1, #-1   ; Set counter to y - 1
    BRz MULT_DONE     ; If y is 1, skip multiplication

MULTLOOP
    ADD R4, R4, R0    ; Multiply: R4 += x
    ADD R2, R2, #-1   ; Decrement counter
    BRp MULTLOOP      ; Repeat until counter is zero

MULT_DONE
    ADD R5, R5, R4    ; Accumulate result
    ADD R3, R3, #-1   ; Decrement power counter
    BRp POWERLOOP     ; Repeat until power counter is zero

SET_ONE
    STI R5, RESULTS    ; Store the result in RESULTS
    HALT              ; End the program

; Data section
X_VALUE .FILL #2    ; Base value x
Y_VALUE .FILL #3    ; Exponent value y
RESULTS .FILL x8000 ; Memory location to store the result
ONE     .FILL #1    ; Constant value 1

.END
