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
OUT
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

; printList's return value
ADD R6, R6, #-1            ; R6 = x5FF9

JSR PRINT_LIST

; Pop return value (void)
ADD R6, R6, #1			; R6 = x5FFA

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
TRAP x40 ; INPUT
; For testing purposes, let's use 12
; AND R0, R0, #0			; Comment this out after implementing your TRAP service routine
; ADD R0, R0, #12			; Comment this out after implementing your TRAP service routine

; Store number entered into int a
STR R0, R5, #-3

; node_t **head (&head) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int added (a) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

; addValue's return value
ADD R6, R6, #-1         ; R6 = x5FF8

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
TRAP x40 ; INPUT
; For testing purposes, let's use 12
AND R0, R0, #0			; Comment this out after implementing your TRAP service routine
ADD R0, R0, #12			; Comment this out after implementing your TRAP service routine

; Store number entered into int r
STR R0, R5, #-3

; node_t **head (&head) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int removed (r) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

; removeValue's return value
ADD R6, R6, #-1         ; R6 = x5FF8

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

NEWLINE .FILL x000A
LOWERCASE_A .FILL x0061
LOWERCASE_P .FILL x0070
LOWERCASE_Q .FILL x0071
LOWERCASE_R .FILL x0072
LOWERCASE_S .FILL x0073

PROMPT_MENU .STRINGz 	"Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT .STRINGz 	"\nContents of the linked list: \n"
PROMPT_ADD .STRINGz 	"\nType a number to add: \n"
PROMPT_REMOVE .STRINGz 	"\nType a number to remove: \n"
LIST_BASE .FILL x8000


; void printList(node_t **head)
PRINT_LIST
ADD R6, R6, #-1 ; push return address
STR R7, R6, #0

ADD R6, R6, #-1 ; push previous frame pointer
STR R5, R6, #0
ADD R5, R6, #0 ; set frame pointer

; TODO: printList implementation
ADD R6, R6, #-1 ; push node_t *current

LDR R1, R5, #3
LDR R1, R1, #0
STR R1, R6, #0
BRz PRINT_DONE

PRINT_LOOP
    LDR R0, R1, #0
    LDR R1, R1, #1
    STR R1, R6, #0
    BRz PRINT_DONE
    LEA R0, SEPARATOR
    PUTS
BRnzp PRINT_LOOP
PRINT_DONE
LD R0, NEWLINE
OUT

ADD R6, R6, #1 ; pop *current
; end printlist

LDR R5, R6, #0 
ADD R6, R6, #1 ; pop previous frame pointer

LDR R7, R6, #0
ADD R6, R6, #1 ; pop return address
RET
SEPARATOR .STRINGZ " -> "

; void addValue(node_t **head, int added)
ADD_VALUE
ADD R6, R6, #-1 ; push return address
STR R7, R6, #0

ADD R6, R6, #-1 ; push previous frame pointer
STR R5, R6, #0
ADD R5, R6, #0 ; set frame pointer

; TODO: addValue implementation
ADD R6, R6, #-1

LDR R0, R5, #4 ; **head
LDR R0, R0, #0 ; *head
STR R0, R6, #0 ; *current = *head
BRnp ADD_BEGIN ; if head is null, new list
    LD R0, LIST_BASE ; new node addr
    LDR R1, R5, #3 ; int a 
    STR R1, R0, #0 ; set value
    AND R1, R1, #0
    STR R1, R0, #1 ; set next node to null
    LDR R1, R5, #4 ; **head
    STR R0, R1, #0 ; *head
BRnzp ADD_DONE

ADD_BEGIN
LDR R0, R6, #0
ADD_LOOP
    LDR R1, R0, #1
    BRz ADD_LOOP_DONE
    ADD R0, R0, #2 ; addr of next node
    STR R0, R6, #0 ; update current node
BRnp ADD_LOOP

ADD_LOOP_DONE

ADD R0, R0, #2 ; addr of next node
LDR R1, R5, #3
STR R1, R0, #0
AND R1, R1, #0
STR R1, R0, #1
STR R0, R0, #-1

ADD_DONE
ADD R0, R0, #1

LDR R5, R6, #0 
ADD R6, R6, #1 ; pop previous frame pointer

LDR R7, R6, #0
ADD R6, R6, #1 ; pop return address
RET

; void removeValue(node_t **head, int removed)
REMOVE_VALUE
ADD R6, R6, #-1 ; push return address
STR R7, R6, #0

ADD R6, R6, #-1 ; push previous frame pointer
STR R5, R6, #0
ADD R5, R6, #0 ; set frame pointer

; Push local variables
ADD R6, R6, #-1 ; push node_t *current
ADD R6, R6, #-1 ; push node_t *prev

; Initialize current = *head
LDR R0, R5, #3 ; **head
LDR R0, R0, #0 ; *head
STR R0, R6, #0 ; current = *head
AND R0, R0, #0 ; prev = NULL
STR R0, R6, #-1

REMOVE_LOOP
LDR R0, R6, #0 ; Load current
BRz REMOVE_DONE ; If current is NULL, exit loop

; Check if current->value == removed
LDR R1, R0, #0 ; current->value
LDR R2, R5, #4 ; removed
NOT R2, R2
ADD R2, R2, #1
ADD R2, R1, R2
BRz REMOVE_FOUND ; If equal, found node to remove

; Move to next node
LDR R1, R6, #0 ; current
STR R1, R6, #-1 ; prev = current
LDR R0, R1, #1 ; current = current->next
STR R0, R6, #0
BRnzp REMOVE_LOOP

REMOVE_FOUND
LDR R1, R6, #-1 ; prev
BRz REMOVE_HEAD ; If prev == NULL, removing head node

; Update prev->next = current->next
LDR R0, R6, #0 ; current
LDR R2, R0, #1 ; current->next
STR R2, R1, #1 ; prev->next = current->next
BRnzp REMOVE_FREE

REMOVE_HEAD
; Update *head = current->next
LDR R0, R6, #0 ; current
LDR R2, R0, #1 ; current->next
LDR R1, R5, #3 ; **head
STR R2, R1, #0 ; *head = current->next

REMOVE_FREE
; Free current node (if using heap allocation, this would deallocate memory)
LDR R0, R6, #0 ; current
; Memory deallocation simulated as no-op in LC3

REMOVE_DONE
ADD R6, R6, #2 ; Pop local variables (current and prev)

; Restore previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Restore return address
LDR R7, R6, #0
ADD R6, R6, #1
RET


.END