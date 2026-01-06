.MODEL SMALL
.STACK 100H
.DATA
    msgReady DB 'Disk Ready$'
    msgError DB 'Disk Error$'
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    MOV AH,00H
    MOV DL,00H
    INT 13H
    JC DiskFail
    lea DX,msgReady
    JMP Display
DiskFail:
    lea DX,msgError
Display:
    MOV AH,09H
    INT 21H
    MOV AH,4CH
    INT 21H
MAIN ENDP
END MAIN

