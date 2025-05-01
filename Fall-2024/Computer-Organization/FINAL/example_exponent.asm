.ORIG x3000
LD R6, STACK_BASE	; R6 = x6000
ADD R6, R6, #-1		; R6 = x5FFF
STR R7, R6, #0

ADD R6, R6, #-1		; R6 = x5FFE
STR R5, R6, #0

ADD R5, R6, #0		; R5 = x5FFE

AND R0, R0, #0		; R0 = x0000
ADD R0, R0, #5		; R0 = x0005
ADD R6, R6, #-1		; R6 = x5FFD
STR R0, R6, #0

AND R0, R0, #0		; R0 = x0000
ADD R0, R0, #3		; R0 = x0003
ADD R6, R6, #-1		; R6 = x5FFC
STR R0, R6, #0

JSR POWER

LDR R0, R6, #0		; R0 = power's return value
STR R0, R6, #5
ADD R6, R6, #5

HALT

STACK_BASE .FILL x6000

POWER
ADD R6, R6, #-2		; R6 = x5FFA
STR R7, R6, #0

ADD R6, R6, #-1		; R6 = x5FF9
STR R5, R6, #0

ADD R5, R6, #0		; R5 = x5FF9

ADD R6, R6, #-1		; R6 = x5FF8
STR R0, R6, #0

ADD R6, R6, #-1		; R6 = x5FF7
STR R1, R6, #0

ADD R6, R6, #-1		; R6 = x5FF6
STR R2, R6, #0

ADD R6, R6, #-1		; R6 = x5FF5
STR R3, R6, #0

AND R0, R0, #0		; R0 = x0000
ADD R0, R0, #1		; R0 = x0001
ADD R6, R6, #-1		; R6 = x5FF4
STR R0, R6, #0


AND R1, R1, #0		; R1 = x0000
AND R2, R2, #0		; R2 = x0000

LDR R3, R5, #3		; R3 = int y

EXP_LOOP
LDR R0, R5, #4		; R0 = int x
LDR R1, R5, #-5		; R1 = int result
AND R2, R2, #0		; R2 = x0000

MUL_LOOP
ADD R2, R1, R2		; R2 = R1 + R2
ADD R0, R0, #-1
BRp MUL_LOOP

STR R2, R5, #-5		; Store result
ADD R3, R3, #-1
BRp EXP_LOOP

LDR R0, R5, #-5		; R0 = int result
STR R0, R5, #2		

ADD R6, R6, #1		; R6 = x5FF5
LDR R3, R6, #0

ADD R6, R6, #1		; R6 = x5FF6
LDR R2, R6, #0

ADD R6, R6, #1		; R6 = x5FF7
LDR R1, R6, #0

ADD R6, R6, #1		; R6 = x5FF8
LDR R0, R6, #0

ADD R6, R6, #1		; R6 = x5FF9
LDR R5, R6, #0

ADD R6, R6, #1		; R6 = x5FFA
LDR R7, R6, #0

ADD R6, R6, #1		; R6 = x5FFB

RET

.END