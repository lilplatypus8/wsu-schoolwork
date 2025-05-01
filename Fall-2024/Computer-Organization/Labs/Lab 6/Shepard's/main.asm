; Sample Code for Lab 6
; This sample code implements the int main() function

.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int main()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Main's return value
LD R6, STACK_BASE		; R6 = x6000

; Main's return address
ADD R6, R6, #-1			; R6 = x5FFF
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1			; R6 = x5FFE
STR R5, R6, #0

; Set frame pointer
ADD R5, R6, #0			; R5 = R6 = x5FFE

; node_t *head
ADD R6, R6, #-1			; R6 = x5FFD
AND R0, R0, #0			; R0 = 0
STR R0, R6, #0

; char selection
ADD R6, R6, #-1			; R6 = x5FFC
LD R0, LOWERCASE_S		; R0 = 's'
STR R0, R6, #0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while(selection != 'q')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Perform the check for the while loop
; We check to see if char selection is equal to 'q'
; If equal, quit
; It not equal, continue running the loop
CHECK_WHILE
LDR R0, R5, #-2			; R0 = char selection
LD R1, LOWERCASE_Q
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRz BREAK_WHILE_LOOP

; Print the options menu
LEA R0, PROMPT_MENU
PUTS

; Get a character from the keyboard and put it in selection
; (We don't have to write our own scanf() function)
GETC
STR R0, R5, #-2			; Store the character on the runtime stack in char selection (R0 = char selection)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if(selection == 'p')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'p'
LD R1, LOWERCASE_P
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_A			; If not equal to 'p' check 'a'

; Display prompt
LEA R0, PROMPT_PRINT
PUTS

; node_t **head (&head) (input to printList())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

JSR PRINT_LIST
AND R0, R0, #0
ADD R0, R0, #10
OUT

; Pop return value (void)
ADD R6, R6, #1			; R6 = x5FF9

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if(selection == 'a')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'a'
ELSE_IF_A
LD R1, LOWERCASE_A
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_R

; int a
ADD R6, R6, #-1			; R6 = x5FFB
AND R0, R0, #0
STR R0, R6, #0

; Display prompt
LEA R0, PROMPT_ADD
PUTS

; Call TRAP service routine for getting number here
; For testing purposes, let's use 12
AND R0, R0, #0			; Comment this out after implementing your TRAP service routine
TRAP x40
;ADD R0, R0, #12			; Comment this out after implementing your TRAP service routine

; Store number entered into int a
STR R0, R5, #-3
AND R0, R0, #0
ADD R0, R0, #10
OUT

; node_t **head (&head) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int added (a) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

JSR ADD_VALUE

; Pop return value (void)
ADD R6, R6, #1			; R6 = x5FF9

; Pop int added
ADD R6, R6, #1			; R6 = x5FFA

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

; Pop int a
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if(selection == 'r')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'r'
ELSE_IF_R
LD R1, LOWERCASE_R
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp CONTINUE_WHILE_LOOP

; int r
ADD R6, R6, #-1			; R6 = x5FFB
AND R0, R0, #0
STR R0, R6, #0

; Display prompt
LEA R0, PROMPT_REMOVE
PUTS

; Call TRAP service routine for getting number here
; For testing purposes, let's use 12
AND R0, R0, #0			; Comment this out after implementing your TRAP service routine
TRAP x40
;ADD R0, R0, #12			; Comment this out after implementing your TRAP service routine

; Store number entered into int r
STR R0, R5, #-3
AND R0, R0, #0
ADD R0, R0, #10
OUT

; node_t **head (&head) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int removed (r) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

JSR REMOVE_VALUE

; Pop return value (void)
ADD R6, R6, #1			; R6 = x5FF9

; Pop int removed
ADD R6, R6, #1			; R6 = x5FFA

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

; Pop int r
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

; Loop back to check the while loop condition again
CONTINUE_WHILE_LOOP
BRnzp CHECK_WHILE

BREAK_WHILE_LOOP

; Pop local variables in main
ADD R6, R6, #2			; R6 = x5FFE

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1			; R6 = x5FFF

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1			; R6 = x6000

HALT

STACK_BASE .FILL x6000

LOWERCASE_A .FILL x0061
LOWERCASE_P .FILL x0070
LOWERCASE_Q .FILL x0071
LOWERCASE_R .FILL x0072
LOWERCASE_S .FILL x0073


PROMPT_MENU .STRINGz 	"Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT .STRINGz 	"\nContents of the linked list: \n"
PROMPT_ADD .STRINGz 	"\nType a number to add: \n"
PROMPT_REMOVE .STRINGz 	"\nType a number to remove: \n"
ARROW .STRINGz 	" -> "


; WORKING - GET IT TO NOT PRINT THE 0 before one digit number

; void printList(node_t **head)
PRINT_LIST
; printList's return value
ADD R6, R6, #-1

; return address
ADD R6, R6, #-1			; R6 =
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1			; R6 =
STR R5, R6, #0

; Set frame pointer
ADD R5, R6, #0			; R5 = R6 =


; Push Reg that will be used TOD0
; R0
ADD R6, R6, #-1			; R6 =
STR R0, R6, #0


; R1
ADD R6, R6, #-1			; R6 =
STR R1, R6, #0


; R2
ADD R6, R6, #-1			; R6 =
STR R2, R6, #0

; create new node called *current
; set its value to be equal to *head
ADD R6, R6, #-1			; R6 =
LDR R1, R5, #3
LDR R1, R1, #0

STR R1, R6, #0

PRINT_LIST_WHILE_LOOP

; R1 = current
LDR R1, R5, #-4
ADD R1, R1, #0
BRz PRINT_LIST_BREAK_WHILE_LOOP

    ; print the current nodes value -> put the value into reg R0 and call the out subroutine


    ; puts the value of the current node into reg R0
    ; call the out subroutine

; Load R0 with current
ADD R0, R1, #0

; Load R0 addrees of with current->value
ADD R0, R0, #1

; Put the value at address R0 into R0
LDR R0, R0, #0

TRAP x41
;AND R0, R0, #0
;ADD R0, R0, #10
;OUT

; Load R0 with current
LDR R1, R5, #-4
ADD R0, R1, #0

; Load R0 addrees of with current->next
ADD R0, R0, #2

; Put the value at address R0 into R0
LDR R0, R0, #0
STR R0, R5, #-4

;ADD R0, R0, #2

; put the value of current->value into current
;STR R0, R5, #-4

; Load R0 with current
LDR R1, R5, #-4
ADD R1, R1, #0
BRz PRINT_LIST_WHILE_IF_BREAK

LEA R0, ARROW
PUTS

PRINT_LIST_WHILE_IF_BREAK
BRnzp PRINT_LIST_WHILE_LOOP
PRINT_LIST_BREAK_WHILE_LOOP


;AND R0, R0, #0
;ADD R0, R0, #10
;OUT
; print new line character ; TODODODODODO

; Do POPS
ADD R6, R6, #1

; REG POPS
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R0, R6, #0
ADD R6, R6, #1

; Frame pointer POPS
LDR R5, R6, #0
ADD R6, R6, #1

; RET address
LDR R7, R6, #0
ADD R6, R6, #1

RET

; WORKING ;

; void addValue(node_t **head, int added)

HEAD .FILL x8000
ADD_VALUE
; addValue's return value
ADD R6, R6, #-1

; return address
ADD R6, R6, #-1			; R6 =
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1			; R6 =
STR R5, R6, #0

; Set frame pointer
ADD R5, R6, #0			; R5 = R6 =


; Push Reg that will be used TOD0
; R0
ADD R6, R6, #-1			; R6 =
STR R0, R6, #0


; R1
ADD R6, R6, #-1			; R6 =
STR R1, R6, #0


; R2
ADD R6, R6, #-1			; R6 =
STR R2, R6, #0

; create new node called *current
; set its value to be equal to *head
ADD R6, R6, #-1			; R1 = x5FFD
LDR R1, R5, #4
LDR R1, R1, #0
;;;; SMTHTHTHTHTHTH HEREE DOUBLE POINTER

STR R1, R6, #0


;;;; PROBLEM, AM I ACCESSING HEAD CORRECTLY?


; load R1 with the value stored in head
LDR R1, R5, #4
LDR R1, R1, #0

;AND R0, R0, #0
ADD R1, R1, #0
; if head == 0, then set head to equal x8000 and x8001 to be its value
BRnp ADD_ELSE

;HEAD .FILL x8000
LD R0, HEAD

LDR R1, R5, #4
STR R0, R1, #0

; Add 1 to R0 to get x8001
ADD R0, R0, #1

; Load R1 with added
LDR R1, R5, #3

; Store added into x8001
STR R1, R0, #0

; Do POPS
ADD R6, R6, #1

; REG POPS
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R0, R6, #0
ADD R6, R6, #1

; Frame pointer POPS
LDR R5, R6, #0
ADD R6, R6, #1

; RET address
LDR R7, R6, #0
ADD R6, R6, #1

RET

ADD_ELSE



; while loop that checks if current != 0,
ADD_WHILE_LOOP

; Node
; value
; next


; R1 = current
LDR R1, R5, #-4

;AND R0, R0, #0
ADD R1, R1, #0
BRz ADD_BREAK_WHILE_LOOP


	;if it is not equal to 0, then checks to see if current->next == 0.

	    ; Load R2 with current->next
            LDR R2, R1, #2
	    ADD R2, R2, #0
	    BRnp ADD_WHILE_IF_BREAK

	    ; make 8002 (next) point to x8003
	    ADD R0, R1, #3
	    STR R0, R1, #2

	    ; set the value of the new node to be equal to added
	    LDR R0, R5, #3
	    STR R0, R1, #4


	    ; do pops
	    ADD R6, R6, #1

	    ; REG POPS
	    LDR R2, R6, #0
	    ADD R6, R6, #1
	    LDR R1, R6, #0
	    ADD R6, R6, #1
	    LDR R0, R6, #0
	    ADD R6, R6, #1

	    ; Frame pointer POPS
	    LDR R5, R6, #0
	    ADD R6, R6, #1

	    ; RET address
	    LDR R7, R6, #0
	    ADD R6, R6, #1

	    RET
	    ;return

	; if it is not equal to 0, then current = current->next
        ADD_WHILE_IF_BREAK


	; current = current->next
	STR R2, R5, #-4


BRnzp ADD_WHILE_LOOP
ADD_BREAK_WHILE_LOOP

; do pops
ADD R6, R6, #1

; REG POPS
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R0, R6, #0
ADD R6, R6, #1

; Frame pointer POPS
LDR R5, R6, #0
ADD R6, R6, #1

; RET address
LDR R7, R6, #0
ADD R6, R6, #1

;return
RET



; NOT WORKING ;

; void removeValue(node_t **head, int removed)
REMOVE_VALUE
; removeValue's return value
ADD R6, R6, #-1

; return address
ADD R6, R6, #-1			; R6 =
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1			; R6 =
STR R5, R6, #0

; Set frame pointer
ADD R5, R6, #0			; R5 = R6 =

; Push Reg that will be used TOD0
; R0
ADD R6, R6, #-1			; R6 =
STR R0, R6, #0


; R1
ADD R6, R6, #-1			; R6 =
STR R1, R6, #0


; R2
ADD R6, R6, #-1			; R6 =
STR R2, R6, #0



; create new node called *prev
; set its value to be equal to *head
ADD R6, R6, #-1			; R1 = x5FFD
LDR R1, R5, #4
LDR R1, R1, #0
STR R1, R6, #0


; load R0 with the value stored in the head->value
LDR R0, R1, #1

; load R1 with the value stored in removed
LDR R1, R5, #3

NOT R1, R1
ADD R1, R1, #1

; Check to see if they are equal to each other
ADD R0, R1, R0
BRnp REMOVE_ELSE

; Set head to be equal to head->next

; R1 has head
LDR R1, R5, #-4
; LOAD R1 with value in head
ADD R1, R1, #2
LDR R1, R1, #0
ADD R2, R1, #0


; Store head->next into head
LDR R1, R5, #4
STR R2, R1, #0

; Load prev into R1
;LDR R1, R5, #-4
;LDR R1, R1, #0

; Store 0 into head
AND R0, R0, #0
STR R0, R5, #4



; Do POPS
ADD R6, R6, #1

; REG POPS
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R0, R6, #0
ADD R6, R6, #1

; Frame pointer POPS
LDR R5, R6, #0
ADD R6, R6, #1

; RET address
LDR R7, R6, #0
ADD R6, R6, #1

RET


; WORKING UP TO HEREE
;:::
REMOVE_ELSE


; create new node called *current
; set its value to be equal to *head->next
ADD R6, R6, #-1			; R6 =
LDR R1, R5, #4
LDR R1, R1, #0
ADD R1, R1, #2
LDR R1, R1, #0

STR R1, R6, #0


REMOVE_WHILE_LOOP
LDR R1, R5, #-5
ADD R1, R1, #0
BRz REMOVE_BREAK_WHILE_LOOP


; load R0 with the value stored in the current->value
ADD R1, R1, #1
LDR R0, R1, #0

; load R1 with the value stored in removed
LDR R1, R5, #3


NOT R1, R1
ADD R1, R1, #1

; Check to see if they are equal to each other
ADD R0, R1, R0
BRnp REMOVE_WHILE_ELSE



; Set prev->next to be equal to current->next

; R1 has prev
LDR R1, R5, #-4
; R1 has addess of prev->next i.e. x8002
ADD R1, R1, #2

; R0 has current
LDR R0, R5, #-5
; R0 has current->next
ADD R0, R0, #2
LDR R0, R0, #0
; !!!! SHOULD THIS BE VALUE AT CURRENT->NEXT ????

; Store current->next into prev->next
STR R0, R1, #0


; R0 has current
LDR R0, R5, #-5

AND R1, R1, #0
STR R1, R0, #0

; R0 has current
LDR R0, R5, #-5

; R1 has prev
LDR R1, R5, #-4
; R1 has addess of prev->next i.e. x8002
ADD R1, R1, #2

; Get value at current->next
LDR R1, R1, #0


STR R1, R0, #0


REMOVE_WHILE_ELSE

; R1 has prev
LDR R1, R5, #-4

; R0 has current
LDR R0, R5, #-5

; Store current into prev
STR R0, R5, #-4

; Put current->next into R0
ADD R0, R0, #2
LDR R0, R0, #0
; Put value of current->next into current
STR R0, R5, #-5

BRnzp REMOVE_WHILE_LOOP
; POPS


REMOVE_BREAK_WHILE_LOOP


; do pops
ADD R6, R6, #1
ADD R6, R6, #1

; REG POPS
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R0, R6, #0
ADD R6, R6, #1

; Frame pointer POPS
LDR R5, R6, #0
ADD R6, R6, #1

; RET address
LDR R7, R6, #0
ADD R6, R6, #1

RET

.END
