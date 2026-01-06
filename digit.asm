.MODEL SMALL
.STACK 100H
.DATA
    msgDigit DB 'Digit$'
    msgNot DB 'Not a digit$'
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    MOV AH,0
    INT 16H
    CMP AL,'0'
    JL NotDigit
    CMP AL,'9'
    JG NotDigit
    lea DX,msgDigit
    JMP Display
NotDigit:
    lea DX,msgNot
Display:
    MOV AH,09H
    INT 21H
    MOV AH,4CH
    INT 21H
MAIN ENDP
END MAIN

