.ORIG x3000
LD R6, STACK_PTR
LEA R4, GLOBAL_VARS

ADD R6, R6, #-1
STR R7, R6, #0 ; push return address

ADD R6, R6, #-1
STR R5, R6, #0 ; push prev frame ptr

ADD R5, R6, #0 ; set frame ptr

ADD R6, R6, #-1
AND R0, R0, #0
STR R0, R6, #0 ; push int input = 0
ADD R6, R6, #-1
STR R0, R6, #0 ; push int result = 0

ADD R0, R4, #0
ADD R0, R0, #2 ; globals offset
PUTS

ADD R6, R6, #-1 ; push getnum's rv

JSR GETNUM

LDR R0, R6, #0
STR R0, R5, #-1 ; int input = getnum()

ADD R6, R6, #1 ; pop getnum's rv

ADD R6, R6, #-1
LDR R0, R5, #-1
STR R0, R6, #0 ; push triangle's arg

ADD R6, R6, #-1 ; push triangle's rv

JSR FIB

LDR R0, R6, #0
STR R0, R5, #2 ; return value = triangle(input)
STR R0, R5, #-2 ; int result = triangle(input)

ADD R6, R6, #1 ; pop arg
ADD R6, R6, #1 ; pop rv

ADD R0, R4, #0
ADD R0, R0, #15
ADD R0, R0, #13
PUTS ; first part of response 

ADD R6, R6, #-1
LDR R0, R5, #-1
STR R0, R6, #0 ; push display's arg (int input)

JSR DISPLAY

ADD R6, R6, #1 ; pop arg

ADD R0, R4, #0
ADD R0, R0, #15
ADD R0, R0, #15
ADD R0, R0, #2
PUTS ; second part of response 

ADD R6, R6, #-1
LDR R0, R5, #-2
STR R0, R6, #0 ; push display's arg (int result)

JSR DISPLAY

ADD R6, R6, #1 ; pop arg
ADD R6, R6, #1 ; pop result
ADD R6, R6, #1 ; pop input
LDR R5, R6, #0
ADD R6, R6, #1 ; pop prev frame ptr
LDR R7, R6, #0
ADD R6, R6, #1 ; pop return address
HALT
GLOBAL_VARS
NEG_ASCII .FILL #-48 ; #0
ASCII .FILL x30 ; #1
PROMPT .STRINGZ "Please enter a number n: " ; #2
RESULT_1 .STRINGZ "\nT(" ; #28
RESULT_2 .STRINGZ ") = " ; #32
STACK_PTR .FILL x6000

TRIANGLE
; 3*triangle(n-1) - 3*triangle(n-2) + triangle(n-3)
ADD R6, R6, #-1
STR R7, R6, #0 ; push return addr
ADD R6, R6, #-1
STR R5, R6, #0 ; push prev frame ptr
ADD R5, R6, #0

; BASE CASES
; checking n == 0
LDR R0, R5, #3
BRnp END_IF_0
ADD R0, R0, #1
STR R0, R5, #2
BRnzp RETURN_TRIANGLE
END_IF_0

; checking n == 1
LDR R0, R5, #3
ADD R0, R0, #-1
BRnp END_IF_1
ADD R0, R0, #3
STR R0, R5, #2 
BRnzp RETURN_TRIANGLE
END_IF_1

; checking n == 2
LDR R0, R5, #3
ADD R0, R0, #-2
BRnp END_IF_2
ADD R0, R0, #6
STR R0, R5, #2
BRnzp RETURN_TRIANGLE
END_IF_2

ADD R6, R6, #-1
LDR R0, R5, #3
ADD R0, R0, #-1
STR R0, R6, #0 ; push argument (n-1)

ADD R6, R6, #-1 ; push return value

JSR TRIANGLE

LDR R0, R6, #0 ; return value

ADD R1, R0, R0
ADD R0, R0, R1 ; 3 * triangle(n-1)

STR R0, R5, #2 ; put in return value x5FF8 + 2 = x5FFA

ADD R6, R6, #1 ; pop return value
ADD R6, R6, #1 ; pop arg

ADD R6, R6, #-1
LDR R0, R5, #3
ADD R0, R0, #-2
STR R0, R6, #0 ; push argument (n-2)

ADD R6, R6, #-1 ; push return value

JSR TRIANGLE

LDR R0, R6, #0 ; return value

ADD R1, R0, R0
ADD R0, R1, R0 ; 3 * return value

; 3*triangle(n-1) - 3*triangle(n-2)
LDR R1, R5, #2
NOT R0, R0
ADD R0, R0, #1 ; two's
ADD R0, R0, R1
STR R0, R5, #2 ; x5FF8 + 2 = x5FFA

ADD R6, R6, #1 ; pop return value
ADD R6, R6, #1 ; pop arg

ADD R6, R6, #-1
LDR R0, R5, #3
ADD R0, R0, #-3
STR R0, R6, #0 ; push arg (n-3)

ADD R6, R6, #-1 ; return value

JSR TRIANGLE

LDR R0, R6, #0 ; return value
ADD R6, R6, #1 ; popping rv

ADD R6, R6, #1 ; pop arg

LDR R1, R5, #2
ADD R0, R0, R1
STR R0, R5, #2 ; complete calc and put return value x5FF8 + 2 = x5FFA

RETURN_TRIANGLE
LDR R5, R6, #0
ADD R6, R6, #1 ; pop prev frame ptr
LDR R7, R6, #0
ADD R6, R6, #1 ; pop return address
RET

GETNUM
ADD R6, R6, #-1
STR R7, R6, #0 ; push return addr
ADD R6, R6, #-1
STR R5, R6, #0 ; push prev frame ptr
ADD R5, R6, #0

GETC
OUT

LDR R1, R4, #0
ADD R0, R1, R0
STR R0, R5, #2 ; return value

LDR R5, R6, #0
ADD R6, R6, #1 ; pop prev frame ptr
LDR R7, R6, #0
ADD R6, R6, #1 ; pop return address
RET

DISPLAY
ADD R6, R6, #-1
STR R7, R6, #0 ; push return addr
ADD R6, R6, #-1
STR R5, R6, #0 ; push prev frame ptr
ADD R5, R6, #0

AND R0, R0, #0
ADD R6, R6, #-1 ; int tens = 0
STR R0, R6, #0

LDR R3, R4, #1 ; ASCII offset
AND R2, R2, #0 ; tens counter
ADD R2, R2, #-1 ; start at -1, ++ at beginning of iteration
ADD R0, R0, #-10 ; R0 = -10
LDR R1, R5, #2 ; R1 = int n

TEN_LOOP
    ADD R2, R2, #1 ; increase tens counter
    ADD R1, R1, R0 ; int n - 10
BRzp TEN_LOOP
ADD R2, R2, #0 ; check if 0
BRz SKIP_TEN
LDR R0, R4, #1 ; R0 = x30
ADD R0, R2, R3 ; convert decimal to ASCII
OUT

SKIP_TEN
    ADD R1, R1, #10
    ADD R0, R1, R3
    OUT

ADD R6, R6, #1 ; pop int tens

LDR R5, R6, #0
ADD R6, R6, #1 ; pop prev frame ptr
LDR R7, R6, #0
ADD R6, R6, #1 ; pop return address
RET
.END