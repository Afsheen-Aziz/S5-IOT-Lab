; Title: Array Reversal (User Input)
; Target: 8086 Assembly (MASM)
; Environment: DOSBox

.MODEL SMALL
.STACK 100H

.DATA
    MAX_ELEMENTS    EQU 9
    
    PROMPT_COUNT    DB 'Enter number of elements (max 9): $'
    PROMPT_ELEMENT  DB 0DH, 0AH, 'Enter element [  ]: $'
    MSG_ORIGINAL    DB 0DH, 0AH, 'Original Array: $'
    MSG_REVERSED    DB 0DH, 0AH, 'Reversed Array: $'
    SPACE_CHAR      DB ' $' ; Space for display separation
    
    ARRAY           DB MAX_ELEMENTS DUP(?) ; Array to store input elements (0-9)
    ARRAY_SIZE      DB ?                   ; Actual number of elements
    CURRENT_INDEX   DB '0'                 ; To display current element index

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

    ; --------------------------------------
    ; 2. Get Array Elements from User
    ; --------------------------------------
    MOV CL, ARRAY_SIZE      ; Loop counter (N)
    MOV CH, 0               ; Clear high byte of CX
    MOV SI, OFFSET ARRAY    ; SI points to the start of the input array
    MOV BL, 0               ; BL holds the current index for display

INPUT_LOOP:
    CALL DISPLAY_INDEX_PROMPT
    
    CALL GET_SINGLE_DIGIT   ; AL now holds the element (numeric value 0-9)
    MOV [SI], AL            ; Store element in array

    INC SI                  ; Move to the next array slot
    INC BL                  ; Increment index for display
    LOOP INPUT_LOOP         ; Decrement CX and jump if not zero

    ; --------------------------------------
    ; 3. Display Original Array
    ; --------------------------------------
    LEA DX, MSG_ORIGINAL
    MOV AH, 09H
    INT 21H
    CALL DISPLAY_ARRAY
    
    ; --------------------------------------
    ; 4. Reverse the Array (In-place Swap)
    ; --------------------------------------
    MOV AL, ARRAY_SIZE      ; AL = N
    CMP AL, 0
    JE DISPLAY_REVERSED     ; If N=0, skip reversal
    
    ; Calculate (N / 2) - This is the number of swaps needed
    MOV AH, 0               ; Clear AH for division
    MOV BL, 2               ; Divisor (2)
    DIV BL                  ; AL = Quotient (N/2), AH = Remainder
    MOV CL, AL              ; CL = Swap count (N/2)
    MOV CH, 0
    
    ; Setup Pointers
    MOV SI, OFFSET ARRAY    ; SI points to the first element (start index)
    MOV DI, OFFSET ARRAY    ; DI points to the array
    MOV BL, ARRAY_SIZE      ; BL = N
    DEC BL                  ; BL = N - 1 (offset of the last element)
    ADD DI, BX              ; DI points to the last element (end index)
    
SWAP_LOOP:
    ; Swap [SI] and [DI]
    MOV AL, [SI]            ; AL = Element at start (ARRAY[i])
    MOV BL, [DI]            ; BL = Element at end (ARRAY[N-1-i])
    
    MOV [SI], BL            ; ARRAY[i] = ARRAY[N-1-i]
    MOV [DI], AL            ; ARRAY[N-1-i] = Original ARRAY[i]

    INC SI                  ; Move start pointer forward
    DEC DI                  ; Move end pointer backward
    
    LOOP SWAP_LOOP          ; Decrement CX and repeat (N/2 times)

    ; --------------------------------------
    ; 5. Display Reversed Array
    ; --------------------------------------
DISPLAY_REVERSED:
    LEA DX, MSG_REVERSED
    MOV AH, 09H
    INT 21H
    CALL DISPLAY_ARRAY
    
    ; --------------------------------------
    ; Exit Program
    ; --------------------------------------
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; -------------------------------------------------------------------
; Subroutine: GET_SINGLE_DIGIT (Reads a single digit, returns numeric AL)
; -------------------------------------------------------------------
GET_SINGLE_DIGIT PROC
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    RET
GET_SINGLE_DIGIT ENDP

; -------------------------------------------------------------------
; Subroutine: DISPLAY_INDEX_PROMPT (Displays the element input prompt)
; -------------------------------------------------------------------
DISPLAY_INDEX_PROMPT PROC
    PUSH AX
    PUSH DX
    
    ADD BL, '0' ; Convert numeric index in BL to ASCII
    MOV PROMPT_ELEMENT[17], BL
    SUB BL, '0' ; Convert BL back to numeric

    LEA DX, PROMPT_ELEMENT
    MOV AH, 09H
    INT 21H
    
    POP DX
    POP AX
    RET
DISPLAY_INDEX_PROMPT ENDP

; -------------------------------------------------------------------
; Subroutine: DISPLAY_ARRAY (Displays the contents of the ARRAY)
; -------------------------------------------------------------------
DISPLAY_ARRAY PROC
    PUSH CX
    PUSH SI
    PUSH AX
    PUSH DX
    
    MOV CL, ARRAY_SIZE      ; CL = N (Loop Count)
    MOV CH, 0
    MOV SI, OFFSET ARRAY    ; SI points to the start of the array
    
DISPLAY_LOOP:
    MOV AL, [SI]            ; Get array element (numeric 0-9)
    MOV DL, AL
    ADD DL, '0'             ; Convert to ASCII
    
    MOV AH, 02H             ; Display character function
    INT 21H
    
    ; Display a space for separation
    LEA DX, SPACE_CHAR
    MOV AH, 09H
    INT 21H
    
    INC SI                  ; Move to next element
    LOOP DISPLAY_LOOP

    POP DX
    POP AX
    POP SI
    POP CX
    RET
DISPLAY_ARRAY ENDP

END MAIN