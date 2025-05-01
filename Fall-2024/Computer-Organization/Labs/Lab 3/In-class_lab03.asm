.ORIG x3000
START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LEA R0, PROMPT1		; Load the first number prompt and display to the user
PUTS

JSR GETNUM
ST R0, NUM1

LD R0, NEWLINE
OUT

LEA R0, PROMPT2		; Load the operation prompt and display to the user
PUTS

JSR GETOP
ST R0, OP

LD R0, NEWLINE
OUT

LEA R0, PROMPT3		; Load the second number prompt and display to the user
PUTS

JSR GETNUM
ST R0, NUM2

LD R0, NEWLINE
OUT

LD R0, NUM1
LD R1, NUM2
LD R2, OP
JSR CALC

LEA R0, PROMPT4		; Load the results prompt and display to the user
PUTS

; JSR CALC
JSR DISPLAY

LD R0, NEWLINE
OUT

BR START
HALT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROMPT1 .STRINGZ "Enter first number (0 - 99): "
PROMPT2 .STRINGZ "Enter an operation (+, -, *): "
PROMPT3 .STRINGZ "Enter second number (0 - 99): "
PROMPT4 .STRINGZ "Result: "
NEWLINE .FILL x000A

NUM1 .BLKW #1
NUM2 .BLKW #1
OP .BLKW #1
RESULT .BLKW #1
OPADD .FILL #-43
OPSUB .FILL #-45
OPMULT .FILL #-42

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input: none
; Output: R0 = number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GETNUM
; callee saves
ST R1, GETNUM_R1
ST R2, GETNUM_R2
ST R7, GETNUM_R7

;GETC
;OUT

; callee loads
LD R1, GETNUM_R1
LD R2, GETNUM_R2
LD R7, GETNUM_R7
RET
GETNUM_R1 .FILL #0
GETNUM_R2 .FILL #0
GETNUM_R7 .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input: none
; Output: R0 = OP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GETOP
; callee saves
ST R7, GETOP_R7

GETC
OUT

; callee loads
LD R7, GETOP_R7
RET
GETOP_R7 .FILL #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input: R0 = NUM1, R1 = NUM2, R2 = OP
; Output: R0 = RESULT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CALC
; calle saves
ST R3, CALC_R3
ST R4, CALC_R4
ST R7, CALC_R7

; Addition
LD R3, OPADD
ADD R4, R3, R2
BRz CALCADD
; Subtraction
LD R3, OPSUB
ADD R4, R3, R1
BRz CALCSUB
; Multiplication
LD R3, OPMULT
ADD R4, R3, R1
BRz CALCMULT

CALCADD
    ADD R0, R0, R1
BR CALCDONE

CALCSUB
    NOT R1, R1
    ADD R1, R1, #1
    ADD R0, R0, R1
BR CALCDONE

CALCMULT
    JSR MULTIPLY
BR CALCDONE

CALCDONE
; callee loads
LD R3, CALC_R3
LD R4, CALC_R4
LD R7, CALC_R7
RET
CALC_R3 .FILL #0
CALC_R4 .FILL #0
CALC_R7 .FILL #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input: R0 = NUM1, R1 = NUM2
; Output: R0 = RESULT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MULTIPLY
    ;TODO: multiply
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input: R0 = number to display
; Output: none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY



RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.END