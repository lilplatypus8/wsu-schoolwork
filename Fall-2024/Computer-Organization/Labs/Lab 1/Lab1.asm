	.ORIG	x3000

;--------------------------------------------------------------------------
; Main
;--------------------------------------------------------------------------

	; Print the Signed value
	LEA R0, Pr1
	PUTS

	; Set the flag for PrntDec to SIGNED, then print
	; the signed value
	AND R0, R0, #0
	ADD R0, R0, #1
	LDI R1, Signed
	JSR PrntDec
	LEA R0, Newline
	PUTS

	; Print the Unsigned value:
	LEA R0, Pr2
	PUTS

	; Set the flat for PrntDec to UNSIGNED, then
	; print the unsigned value
	AND R0, R0, #0
	LDI R1, Unsignd
	JSR PrntDec
	LEA R0, Newline
	PUTS

	; Print the null-terminated string
	LEA R0, Pr3
	PUTS
	LD R0, String
	PUTS
	LEA R0, Newline
	PUTS

	; Print the Linked List:
	LEA R0, Pr4
	PUTS

	; Load the address of the linked list and print
	; the list
	LD R0, List
	JSR PrntList
	LEA R0, Newline
	PUTS

	HALT

Signed	.FILL x3500
Unsignd	.FILL x3501
String	.FILL x3502
List	.FILL x4000
Pr1	.STRINGZ "Signed integer: "
Pr2	.STRINGZ "Unsigned integer: "
Pr3	.STRINGZ "String: "
Pr4	.STRINGZ "Linked list: "
Newline .FILL x0A
	.FILL x00


PrntList

;-----------------------------------------------------------------------------------
; PrntList - Print a linked list of signed integers
; Input - The address of the first list node in R0
;         The list is assumed to consist of two-word nodes.  The first word is
;         the value to print, the second value is a pointer to the next node.
;-----------------------------------------------------------------------------------

	; Save registers
	ST R1, PrlR1
	ST R2, PrlR2
	ST R7, PrlR7

	; R2 is a pointer to the current list node
	ADD R2, R0, #0

	; When the pointer is null, we're done
	ADD R2, R2, #0
	BRz PrlDone

	; R0 is the signed/unsigned flag for PrntDec
PrlLoop	AND R0, R0, #0
	ADD R0, R0, #1

	; Print the current value
	LDR R1, R2, #0
	JSR PrntDec

	; Advance to the next node
	LDR R2, R2, #1

	; If it is not null, print a separator and continue
	ADD R2, R2, #0
	BRz PrlDone
	LEA R0, SepStr
	PUTS
	BRnzp PrlLoop	

PrlDone	LD R1, PrlR1
	LD R2, PrlR2
	LD R7, PrlR7
	RET

PrlR1	.BLKW #1
PrlR2	.BLKW #1
PrlR7	.BLKW #1
SepStr	.STRINGZ ", "

DivTen

; ----------------------------------------------------------------------------------
; DivTen - Divide a value by 10, also returning the remainder
; Input - A positive integer in R0
; Output - R0 <- R0 / 10 (integer division); R0 <- R0 Mod 10 (remainder)
; Side Effects - None
; ----------------------------------------------------------------------------------

	; Save registers
	ST R2, MTR2
	ST R3, MTR3
	ST R4, MTR4

	; R0 will be the remainder.  Initial value = the input value.
	ADD R0, R1, #0

	; R1 will be the result of the integer division.  Initial value = 0
	AND R1, R1, #0

	; Subtract 10 while R0 >= 10
	; For each 10 subtracted, add 1 to the result value (in R1)
	LD R2, C10			; R2 <- -10
	NOT R2, R2
	ADD R2, R2, #1

	; If the current value is less than 10, move on
Sub10	ADD R0, R0, #0			; If the value appears negative, it is > 10
	BRn  DoSub
	ADD R4, R0, R2			; If it appears positive, check by subtraction
	BRzp DoSub

	BRnzp DTDONE

	; Otherwise subtract 10, and add 1 to result
DoSub	ADD R0, R0, R2
	ADD R1, R1, #1
	BRnzp Sub10

	; Restore registers and return
DTDONE  LD R2, MTR2
	LD R3, MTR3
	LD R4, MTR4
	RET

	; Saved registers
MTR2	.BLKW #1	
MTR3	.BLKW #1
MTR4	.BLKW #1

	; Constant: 10
C10	.Fill #10	
		
	
PrntDec

;--------------------------------------------------------------------------------------------------
;  PrntDec - Print a 2's complement decimal number to the screen
;  Input:  A 2's complement integer in R1, and a flag (R0) indicating signed (1) or unsigned (0) in R0
;  Return Value:  None
;  Side Effect:  The integer in R1 is printed to the console
;--------------------------------------------------------------------------------------------------

	; Save Registers
	ST R0, PDR0
	ST R1, PDR1
	ST R2, PDR2
	ST R3, PDR3
	ST R4, PDR4
	ST R7, PDR7	; This routine calls another subroutine, so it had better save R7!

	; Initialize local register variables
	LEA R2, PDBUF		; R2 is a pointer to the print buffer
	LD  R3, ZERO		; R3 is ASCII Zero
	AND R4, R4, #0		; R4 is a flag:  0=positive, 1=negative

	; If the number is unsigned, skip the negative check:
	ADD R0, R0, #0
	BRz DivLoop

	; If the number is negative, note that fact, then invert it
	ADD R1, R1, #0
	BRzp DivLoop
	NOT R1, R1		; Negate the number
	ADD R1, R1, #1	
	ADD R4, R4, #1		; Set the R4 flag to negative

DivLoop
	; While the value to print is >0, get the low-order decimal digit
	; and store in the buffer

	; Divide the current number by 10
	JSR DivTen
	
	; Convert the remainder to ASCII and store in the buffer
	ADD R0, R0, R3		; Add ASCII 0 (x0030) to convert to a digit
	STR R0, R2, #0		; Save in buffer && ptr++
	ADD R2, R2, #1

	; If the working value is zero, we have all the digits, so print.  Otherwise, repeat.
	ADD R1, R1, #0
	BRz Print
	BRnzp DivLoop
	
	; Back the pointer up one, load the (negated) address of the print buffer into R1
Print	ADD R2, R2, #-1
	LEA R1, PDBUF
	NOT R1, R1
	ADD R1, R1, #1

	; Print a negative sign if necessary (R4 is the negative flag)
	ADD R4, R4, #0
	BRz PrLoop
	LD R0, NegSign
	OUT

	; Print the next digit and back up the pointer
PrLoop	LDR R0, R2, #0
	OUT
	ADD R2, R2, #-1

	; If the pointer moves beyond the buffer, we're done
	ADD R3, R2, R1
	BRzp PrLoop

	; Restore registers and return
	LD R0, PDR0
	LD R1, PDR1
	LD R2, PDR2
	LD R3, PDR3
	LD R4, PDR4
	LD R7, PDR7
	RET

PDR0	.BLKW	#1
PDR1	.BLKW	#1
PDR2	.BLKW	#1
PDR3	.BLKW	#1
PDR4	.BLKW	#1
PDR7	.BLKW	#1

PDBUF	.BLKW	#7	; Room for a negative 5 digit number + null
ZERO	.FILL	x30	; ASCII zero
NegSign	.FILL	x2D	; Negative sign:  "-"
	.END