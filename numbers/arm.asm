.MODEL SMALL
.STACK 100H

.DATA
    MSG_PROMPT      DB 0Ah,0Dh,'Enter a 3-digit number (100-999):$'
    MSG_ARMSTRONG   DB 0Ah,0Dh,'Result: Is an Armstrong Number.$'
    MSG_NOT_ARM     DB 0Ah,0Dh,'Result: Is NOT an Armstrong Number.$'
    
    ; Variables for calculation
    INPUT_NUM_BIN   DW ?           ; Stores the original input number (16-bit)
    SUM_OF_CUBES    DW 0           ; Stores the calculated sum (16-bit)
    
    ; Input buffer to hold the 3 ASCII digits
    DIGITS_BUF      DB 3 DUP(?)    ; Stores the three input digits
    
    ; Cube lookup table for digits 0-9 (0^3 to 9^3)
    ; 0, 1, 8, 27, 64, 125, 216, 343, 512, 729
    CUBE_TABLE      DW 0, 1, 8, 27, 64, 125, 216, 343, 512, 729
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

; -----------------------------------------------------------------
; 1. INPUT NUMBER (Read 3 Digits and Store them)
; -----------------------------------------------------------------
    LEA DX, MSG_PROMPT
    MOV AH, 09H
    INT 21H
    
    LEA SI, DIGITS_BUF ; Point SI to the start of the buffer
    MOV CX, 3                 ; We need to read exactly 3 digits

READ_3_DIGITS_LOOP:
    MOV AH, 01H     ; DOS input char (reads to AL)
    INT 21H
    
    MOV [SI], AL    ; Store the ASCII digit in the buffer
    INC SI          
    LOOP READ_3_DIGITS_LOOP

; -----------------------------------------------------------------
; 2. ASCII to BINARY CONVERSION
; -----------------------------------------------------------------
    MOV AX, 0       ; AX will be the final binary number
    LEA SI, DIGITS_BUF ; Reset SI to the start of the buffer
    
    ; Digit 1 (Hundreds)
    MOV AL, [SI]    ; Get the hundreds digit (ASCII)
    SUB AL, '0'     ; Convert to binary
    MOV AH, 0       ; AX = Hundreds digit
    MOV BL, 100     ; Multiplier
    MUL BL          ; AX = Digit * 100
    PUSH AX         ; Save 100s value
    
    ; Digit 2 (Tens)
    INC SI
    MOV AL, [SI]    ; Get the tens digit
    SUB AL, '0'     
    MOV AH, 0       
    MOV BL, 10      ; Multiplier
    MUL BL          ; AX = Digit * 10
    POP BX          ; BX = 100s value
    ADD AX, BX      ; AX = 100s + 10s
    PUSH AX         ; Save 100s + 10s value
    
    ; Digit 3 (Units)
    INC SI
    MOV AL, [SI]    ; Get the units digit
    SUB AL, '0'     
    MOV AH, 0       
    POP BX          ; BX = 100s + 10s value
    ADD AX, BX      ; AX = 100s + 10s + 1s (Final Number)
    
    MOV INPUT_NUM_BIN, AX ; Save original number
    
; -----------------------------------------------------------------
; 3. ARMSTRONG CHECK LOOP
; -----------------------------------------------------------------
    ; AX already holds the number for processing
    
ARMSTRONG_LOOP:
    ; Check if AX is zero (all digits processed)
    CMP AX, 0
    JE DISPLAY_RESULT

    ; Get Remainder (Digit)
    MOV DX, 0           ; Clear DX for division
    MOV BX, 10          ; Divisor is 10
    DIV BX              ; AX = AX / 10 (New number), DX = AX % 10 (Digit)
    
    PUSH AX             ; Save the quotient (new number)
    
    ; Calculate Cube: Look up Cube_TABLE[Digit * 2]
    MOV BL, DL          ; BL = Digit (0-9)
    MOV BH, 0           ; BX = Digit (0-9)
    SHL BX, 1           ; BX = Digit * 2 (Word index)
    
    MOV SI, BX          ; SI = index into CUBE_TABLE
    MOV AX, CUBE_TABLE[SI] ; AX = Cube of the digit
    
    ADD SUM_OF_CUBES, AX ; Add the cube to the running total
    
    POP AX              ; Restore the quotient (new number)
    JMP ARMSTRONG_LOOP

; -----------------------------------------------------------------
; 4. DISPLAY RESULT
; -----------------------------------------------------------------
DISPLAY_RESULT:
    
    MOV AX, SUM_OF_CUBES
    CMP AX, INPUT_NUM_BIN ; Compare Sum of Cubes with Original Number
    
    JNE NOT_ARMSTRONG
    
    ; Display Armstrong Message
    LEA DX, MSG_ARMSTRONG
    JMP EXIT_PROGRAM

NOT_ARMSTRONG:
    ; Display Not Armstrong Message
    LEA DX, MSG_NOT_ARM

EXIT_PROGRAM:
    MOV AH, 09H
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN