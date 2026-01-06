; Program: Display Current Date (DD-MM-YYYY)
; Environment: 8086 MASM / DOSBox
; Uses PRINT_NUMBER procedure

.MODEL SMALL
.STACK 100h
.DATA
    msg1 db 'Current Date: $'
    newline db 0Ah, 0Dh, '$'     ; new line
.CODE
MAIN PROC
    mov ax, @data
    mov ds, ax

    ; Print "Current Date: "
    mov ah, 09h
    lea dx, msg1
    int 21h

    ; Get system date
    mov ah, 2Ah
    int 21h
    ; Returns:
    ; AL = day of week (1=Sunday..7=Saturday)
    ; CX = year
    ; DH = month (1-12)
    ; DL = day (1-31)

    ; Print Day (DL)
    mov al, dl
    mov ah, 0
    call PRINT_NUMBER

    ; Print '-'
    mov dl, '-'
    mov ah, 02h
    int 21h

    ; Print Month (DH)
    mov al, dh
    mov ah, 0
    call PRINT_NUMBER

    ; Print '-'
    mov dl, '-'
    mov ah, 02h
    int 21h

    ; Print Year (CX)
    mov ax, cx
    call PRINT_NUMBER

    ; New line
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h
MAIN ENDP

;-------------------------------------------
; Procedure: PRINT_NUMBER
; Prints unsigned number in AX
;-------------------------------------------
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX        ; digit counter
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
    MOV AH, 02h
    INT 21h
    LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END MAIN
