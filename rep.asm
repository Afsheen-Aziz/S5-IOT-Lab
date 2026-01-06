.MODEL SMALL
.STACK 100H
.DATA
	msg1    DB 'Enter main string: $'
	msg2    DB 0DH,0AH,'Enter substring to replace: $'
	msg3    DB 0DH,0AH,'Enter new substring: $'
	result  DB 0DH,0AH,'Modified string: $'

	mainStr DB 100 DUP('$')   
	oldStr  DB 20 DUP('$')     
	newStr  DB 20 DUP('$')     
	outStr  DB 200 DUP('$')    

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

   
    MOV DX, OFFSET msg1
    MOV AH, 9
    INT 21H
    MOV DX, OFFSET mainStr
    CALL ReadString

   
    MOV DX, OFFSET msg2
    MOV AH, 9
    INT 21H
    MOV DX, OFFSET oldStr
    CALL ReadString

  
    MOV DX, OFFSET msg3
    MOV AH, 9
    INT 21H
    MOV DX, OFFSET newStr
    CALL ReadString

    MOV SI, OFFSET mainStr   
    MOV DI, OFFSET outStr    

NEXTCHAR:
    MOV AL, BYTE PTR [SI]
    CMP AL, '$'
    JE DONE_COPY            

    
    PUSH SI
    PUSH DI
    MOV BX, OFFSET oldStr
    CALL MatchSubstring
    JC MATCHED

    
    POP DI
    POP SI
    MOV AL, BYTE PTR [SI]
    MOV BYTE PTR [DI], AL
    INC SI
    INC DI
    JMP NEXTCHAR

MATCHED:
   
    POP DI
    POP SI
    MOV BX, OFFSET newStr
COPY_NEW:
    MOV AL, BYTE PTR [BX]
    CMP AL, '$'
    JE AFTER_NEW
    MOV BYTE PTR [DI], AL
    INC BX
    INC DI
    JMP COPY_NEW
AFTER_NEW:
    
    MOV BX, OFFSET oldStr
SKIP_OLD:
    MOV AL, BYTE PTR [BX]
    CMP AL, '$'
    JE NEXTCHAR
    INC BX
    INC SI
    JMP SKIP_OLD

DONE_COPY:
    MOV BYTE PTR [DI], '$'

   
    MOV DX, OFFSET result
    MOV AH, 9
    INT 21H
    MOV DX, OFFSET outStr
    MOV AH, 9
    INT 21H

   
    MOV AH, 4CH
    INT 21H
MAIN ENDP


ReadString PROC
    MOV DI, DX  
READ_LOOP:
    MOV AH, 1
    INT 21H
    CMP AL, 0DH  
    JE END_READ
    MOV BYTE PTR [DI], AL
    INC DI
    JMP READ_LOOP
END_READ:
    MOV BYTE PTR [DI], '$'
    RET
ReadString ENDP


MatchSubstring PROC
    PUSH SI
MS_LOOP:
    MOV AL, BYTE PTR [BX]
    CMP AL, '$'
    JE FULL_MATCH
    CMP AL, BYTE PTR [SI]
    JNE NO_MATCH
    INC BX
    INC SI
    JMP MS_LOOP
FULL_MATCH:
    STC     
    POP SI
    RET
NO_MATCH:
    CLC      
    POP SI
    RET
MatchSubstring ENDP

END MAIN

