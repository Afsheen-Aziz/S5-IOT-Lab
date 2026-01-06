.MODEL SMALL
.STACK 100h
.DATA
MSG1   DB 'ENTER A NUMBER: $'
MSG2   DB 0DH,0AH,'FACTORIAL = $'
NUM    DB ?
RESULT DW ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Prompt user
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; Read single digit
    MOV AH, 01H
    INT 21H
    SUB AL, 30h       ; ASCII -> number
    MOV NUM, AL

    ; Initialize result = 1
    MOV AX, 1
    MOV RESULT, AX

    MOV CL, NUM
    CMP CL, 0
    JE PRINT_RESULT   ; 0! = 1

FACT_LOOP:
    MOV AX, RESULT
    MOV CH, 0
    MOV BX, CX         ; move counter to BX
    MUL BX             ; 16-bit multiply: DX:AX = AX * BX
    MOV RESULT, AX
    DEC CL
    CMP CL, 0
    JNE FACT_LOOP

PRINT_RESULT:
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

    MOV AX, RESULT
    CALL PRINT_NUMBER

    MOV AH, 4CH
    INT 21H
MAIN ENDP


;----------------------------------------
; Print 16-bit number in AX as decimal
;----------------------------------------
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX
    MOV BX, 10

CONVERT_LOOP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE CONVERT_LOOP

PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END MAIN
