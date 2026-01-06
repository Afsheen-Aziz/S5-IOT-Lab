.MODEL SMALL
.STACK 100H

.DATA
    MSG_PROMPT      DB 0Ah,0Dh,'Enter a number (max 65535):$'
    MSG_PERFECT     DB 0Ah,0Dh,'Result: Is a Perfect Number.$'
    MSG_NOT_PERF    DB 0Ah,0Dh,'Result: Is NOT a Perfect Number.$'
    
    ; Input buffer structure for DOS Function 0Ah
    INPUT_ASCII_BUF LABEL BYTE
    MAX_CHARS       DB 6           ; Max 5 digits + CR
    ACTUAL_CHARS    DB ?           ; Byte 1: Actual count of digits entered
    INPUT_DATA      DB 6 DUP('$')  ; Byte 2 onwards: The ASCII digits themselves
    
    ; Variables
    INPUT_NUM_BIN   DW ?           
    SUM_OF_DIVISORS DW 0           
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

; -----------------------------------------------------------------
; 1. INPUT NUMBER (DOS Function 0Ah)
; -----------------------------------------------------------------
    LEA DX, MSG_PROMPT
    MOV AH, 09H
    INT 21H

    ; Use DOS Function 0Ah for buffered input
    LEA DX, INPUT_ASCII_BUF
    MOV AH, 0AH
    INT 21H
    
    ; Convert ASCII Input to Binary (Result in AX)
    CALL ASCII_TO_BIN
    MOV INPUT_NUM_BIN, AX  
    
    CMP AX, 1
    JLE NOT_PERFECT_DISPLAY
    
; -----------------------------------------------------------------
; 2. PERFECT NUMBER CHECK LOOP
; -----------------------------------------------------------------
    MOV AX, INPUT_NUM_BIN 
    MOV CX, 2               
    MOV DX, 0               
    DIV CX                  ; AX = N / 2, CX = N / 2 (Loop limit)
    MOV CX, AX              

    MOV SI, 1               ; SI = Current divisor (start from 1)
    MOV SUM_OF_DIVISORS, 0  
    
DIVISOR_LOOP:
    CMP SI, CX              
    JG END_DIVISOR_LOOP

    PUSH CX                 ; Save loop limit
    
    MOV AX, INPUT_NUM_BIN   ; AX = N
    MOV DX, 0               ; AX:DX = N
    MOV BX, SI              ; BX = SI (divisor)
    DIV BX                  ; AX = N / SI, DX = N % SI
    
    CMP DX, 0               
    JNE NOT_DIVISOR
    
    ; Is a divisor, add it to the sum
    ADD SUM_OF_DIVISORS, SI
    
NOT_DIVISOR:
    POP CX                  ; Restore loop limit
    
    INC SI                  ; Next divisor
    JMP DIVISOR_LOOP

END_DIVISOR_LOOP:
    
    MOV AX, SUM_OF_DIVISORS
    CMP AX, INPUT_NUM_BIN
    
    JNE NOT_PERFECT_DISPLAY
    
; -----------------------------------------------------------------
; 3. DISPLAY RESULT
; -----------------------------------------------------------------
    LEA DX, MSG_PERFECT
    JMP EXIT_PROGRAM

NOT_PERFECT_DISPLAY:
    LEA DX, MSG_NOT_PERF

EXIT_PROGRAM:
    MOV AH, 09H
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP

; -----------------------------------------------------------------
; PROCEDURE: ASCII_TO_BIN (Fixed pointer initialization)
; -----------------------------------------------------------------
ASCII_TO_BIN PROC
    PUSH CX
    PUSH BX
    PUSH SI
    
    MOV CL, ACTUAL_CHARS    ; CL = actual number of digits entered
    MOV CH, 0               ; CX = loop count (e.g., 2 for '28')
    MOV BX, 0               ; BX = final binary number (accumulator)

    ; *** CRITICAL FIX: SI must point to the THIRD byte of the buffer ***
    ; INPUT_ASCII_BUF + 2 is the correct start address for the first digit.
    MOV SI, OFFSET INPUT_ASCII_BUF + 2
    
CONVERSION_LOOP:
    
    ; 1. Shift BX (accumulator) left by one decimal place: BX = BX * 10
    PUSH CX                 ; Temporarily save loop counter
    MOV AX, BX            
    MOV DX, 0             
    MOV CL, 10            
    MUL CL                ; AX = AX * 10 
    MOV BX, AX            ; BX = new accumulated number
    POP CX                  ; Restore loop counter
    
    ; 2. Add the current digit
    MOV AL, [SI]          ; AL = current ASCII digit
    SUB AL, '0'           
    MOV AH, 0             
    
    ADD BX, AX            ; BX = accumulated number + current digit
    
    INC SI                ; Next digit
    LOOP CONVERSION_LOOP  
    
    MOV AX, BX            ; Result in AX
    
    POP SI
    POP BX
    POP CX
    RET
ASCII_TO_BIN ENDP

END MAIN