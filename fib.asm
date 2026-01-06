.MODEL SMALL
.STACK 100H 

.DATA
MSG1 DB 0AH,0DH,'FIBONACCI SERIES: $'
MSG2 DB 0AH,0DH,'Enter count: $'
NEWLINE DB 0AH,0DH,'$'

COUNT DW ?
TEMP  DW 0
FIB1  DW 0
FIB2  DW 1

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; Ask for count
    LEA DX,MSG2
    MOV AH,09H
    INT 21H

    ; Input single digit
    MOV AH,01H
    INT 21H
    SUB AL,30H
    CBW
    MOV COUNT,AX

    ; Print heading
    LEA DX,MSG1
    MOV AH,09H
    INT 21H

    ; Handle special cases
    MOV AX,COUNT
    CMP AX,0
    JE EXIT_PROGRAM          ; If count = 0, exit
    CMP AX,1
    JE ONLY_FIRST            ; If count = 1, print only first
    CMP AX,2
    JE ONLY_TWO              ; If count = 2, print only first two

    ; Otherwise (count >= 3)
    MOV CX,COUNT
    MOV AX,FIB1
    CALL PRINT_NO
    MOV AX,FIB2
    CALL PRINT_NO
    SUB CX,2                 ; 2 terms already printed

FIB_LOOP:
    MOV AX,FIB1
    ADD AX,FIB2
    MOV TEMP,AX
    CALL PRINT_NO

    MOV AX,FIB2
    MOV FIB1,AX
    MOV AX,TEMP
    MOV FIB2,AX

    LOOP FIB_LOOP
    JMP EXIT_PROGRAM

; ===== Handle Count = 1 =====
ONLY_FIRST:
    MOV AX,FIB1
    CALL PRINT_NO
    JMP EXIT_PROGRAM

; ===== Handle Count = 2 =====
ONLY_TWO:
    MOV AX,FIB1
    CALL PRINT_NO
    MOV AX,FIB2
    CALL PRINT_NO
    JMP EXIT_PROGRAM

; ===== Exit =====
EXIT_PROGRAM:
    LEA DX,NEWLINE
    MOV AH,09H
    INT 21H

    MOV AH,4CH
    INT 21H
MAIN ENDP

;-----------------------------------------
; PRINT_NO: Display number in AX (decimal)
;-----------------------------------------
PRINT_NO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX,10
    XOR CX,CX

CONVERT_LOOP:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE CONVERT_LOOP

PRINT_LOOP:
    POP DX
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    LOOP PRINT_LOOP

    ; Print space between numbers
    MOV DL,' '
    MOV AH,02H
    INT 21H

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NO ENDP

END MAIN
