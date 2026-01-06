; Title: Average of Array Elements (User Input)
; Target: 8086 Assembly (MASM)
; Environment: DOSBox

.MODEL SMALL
.STACK 100H

.DATA
    PROMPT_COUNT    DB 'Enter number of elements (max 9): $' ; Max 9 to ensure average is single digit for simple display
    PROMPT_ELEMENT  DB 0DH, 0AH, 'Enter element [  ]: $'
    RESULT_MSG_SUM  DB 0DH, 0AH, 'The sum is: $'
    RESULT_MSG_AVG  DB 0DH, 0AH, 'The average is: $'
    ARRAY           DB 9 DUP(?)  ; Array to store up to 9 bytes
    ARRAY_SIZE      DB ?         ; To store the actual number of elements
    CURRENT_INDEX   DB '0'       ; To display current element index
    SUM             DW 0         ; Word (16-bit) to store the sum

.CODE
MAIN PROC
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ; --------------------------------------
    ; 1. Get Array Size from User
    ; --------------------------------------
    LEA DX, PROMPT_COUNT
    MOV AH, 09H
    INT 21H

    CALL GET_SINGLE_DIGIT ; Get N (number of elements)
    MOV ARRAY_SIZE, AL    ; Store N in ARRAY_SIZE

    ; Check for division by zero (N=0)
    CMP AL, 0
    JE EXIT_PROG

    ; --------------------------------------
    ; 2. Get Array Elements from User
    ; --------------------------------------
    MOV CL, ARRAY_SIZE  ; Loop counter (N)
    MOV CH, 0           ; Clear high byte of CX
    MOV SI, OFFSET ARRAY  ; SI points to the start of the array
    MOV BL, 0           ; BL holds the current index for display

INPUT_LOOP:
    ; Display Prompt_Element
    CALL DISPLAY_INDEX_PROMPT
    
    ; Get Element Input
    CALL GET_SINGLE_DIGIT ; AL now holds the element (numeric value)
    MOV [SI], AL          ; Store element in array

    INC SI                ; Move to the next array slot
    INC BL                ; Increment index
    LOOP INPUT_LOOP       ; Decrement CX and jump if not zero

    ; --------------------------------------
    ; 3. Calculate Sum
    ; --------------------------------------
    MOV CX, 0
    MOV CL, ARRAY_SIZE  ; Loop counter (N)
    MOV SI, OFFSET ARRAY
    
SUM_LOOP:
    MOV AL, [SI]        ; Load array element (byte)
    CBW                 ; Convert Byte to Word (AX = AL, AH=0)
    ADD SUM, AX         ; Add to the running sum (SUM is DW)
    INC SI              ; Move to next element
    LOOP SUM_LOOP

    ; --------------------------------------
    ; 4. Calculate Average (Average = Sum / N)
    ; --------------------------------------
    
    ; Load Sum into AX for division
    MOV AX, SUM         ; AX = Sum (Dividend)
    
    ; Load N (Array Size) into BL
    MOV BL, ARRAY_SIZE  ; BL = N (Divisor)
    MOV BH, 0           ; BH must be 0 for DIV BL
    
    ; The division is 16-bit (AX) / 8-bit (BL)
    ; Result: AL = Quotient (Average), AH = Remainder
    DIV BL
    
    MOV BL, AL          ; Store the quotient (Average) in BL
    
    ; --------------------------------------
    ; 5. Display Result
    ; --------------------------------------
    
    ; Display Sum
    LEA DX, RESULT_MSG_SUM
    MOV AH, 09H
    INT 21H
    MOV AX, SUM         ; AX = Sum (16-bit)
    CALL DISPLAY_WORD   ; Display the 16-bit sum
    
    ; Display Average
    LEA DX, RESULT_MSG_AVG
    MOV AH, 09H
    INT 21H
    
    MOV DL, BL          ; Load Average (quotient) into DL
    ADD DL, '0'         ; Convert numeric value to ASCII character
    MOV AH, 02H         ; Function to display character
    INT 21H

    ; --------------------------------------
    ; Exit Program
    ; --------------------------------------
EXIT_PROG:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; -------------------------------------------------------------------
; Subroutine: GET_SINGLE_DIGIT (same as before)
; Reads a single digit from the user and returns the numeric value 
; in AL.
; -------------------------------------------------------------------
GET_SINGLE_DIGIT PROC
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    RET
GET_SINGLE_DIGIT ENDP

; -------------------------------------------------------------------
; Subroutine: DISPLAY_INDEX_PROMPT (same as before)
; Displays the "Enter element [X]: " prompt, where X is the current
; index stored in BL.
; -------------------------------------------------------------------
DISPLAY_INDEX_PROMPT PROC
    ; Update the prompt with the current index (BL)
    PUSH AX ; Preserve AX
    PUSH DX ; Preserve DX
    ADD BL, '0' ; Convert numeric index in BL to ASCII
    MOV PROMPT_ELEMENT[17], BL ; Place the index into the prompt string
    SUB BL, '0' ; Convert BL back to numeric

    ; Display the prompt
    LEA DX, PROMPT_ELEMENT
    MOV AH, 09H
    INT 21H
    POP DX
    POP AX
    RET
DISPLAY_INDEX_PROMPT ENDP

; -------------------------------------------------------------------
; Subroutine: DISPLAY_WORD (same as before)
; Displays a 16-bit number in AX to the console (decimal format).
; Used here for displaying the SUM.
; -------------------------------------------------------------------
DISPLAY_WORD PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX, 0
    MOV BX, 10

CONVERT_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE CONVERT_LOOP

DISPLAY_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP DISPLAY_LOOP

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_WORD ENDP

END MAIN