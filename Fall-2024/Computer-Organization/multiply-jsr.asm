; Calling program
.ORIG x3000
LD R1, num1
LD R2, num2
JSR multi
ST R3, prod
HALT
;
; Input data & result
num1 .FILL x0006
num2 .FILL x0003
prod .BLKW #1

;Multiply two positive numbers
multi
ST R4, SAVE_R4
ST R1, SAVE_R1
AND R3, R3, #0
ADD R4, R1, #0
BRz zero
loop ADD R3, R2, R3
ADD R1, R1, #-1
BRp loop
zero 
LD R1, SAVE_R1
LD R4, SAVE_R4
RET

SAVE_R3 .FILL #0 ;SAVE_R3 .BLKW #1
SAVE_R4 .BLKW #1
SAVE_R1 .BLKW #1
;ARRAY .BLKW #5

.END
;Notice any undesirable ;side-effects?