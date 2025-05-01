.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROGRAM_LOOP
LEA R0, PROMPT1		; Load the first number prompt and display to the user
PUTS


;;;;;
JSR GETNUM
ST R0, NUM1
;;;;;

LD R0, NEWLINE
OUT

LEA R0, PROMPT2		; Load the second number prompt and display to the user
PUTS

;;;;;
JSR GETOP
;;;;;

LD R0, NEWLINE
OUT

LEA R0, PROMPT3		; Load the operation prompt and display to the user
PUTS

;;;;;
JSR GETNUM
ST R0, NUM2
;;;;;


LD R0, NEWLINE
OUT

;;;;
JSR CALC
;;;;

LEA R0, PROMPT4		; Load the results prompt and display to the user
PUTS

;;;;;;;
JSR DISPLAY
;;;;;;;

LD R0, NEWLINE
OUT

AND R0, R0, #0
BRz PROGRAM_LOOP
;HALT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROMPT1 .STRINGZ "Enter first number (0 - 99): "
PROMPT2 .STRINGZ "Enter an operation (+, -, *): "
PROMPT3 .STRINGZ "Enter second number (0 - 99): "
PROMPT4 .STRINGZ "Result: "
NEWLINE .FILL x000A
RETURN .FILL x6000

NUM1 .BLKW #1
NUM2 .BLKW #1
NUM_TENS_VALUE .BLKW #1

OP .BLKW #1
RESULT .BLKW #1
RESULT_TEMP .BLKW #1

MINUS .FILL #45
TIMES .FILL #42
PLUS .FILL #43

na48 .FILL #-48
a48 .FILL #48

THOUSANDS .FILL #-1000
HUNDREDS .FILL #-100
TENS .FILL #-10
ONES .FILL #-1

NEGATIVE_SIGN .FILL x3900
THOUSANDS_DIGIT .FILL x4000
HUNDREDS_DIGIT .FILL x4001
TENS_DIGIT .FILL x4002
ONES_DIGIT .FILL x4003

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GETNUM
	AND R5, R5, #0
	; Save address for return
	ADD R5, R7, #0

	; First digit in num
	GETC
	OUT

    ;;;;; CHECK IF FIRST NUM IS A 0

	LD R1, na48
	;Convert from ascii
	ADD R0, R0, R1

	ADD R1, R0, #0
	ST R1, NUM_TENS_VALUE

	AND R2, R2, #0
	ADD R2, R2, #10

	JSR MULTIPLICATION


	LD R1, na48

	; Second digit in num
	GETC
	OUT

    JSR CHECK_NEW_LINE

	ADD R0, R3, R0


	ADD R7, R5, #0
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


CHECK_NEW_LINE
        ADD R0, R0, #-10
        BRz IS_NEW_LINE
        ADD R0, R0, #10
    	;Convert from ascii
    	ADD R0, R0, R1

	    RET
	    IS_NEW_LINE
	        AND R0, R0, #0
	        LD R3, NUM_TENS_VALUE
	        RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GETOP
	AND R5, R5, #0
	; Save address for return
	ADD R5, R7, #0

	; Get op and store to OP
	GETC
	OUT
	ST R0, OP

	; Load R1 back with num 1
	;LD R1, NUM1


	ADD R7, R5, #0
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CALC
	AND R5, R5, #0
	; Save address for return
	ADD R5, R7, #0

	; Load R3 with op
	LD R3, OP

	; Set R4 to PLUS
	LD R4, PLUS
	NOT R4, R4
	ADD R4, R4, #1

	; If R3 is plus
	ADD R3, R3, R4
	BRz ADDITION


	LD R4, PLUS
	; If Not re-add the -43
	ADD R3, R3, R4


	; Set R4 to MINUS
	LD R4, MINUS
	NOT R4, R4
	ADD R4, R4, #1

	; If R3 is minus
	ADD R3, R3, R4
	BRz SUBTRACTION


	LD R4, MINUS
	; If Not Re-add the 45
	ADD R3, R3, R4



	; Set R4 to MINUS
	LD R4, TIMES
	NOT R4, R4
	ADD R4, R4, #1

	; If R3 is multiply
	LD R1, NUM1
	LD R2, NUM2
	ADD R3, R3, R4
	BRz MULTIPLICATION



	ADD R7, R5, #0
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DISPLAY


	AND R5, R5, #0
	; Save address for return
	ADD R5, R7, #0

	LD R4, a48

	AND R2, R2, #0


	LD R0, RESULT
	;;;; CHECK IF VALUE IS NEGATIVE, IF SO, TWOs COMPLIMENT IT TO BRING IT BACK AND THEN OUT PUT A NEGATIVE SIGN BEFORE IT

	ADD R0, R0, #0
	BRzp IS_NOT_NEGATIVE

    ;;;; Load R0 With the result

    IS_NEGATIVE

        LD R0, MINUS
        OUT

        LD R0 RESULT
	    NOT R0, R0
	    ADD R0, R0, #1


	    AND R3, R3, #0
	    BRz AFTER_CONVERSION



	IS_NOT_NEGATIVE
	ST R0, RESULT_TEMP



	AFTER_CONVERSION

    ;;;; CHECK FOR HOW MANY THOUSANDS
    AND R1, R1, #0
    LD R3, THOUSANDS
    THOUSANDS_LOOP
        ADD R1, R1, #1
        ADD R0, R0, R3
        ADD R0, R0, #0
        BRz THOUSANDS_LOOP_END
        BRp THOUSANDS_LOOP


    ADD R1, R1, #-1
    THOUSANDS_LOOP_END


    ;;;; CHECK FOR R1 = 10
    ADD R1, R1, #-10
    BRz R1_THOUSANDS_TO_1
    BRn R1_THOUSANDS_TO_R1

    R1_THOUSANDS_TO_1
        ADD R1, R1, #1
        ADD R1, R1, #0
        BRp R1_THOUSANDS_AFTER
    R1_THOUSANDS_TO_R1
        ADD R1, R1, #10

    R1_THOUSANDS_AFTER
    ST R0, RESULT_TEMP
    ADD R0, R1, #0
    ADD R0, R4, R0
    OUT
    LD R0, RESULT_TEMP

    ADD R0, R0, #0
    BRn MAKE_POSITIVE_THOUSANDS
    BRzp THOUSANDS_CONTINUE
    MAKE_POSITIVE_THOUSANDS
    NOT R3, R3
    ADD R3, R3, #1

    ADD R0, R3, R0
    THOUSANDS_CONTINUE


    ;;;; CHECK FOR HOW MANY HUNDREDS
    AND R1, R1, #0
    LD R3, HUNDREDS
    HUNDREDS_LOOP
        ADD R1, R1, #1
        ADD R0, R0, R3
        ADD R0, R0, #0
        BRz HUNDREDS_LOOP_END
        BRp HUNDREDS_LOOP
    ADD R1, R1, #-1
    HUNDREDS_LOOP_END

    ;;;; CHECK FOR R1 = 10
    ADD R1, R1, #-10
    BRz R1_HUNDREDS_TO_1
    ADD R1, R1, #10
    ADD R1, R1, #-10
    BRn R1_HUNDREDS_TO_R1

    R1_HUNDREDS_TO_1
        ADD R1, R1, #1
        ADD R1, R1, #0
        BRp R1_HUNDREDS_AFTER
    R1_HUNDREDS_TO_R1
        ADD R1, R1, #10

    R1_HUNDREDS_AFTER
    ST R0, RESULT_TEMP
    ADD R0, R1, #0
    ADD R0, R4, R0
    OUT
    LD R0, RESULT_TEMP

    ADD R0, R0, #0
    BRn MAKE_POSITIVE_HUNDREDS
    BRzp HUNDREDS_CONTINUE
    MAKE_POSITIVE_HUNDREDS
    NOT R3, R3
    ADD R3, R3, #1

    ADD R0, R3, R0
    HUNDREDS_CONTINUE

    ;;;; CHECK FOR HOW MANY TENS
    AND R1, R1, #0
    LD R3, TENS
    TENS_LOOP
        ADD R1, R1, #1
        ADD R0, R0, R3

        ADD R0, R0, #0
        BRz TENS_LOOP_END
        BRp TENS_LOOP

    ADD R1, R1, #-1
    TENS_LOOP_END

    ;;;; CHECK FOR R1 = 10
    ADD R1, R1, #-10
    BRz R1_TENS_TO_1
    ADD R1, R1, #10
    ADD R1, R1, #-10
    BRn R1_TENS_TO_R1

    R1_TENS_TO_1
        ADD R1, R1, #1
        ADD R1, R1, #0
        BRp R1_TENS_AFTER
    R1_TENS_TO_R1
        ADD R1, R1, #10


    R1_TENS_AFTER
    ;ST R1, TENS_DIGIT
    ST R0, RESULT_TEMP
    ADD R0, R1, #0
    ADD R0, R4, R0
    OUT
    LD R0, RESULT_TEMP

    ADD R0, R0, #0
    BRn MAKE_POSITIVE_TENS
    BRzp TENS_CONTINUE
    MAKE_POSITIVE_TENS
    NOT R3, R3
    ADD R3, R3, #1

    ADD R0, R3, R0
    TENS_CONTINUE

    ;;;; CHECK FOR HOW MANY ONES
    AND R1, R1, #0
    LD R3, ONES
    ONES_LOOP
        ADD R1, R1, #1
        ADD R0, R0, R3

        ADD R0, R0, #0
        BRz ONES_LOOP_END

        BRp ONES_LOOP
    ADD R1, R1 #-1
    ONES_LOOP_END
    ST R0, RESULT_TEMP
    ADD R0, R1, #0
    ADD R0, R4, R0
    OUT
    LD R0, RESULT_TEMP

    NOT R3, R3
    ADD R3, R3, #1

    ADD R0, R3, R0




    ADD R7, R5, #0
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; SUBTRACT 48 from answer to change from ascii to int

;;;;
ADDITION
	; Add R1 and R2 and put it in R3
	LD R1, NUM1
	LD R2, NUM2
	ADD R3, R1, R2

	ST R3, RESULT
RET
;;;;


;;;;
SUBTRACTION
	; Subtract R1 and R2 and put it in R3
	LD R1, NUM1
	LD R2, NUM2

	; Make R2 Negative
	NOT R2, R2
	ADD R2, R2, #1

	ADD R3, R1, R2

	ST R3, RESULT
RET
;;;;

;;;;

MULTIPLICATION
	; Multiply R1 and R2 and put it in R3


    ;;;; ZERO CHECKS
    ADD R2, R2 #0
    BRz RETURN_ZERO

    ADD R1, R1 #0
    BRz RETURN_ZERO

	; Zero out R3
	AND R3, R3, #0

	LOOP

		ADD R3, R1, R3

		; If iterator is 0, exit
		ADD R2, R2, #-1
	BRp LOOP


	ST R3, RESULT
RET
    RETURN_ZERO
    ADD R3, R3, #0
    ST R3, RESULT
RET
;;;;


.END
