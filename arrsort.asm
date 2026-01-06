.MODEL SMALL
.STACK 100H

.DATA
    msg1 DB "Enter number of elements (1-9): $"
    msg2 DB 0DH,0AH, "Enter the numbers (0-9): $"
    msg3 DB 0DH,0AH, "Sorted array elements: $"
    arr  DB 10 DUP(?)     ; array for 10 numbers
    n    DB ?             ; number of elements

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- Prompt user for number of elements ---
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    ; --- Read number of elements ---
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV n, AL

    ; --- Prompt for array elements ---
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    ; --- Read array elements ---
    MOV CL, n
    MOV SI, 0
READ_LOOP:
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV arr[SI], AL
    INC SI
    ;DEC CL
    loop READ_LOOP

    ; --- Sort array using Bubble Sort ---
    MOV CL, n          ; Outer loop counter (n)
    DEC CL             ; n-1 passes needed
OUTER_LOOP:
    MOV SI, 0
    MOV CH, CL         ; Inner loop counter
INNER_LOOP:
    MOV AL, arr[SI]
    MOV BL, arr[SI+1]
    CMP AL, BL
    JLE SKIP_SWAP      ; If in order, skip
    MOV arr[SI], BL
    MOV arr[SI+1], AL
SKIP_SWAP:
    INC SI
    DEC CH
    JNZ INNER_LOOP
    DEC CL
    JNZ OUTER_LOOP

    ; --- Display sorted array ---
    LEA DX, msg3
    MOV AH, 09H
    INT 21H

    MOV CL, n
    MOV SI, 0
DISPLAY_LOOP:
   mov dl,arr[si]
   add dl,30h
   mov ah,02h
   int 21h
   inc si
   loop display_loop

    ; --- Exit program ---
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN