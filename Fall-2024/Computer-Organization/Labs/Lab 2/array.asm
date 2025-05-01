.ORIG x3000
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R4, R4, #0
AND R5, R5, #0

; R0 = GETC
; R1 = array size
; R2 = array loc
; R4 = prompt message
; R5 = ascii offset value

LEA R2, ARRAY_START ; load start address into R3
LD R5, ASCII_OFFSET ; load value of ascii offset into R5
LD R1, ARRAY_SIZE ; load ARRAY_SIZE into R6

FORLOOP
    
    LEA R0, PROMPT_MSG ; load address of message into R4
    PUTS
    GETC
    OUT
    
    ADD R0, R0, R5 ; subtract x0030 from R0
    STR R0, R2, #0 ; store value at current array loc
    ADD R2, R2, #1 ; array loc++
    ADD R1, R1, #-1 ; decrement counter
    
    BRp FORLOOP ; if not zero yet, continue loop

HALT

PROMPT_MSG .STRINGZ "Enter number (0-9): " ; prompt
ARRAY_SIZE .FILL #7 ; size of array
ASCII_OFFSET .FILL xFFD0 ; two's complement of ascii offset
ARRAY_START  .BLKW 20

.END