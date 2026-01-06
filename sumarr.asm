.MODEL SMALL
.STACK 100H

.DATA
    PROMPT_COUNT DB 'Enter number of elements (max 10): $'
    PROMPT_ELEMENT DB 0DH, 0AH, 'Enter element: $' ; Space for index
    RESULT_MSG DB 0DH, 0AH, 'The sum is: $'
    ARRAY DB 10 DUP(?) ; Array to store up to 10 bytes (elements)
    ARRAY_SIZE DB ?    ; To store the actual number of elements
    SUM DW 0             ; Word (16-bit) to store the sum

.CODE
MAIN PROC
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ; 1. Get Array Size from User
    LEA DX, PROMPT_COUNT
    MOV AH, 09H
    INT 21H

    ; Get N (number of elements)
    MOV AH, 01H         ; Function to read character with echo
    INT 21H             ; AL = ASCII code of the character
    SUB AL, '0'         ; Convert ASCII digit to numeric value
    MOV ARRAY_SIZE, AL    ; Store N in ARRAY_SIZE

    ; 2. Get Array Elements from User
    MOV CH, 0           ; Clear high byte of CX
    MOV CL, ARRAY_SIZE  ; Loop counter (N)
    MOV SI, OFFSET ARRAY  ; SI points to the start of the array

INPUT_LOOP:
    ; Display Prompt_Element
    LEA DX, PROMPT_ELEMENT
    MOV AH, 09H
    INT 21H
    
    ; Get Element Input
    MOV AH, 01H         ; Function to read character with echo
    INT 21H             ; AL = ASCII code of the character
    SUB AL, '0'         ; Convert ASCII digit to numeric value
    MOV [SI], AL          ; Store element in array

    INC SI                ; Move to the next array slot
    LOOP INPUT_LOOP       ; Decrement CX and jump if not zero

    ; 3. Calculate Sum
    MOV CX, 0           ; Clear CX
    MOV CL, ARRAY_SIZE  ; Loop counter (N)
    MOV SI, OFFSET ARRAY  ; SI points to the start of the array
    
SUM_LOOP:
    MOV AL, [SI]        ; Load array element (byte)
    CBW                 ; Convert Byte to Word (AX = AL, AH=0)
    ADD SUM, AX         ; Add to the running sum (SUM is DW)
    INC SI              ; Move to next element
    LOOP SUM_LOOP

    ; 4. Display Result
    LEA DX, RESULT_MSG
    MOV AH, 09H
    INT 21H

    MOV AX, SUM         ; AX = Sum (16-bit)
    CALL DISPLAY_WORD   ; Display the 16-bit sum

    ; Exit Program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

DISPLAY_WORD PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX, 0           ; CX = digit counter
    MOV BX, 10          ; Divisor (base 10)

CONVERT_LOOP:
    MOV DX, 0           ; Clear DX for division (DX:AX / 10)
    DIV BX              ; AX = quotient, DX = remainder
    PUSH DX             ; Push remainder (digit) onto stack
    INC CX              ; Increment digit counter
    CMP AX, 0
    JNE CONVERT_LOOP

DISPLAY_LOOP:
    POP DX              ; Get digit from stack
    ADD DL, '0'         ; Convert digit to ASCII
    MOV AH, 02H         ; Function to display character
    INT 21H
    LOOP DISPLAY_LOOP   ; Decrement CX and jump if not zero

    POP SI
    POP DX 
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_WORD ENDP

END MAIN