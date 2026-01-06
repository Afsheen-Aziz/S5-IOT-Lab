.MODEL SMALL
.STACK 100H

.DATA
    msg1 DB "Enter number of elements (1-9): $"
    msg2 DB 0DH,0AH, "Enter the numbers (0-9): $"
    msg3 DB 0DH,0AH, "Enter element to search: $"
    msg4 DB 0DH,0AH, "Element found at position: $"
    msg5 DB 0DH,0AH, "Element not found!$"

    arr  DB 10 DUP(?)   ; Array for up to 10 numbers
    n    DB ?           ; Number of elements
    key  DB ?           ; Search element
    pos  DB 0           ; Found position (1-based)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- Prompt for number of elements ---
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV n, AL

    ; --- Prompt for array elements ---
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    MOV CL, n
    MOV SI, 0
READ_LOOP:
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV arr[SI], AL
    INC SI
    DEC CL
    JNZ READ_LOOP

    ; --- Ask for element to search ---
    LEA DX, msg3
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV key, AL

    ; --- Search the array ---
    MOV CL, n       ; Counter
    MOV SI, 0       ; Array index
    MOV BL, 1       ; Position counter (1-based)
    MOV pos, 0      ; Initially 0 (not found)

SEARCH_LOOP:
    MOV AL, arr[SI]
    CMP AL, key
    JE FOUND        ; Jump if equal
    INC SI
    INC BL
    DEC CL
    JNZ SEARCH_LOOP
    JMP NOT_FOUND

FOUND:
    MOV pos, BL

    ; --- Display found message ---
    LEA DX, msg4
    MOV AH, 09H
    INT 21H

    MOV AL, pos
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    JMP EXIT

NOT_FOUND:
    LEA DX, msg5
    MOV AH, 09H
    INT 21H

EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN