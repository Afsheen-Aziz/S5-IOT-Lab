; Title: Frequency of Array Elements (User Input)
; Target: 8086 Assembly (MASM)
; Environment: DOSBox

.MODEL SMALL
.STACK 100H

.DATA
    MAX_ELEMENTS    EQU 9
    
    PROMPT_COUNT    DB 'Enter number of elements (max 9): $'
    PROMPT_ELEMENT  DB 0DH, 0AH, 'Enter element [  ]: $'
    RESULT_MSG_HEAD DB 0DH, 0AH, '--- Frequencies ---', 0DH, 0AH, '$'
    FREQ_MSG        DB 'Element : Count', 0DH, 0AH, '$' ; Template: 'X : Y'
    
    ARRAY           DB MAX_ELEMENTS DUP(?) ; Array to store input elements (0-9)
    ARRAY_SIZE      DB ?                   ; Actual number of elements
    
    ; Tally array: Index 0 stores frequency of element '0', Index 1 for '1', etc.
    TALLY           DB 10 DUP(0)           ; 10 slots (for elements 0 through 9), initialized to 0
    
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

    ; Get N (number of elements)
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV ARRAY_SIZE, AL    ; Store N in ARRAY_SIZE

    ; --------------------------------------
    ; 2. Get Array Elements and Tally Frequencies
    ; --------------------------------------
    MOV CL, ARRAY_SIZE      ; Outer loop counter (N)
    MOV CH, 0               ; Clear high byte of CX
    MOV SI, OFFSET ARRAY    ; SI points to the start of the input array
    MOV BL, 0               ; BL holds the current index for display

INPUT_LOOP:
    ; Display Prompt_Element
    LEA DX, PROMPT_ELEMENT
    MOV AH, 09H
    INT 21H
    
    ; Get Element Input
    MOV AH,01H 
    INT 21H; AL now holds the element (numeric value 0-9)
    SUB AL, '0'         ; Convert ASCII digit to numeric value
    
    ; --- Tally Logic ---
    ; AL contains the element value (0-9). This value is the index into TALLY.
    MOV BH, 0               ; Clear BH (High byte of BX)
    MOV BL, AL              ; BL = element value (0-9)
    MOV DI, OFFSET TALLY    ; DI points to the start of the TALLY array
    ADD DI, BX              ; DI now points to TALLY[element value]
    
    INC BYTE PTR [DI]       ; Increment the count at that TALLY position
    ; --- End Tally Logic ---

    MOV [SI], AL            ; Store element in the main array (optional, but good practice)

    INC SI                  ; Move to the next array slot
    INC BL                  ; Increment index for display
    LOOP INPUT_LOOP         ; Decrement CX and jump if not zero

    ; --------------------------------------
    ; 3. Display Results
    ; --------------------------------------
    LEA DX, RESULT_MSG_HEAD
    MOV AH, 09H
    INT 21H

    MOV CX, 10              ; Loop 10 times (for elements 0 through 9)
    MOV SI, OFFSET TALLY    ; SI points to the TALLY array
    MOV AL, 0               ; AL holds the current element value (0-9)

DISPLAY_LOOP:
    ; Check if the frequency (TALLY[AL]) is > 0
    MOV BL, [SI]            ; BL = Tally count for the current element
    CMP BL, 0
    JE NEXT_ELEMENT         ; If count is 0, skip display

    ; --- Display Frequency ---
    
    ; Display Element Value
    PUSH AX                 ; Save AL (current element value)
    MOV DL, AL              ; Load element value (0-9)
    ADD DL, '0'             ; Convert to ASCII
    MOV FREQ_MSG[8], DL     ; Place element value into template 'Element X'
    POP AX                  ; Restore AL
    
    ; Display Count
    MOV DL, BL              ; Load count (0-9)
    ADD DL, '0'             ; Convert to ASCII
    MOV FREQ_MSG[14], DL    ; Place count into template 'Count Y'
    
    ; Display the complete message
    LEA DX, FREQ_MSG
    MOV AH, 09H
    INT 21H
    
NEXT_ELEMENT:
    INC SI                  ; Move to the next TALLY entry
    INC AL                  ; Move to the next element value (0 -> 1 -> ... -> 9)
    LOOP DISPLAY_LOOP       ; Decrement CX and jump if not zero

    ; --------------------------------------
    ; Exit Program
    ; --------------------------------------
    MOV AH, 4CH
    INT 21H
MAIN ENDP


END MAIN