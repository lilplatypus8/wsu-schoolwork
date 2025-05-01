.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int main()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize Default Selection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INIT_SELECTION
LEA R0, LOWERCASE_S            ; Load address of LOWERCASE_S into R0
LDR R0, R0, #0                 ; Dereference the address to get its value
STR R0, R5, #-2                ; Store the default selection in `selection`

; Initialize runtime stack and node memory tracker
LD R6, STACK_BASE          ; R6 = x6000 (stack pointer)
LD R2, LIST_BASE           ; R2 = x8000 (next available node address)

; Main's return address
ADD R6, R6, #-1            ; Push space for return address
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1            ; Push space for frame pointer
STR R5, R6, #0

; Set frame pointer
ADD R5, R6, #0             ; R5 = frame pointer

; Local variables
ADD R6, R6, #-1            ; Push head (node_t *head)
AND R0, R0, #0             ; head = NULL
STR R0, R6, #0

ADD R6, R6, #-1            ; Push selection (char selection)
LD R0, LOWERCASE_S         ; Default selection = 's'
STR R0, R6, #0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while (selection != 'q')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_WHILE
LDR R0, R5, #-2                ; Load `selection` into R0
LEA R1, LOWERCASE_Q            ; Load address of LOWERCASE_Q into R1
LDR R1, R1, #0                 ; Dereference to get ASCII value of 'q'
NOT R1, R1                     ; Compute -ASCII('q')
ADD R1, R1, #1
ADD R1, R0, R1                 ; Check if `selection` == 'q'
BRz BREAK_WHILE_LOOP           ; If so, exit loop


; Print menu and get user input
LEA R0, PROMPT_MENU
PUTS
GETC
STR R0, R5, #-2            ; Update selection

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if (selection == 'p') -> Print List
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LD R1, LOWERCASE_P
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_A

LEA R0, PROMPT_PRINT
PUTS

; Call printList(&head)
ADD R6, R6, #-1            ; Push &head
ADD R0, R5, #-1            ; R0 = &head
STR R0, R6, #0

JSR PRINT_LIST             ; Call printList

ADD R6, R6, #1             ; Pop &head
BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if (selection == 'a') -> Add Value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE_IF_A
LD R1, LOWERCASE_A
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_R

LEA R0, PROMPT_ADD
PUTS
TRAP x40                   ; Get number (value to add)

; Call addValue(&head, value)
ADD R6, R6, #-1            ; Push value
STR R0, R6, #0

ADD R6, R6, #-1            ; Push &head
ADD R0, R5, #-1
STR R0, R6, #0

JSR ADD_VALUE              ; Call addValue

ADD R6, R6, #1             ; Pop &head
ADD R6, R6, #1             ; Pop value
BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if (selection == 'r') -> Remove Value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE_IF_R
LD R1, LOWERCASE_R
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp CONTINUE_WHILE_LOOP

LEA R0, PROMPT_REMOVE
PUTS
TRAP x40                   ; Get number (value to remove)

; Call removeValue(&head, value)
ADD R6, R6, #-1            ; Push value
STR R0, R6, #0

ADD R6, R6, #-1            ; Push &head
ADD R0, R5, #-1
STR R0, R6, #0

JSR REMOVE_VALUE           ; Call removeValue

ADD R6, R6, #1             ; Pop &head
ADD R6, R6, #1             ; Pop value
BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of While Loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CONTINUE_WHILE_LOOP
BRnzp CHECK_WHILE

BREAK_WHILE_LOOP

; Restore main's frame and exit
ADD R6, R6, #2             ; Pop local variables
LDR R5, R6, #0             ; Restore frame pointer
ADD R6, R6, #1
LDR R7, R6, #0             ; Restore return address
ADD R6, R6, #1
HALT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; printList(node_t **head)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_LIST
ADD R6, R6, #-1            ; Push return address
STR R7, R6, #0
ADD R6, R6, #-1            ; Push previous frame pointer
STR R5, R6, #0
ADD R5, R6, #0             ; Set frame pointer

LDR R0, R5, #2             ; R0 = **head
LDR R0, R0, #0             ; R0 = *head

PRINT_LOOP
BRz PRINT_DONE             ; If current == NULL, done
LDR R1, R0, #0             ; R1 = current->value
OUT                        ; Print value
LDR R0, R0, #1             ; R0 = current->next
BRnzp PRINT_LOOP

PRINT_DONE
LDR R5, R6, #0             ; Pop previous frame pointer
ADD R6, R6, #1
LDR R7, R6, #0             ; Pop return address
ADD R6, R6, #1
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; addValue(node_t **head, int value)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ADD_VALUE
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

LDR R0, R5, #4             ; **head
LDR R0, R0, #0             ; *head
BRz ADD_FIRST_NODE

ADD_LOOP
LDR R1, R0, #1             ; R1 = current->next
BRz ADD_DONE
ADD R0, R1, #0
BRnzp ADD_LOOP

ADD_DONE
LDR R1, R5, #5             ; R1 = value
STR R1, R2, #0             ; newNode->value
AND R1, R1, #0
STR R1, R2, #1             ; newNode->next = NULL
STR R2, R0, #1             ; current->next = newNode
ADD R2, R2, #2             ; Increment node tracker
BRnzp ADD_EXIT

ADD_FIRST_NODE
LDR R1, R5, #5
STR R1, R2, #0
AND R1, R1, #0
STR R1, R2, #1
LDR R1, R5, #4
STR R2, R1, #0
ADD R2, R2, #2

ADD_EXIT
LDR R5, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; removeValue(node_t **head, int value)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REMOVE_VALUE
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

LDR R0, R5, #4             ; **head
LDR R0, R0, #0             ; *head
LDR R1, R5, #5             ; Value to remove
BRz REMOVE_DONE

REMOVE_LOOP
LDR R2, R0, #1             ; R2 = current->next
LDR R3, R2, #0             ; R3 = next->value
ADD R3, R3, R1             ; Check for match
BRz REMOVE_FOUND
ADD R0, R2, #0             ; Advance to next node
BRnzp REMOVE_LOOP

REMOVE_FOUND
LDR R3, R2, #1             ; next->next
STR R3, R0, #1             ; current->next = next->next

REMOVE_DONE
LDR R5, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data Section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STACK_BASE .FILL x6000
LIST_BASE .FILL x8000

PROMPT_MENU  .STRINGZ "\n(p) Print list\n(a) Add value\n(r) Remove value\n(q) Quit\n> "
PROMPT_PRINT .STRINGZ "\nPrinting list:\n"
PROMPT_ADD   .STRINGZ "\nEnter value to add: "
PROMPT_REMOVE .STRINGZ "\nEnter value to remove: "
LOWERCASE_Q  .FILL x0071
LOWERCASE_P  .FILL x0070
LOWERCASE_A  .FILL x0061
LOWERCASE_R  .FILL x0072
LOWERCASE_S  .FILL x0073

.END
