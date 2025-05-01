.ORIG x3000 

; Subroutines should follow register in - register out. MUL, for instance, has two inputs and one output. Example:
;   LD R0, VAL_A
;   LD R1, VAL_B
;   JSR MUL ; Inputs R0 and R1, output R0
;   ST R0, RESULT
; MUL should back up all the registers it uses (especially R7!) except R0. It doesn't load the R0 backup because it 
; instead uses R0 to return.

; Critical subroutines for the lab:

; GETNUM has no register inputs, uses GETC to get two digits, turns those digits into a number, and returns that.
; Input "69" (in ascii x0036 x0039) should return the value x0045 (which is #69 in hex).
; Single digit inputs can either be padded with a 0 (like "05") or single digit then newline ("5\n").
; Make sure to have OUT after GETC so it shows in the console what you type.

; GETOP has no register inputs and returns an operand (either the ascii value of *, +, - or some other way).
; The important part is that GETOP's output must correctly tell CALC what operation to do!
; Make sure to have OUT after GETC so it shows in the console what you type.

; CALC has three register inputs: the two numbers and the operation. Order doesn't matter as long as it works.
; The thing returned from GETOP should be compatible with CALC. 

; DISPLAY has one register input and no register output. It converts its input number to ascii and prints it.
; Must support both negative and positive numbers with a range [-9999, 9999] inclusive.
; If the input to DISPLAY is x01A4 (which is #420), it should print "420" or "0420" to console.
; If the input to DISPLAY is xFB2E (#-1234), it should print out "-1234". 

; Feel free to make and use other subroutines. Remember to back up R7. Remember to loop the main program infinitely.
; Good luck!

.END