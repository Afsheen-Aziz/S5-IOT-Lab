.MODEL SMALL
.STACK 100H

.DATA
MSG_N       DB 0Ah,0Dh,'Enter array size (1-9):$'
MSG_ELEM    DB 0Ah,0Dh,'Enter 2-digit element (00-99):$'
MSG_RES     DB 0Ah,0Dh,'--- Frequency Results ---   $'
MSG_SEP     DB ' : $'

N           DB ?
ARR         DB 20 DUP(?)
COUNT_TABLE DW 100 DUP(0)         ; Frequency table (0–99)

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; clear frequency table
    MOV SI, 0
INIT_FREQ_LOOP:
    MOV COUNT_TABLE[SI], 0
    ADD SI, 2
    CMP SI, 200
    JL INIT_FREQ_LOOP

    ; input array size
    LEA DX, MSG_N
    MOV AH, 09H
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30h
    MOV N, AL

MOV CL, AL
MOV CH, 0
MOV SI, 0
INPUT_LOOP:
    LEA DX, MSG_ELEM
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, 30h
    MOV BH, AL

    MOV AH, 01H
    INT 21H
    SUB AL, 30h
    MOV BL, AL

    MOV AL, BH
    MOV DL, 10
    MUL DL
    ADD AL, BL
    MOV ARR[SI], AL

    INC SI
    LOOP INPUT_LOOP

; frequency counting
MOV CL, N
MOV CH, 0
MOV SI, 0

COUNTING_LOOP:
    MOV AL, ARR[SI]
    MOV AH, 0
    MOV BX, AX
    SHL BX, 1
    INC COUNT_TABLE[BX]
    INC SI
    LOOP COUNTING_LOOP

    ; display results
    LEA DX, MSG_RES
    MOV AH, 09H
    INT 21H

    MOV CX, 100
    MOV SI, 0

MAIN_DISPLAY_LOOP:
    MOV BX, SI
    SHL BX, 1
    MOV AX, COUNT_TABLE[BX]
    CMP AX, 0
    JE NEXT_FREQ_NUMBER

    PUSH CX        ; save counter

    PUSH AX        ; save count
    MOV AX, SI
    CALL PRINT_WORD
    POP AX         ; restore count

    PUSH AX
    LEA DX, MSG_SEP
    MOV AH, 09H
    INT 21H
    POP AX

    CALL PRINT_WORD

    ; newline
    MOV DL, 0Dh
    MOV AH, 02H
    INT 21H
    MOV DL, 0Ah
    MOV AH, 02H
    INT 21H

    POP CX
NEXT_FREQ_NUMBER:
    INC SI
    LOOP MAIN_DISPLAY_LOOP

    MOV AH, 4Ch
    INT 21H

PRINT_WORD PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV BX, 10
    MOV CX, 0

CONVERT_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE CONVERT_LOOP

DISPLAY_LOOP:
    POP DX
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    LOOP DISPLAY_LOOP

    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_WORD ENDP

END MAIN
