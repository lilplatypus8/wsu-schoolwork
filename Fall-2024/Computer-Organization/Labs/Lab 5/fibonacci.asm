;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x3000
;    Your main() function starts here
LD R6, STACK_PTR            ;    LOAD the pointer to the bottom of the stack in R6    (R6 = x6000)
LEA R4, GLOBAL_VARS            ;    MAKE your global var pointer R4 point to globals    (R4 = ADDRESS(GLOBAL_VARS))

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

; push and save int x
ADD R6, R6, #-1
AND R0, R0, #0
STR R0, R6, #0

; push and save int result
ADD R6, R6, #-1
STR R0, R6, #0

; print prompt
ADD R0, R4, #0
ADD R0, R0, #2
PUTS

; push getnum's return value
ADD R6, R6, #-1

JSR GETNUM

; set x = getnum
LDR R0, R6, #0
STR R0, R5, #-1

; pop getnum's return value
ADD R6, R6, #1

; push fibonacci SR argument
ADD R6, R6, #-1
STR R0, R5, #-1
STR R0, R6, #0

; push fib's rv
ADD R6, R6, #-1 

JSR FIBONACCI                    ;    CALL fibonacci() function

; main's return value = fib(arg)
LDR R0, R6, #0
STR R0, R5, #2

; result = fib(arg)
STR R0, R5, #-2

; pop fib arg
ADD R6, R6, #1

; pop fib return value
ADD R6, R6, #1

; load R0 with RESULT_1 from global variables
ADD R0, R4, #0
ADD R0, R0, #15
ADD R0, R0, #13
PUTS

; push int display's arg with int x's value
ADD R6, R6, #-1
LDR R0, R5, #2
STR R0, R6, #0

JSR DISPLAY

; pop display's arg
ADD R6, R6, #1

; load R0 with RESULT_2 from global variables
ADD R0, R4, #0
ADD R0, R0, #15
ADD R0, R0, #15
ADD R0, R0, #2
PUTS

; push int display's arg with int result's value
ADD R6, R6, #-1
LDR R0, R5, #-2
STR R0, R6, #0

JSR DISPLAY

; pop display's arg, result, x, prev frame pointer and return addr
ADD R6, R6, #1
ADD R6, R6, #1
ADD R6, R6, #1
LDR R5, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

HALT

GLOBAL_VARS                    ;    Your global variables start here
NEG_ASCII .FILL #-48 ; #0
ASCII_OFFSET    .FILL #48 ; #1
PROMPT .STRINGZ "Please enter a number n: " ; #2
RESULT_1 .STRINGZ "\nF(" ; #28
RESULT_2 .STRINGZ ") = " ; #32
STACK_PTR    .FILL x6000            ;    STACK_PTR is a pointer to the bottom of the stack (x6000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FIBONACCI
; f(n) = f(n-1) + f(n-2)

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

; checking n=0 and n=1 base cases

; check if getnum's result is 0 (base case)
LDR R0, R5, #3
BRnp CHECK_ONE

    ; set subroutine's return value to 0
    ADD R0, R0, #0
    STR R0, R5, #2
    
BRnzp EXIT_FIB

; check if getnum's result is 1 (base case)
CHECK_ONE
LDR R0, R5, #3
ADD R0, R0, #-1
BRnp RECURSION

    ; set subroutine's return value to 1
    ADD R0, R0, #1
    STR R0, R5, #2
    
BRnzp EXIT_FIB


RECURSION

; push next arg and subtract one from n
ADD R6, R6, #-1
LDR R0, R5, #3
ADD R0, R0, #-1
STR R0, R6, #0

; push return value
ADD R6, R6, #-1

; call f(n-1)
JSR FIBONACCI

; load f(n-1) result into R0 and store in x6001
LDR R0, R6, #0 
STR R0, R5, #2

; pop return value
ADD R6, R6, #1 

; pop argument
ADD R6, R6, #1 

; push next arg and subtract one from n
ADD R6, R6, #-1
LDR R0, R5, #3
ADD R0, R0, #-2
STR R0, R6, #0

; push return value
ADD R6, R6, #-1

; call f(n-2)
JSR FIBONACCI

; load f(n-2) return value into R0
LDR R0, R6, #0 

; pop return value
ADD R6, R6, #1 

; pop argument
ADD R6, R6, #1

; load f(n-1) into R1
LDR R1, R5, #2

; f(n) = f(n-1) + f(n-2)
ADD R0, R0, R1

; store result in x5FFB
STR R0, R5, #2 

EXIT_FIB

; restore and pop prev frame pointer
LDR R5, R6, #0 
ADD R6, R6, #1

; restore and pop return addr
LDR R7, R6, #0 
ADD R6, R6, #1
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GETNUM

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

GETC
OUT

; convert ASCII to integer
LDR R1, R4, #0  
ADD R0, R0, R1  

; store result as return value
STR R0, R5, #2  

; restore and pop prev frame pointer
LDR R5, R6, #0 
ADD R6, R6, #1

; restore and pop return addr
LDR R7, R6, #0 
ADD R6, R6, #1

RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DISPLAY

; push and save return addr
ADD R6, R6, #-1 
STR R7, R6, #0 

; push and save prev frame pointer
ADD R6, R6, #-1 
STR R5, R6, #0 

; set new frame pointer
ADD R5, R6, #0 

AND R0, R0, #0

; push tens place
ADD R6, R6, #-1
STR R0, R6, #0

; set up R2 as a loop counter
AND R2, R2, #0 
ADD R2, R2, #-1

; load R3 with negative ascii offset
LDR R3, R4, #1

; load R1 with n
LDR R1, R5, #2 

; subtract 10 from value and loop if result is non-negative
CALC_TENS
    ADD R2, R2, #1
    ADD R1, R1, #-10
BRzp CALC_TENS

; if answer is single-digit, skip displaying ten's place
ADD R2, R2, #0
BRz NO_TENS_PLACE

; add ascii offset to ten's digit and print
LDR R0, R4, #1
ADD R0, R2, R3
OUT

; reset value and print
NO_TENS_PLACE
    ADD R1, R1, #10
    ADD R0, R1, R3
    OUT

; pop tens
ADD R6, R6, #1

; restore and pop prev frame pointer
LDR R5, R6, #0 
ADD R6, R6, #1

; restore and pop return addr
LDR R7, R6, #0 
ADD R6, R6, #1

RET
.END