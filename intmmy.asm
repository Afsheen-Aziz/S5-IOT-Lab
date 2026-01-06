.MODEL SMALL
.STACK 100h

.DATA
    msg1 DB "System memory size: $"
    msg2 DB " KB$"
    newline DB 0Dh,0Ah,'$'

.CODE
MAIN PROC
    mov ax, @data
    mov ds, ax

    ; Get memory size using BIOS interrupt
    int 12h          ; Returns memory size (in KB) in AX
    mov bx, ax       ; Save AX -> BX for later

    ; Display message
    mov dx, offset msg1
    mov ah, 09h
    int 21h

    ; Convert BX (memory size) to decimal ASCII
    call print_number

    ; Display " KB"
    mov dx, offset msg2
    mov ah, 09h
    int 21h

    ; New line
    mov dx, offset newline
    mov ah, 09h
    int 21h

    ; Exit to DOS
    mov ah, 4Ch
    int 21h
MAIN ENDP

;--------------------------------------------
; Procedure: print_number
; Converts BX to ASCII and prints via INT 21h
;--------------------------------------------
print_number PROC
    push ax
    push bx
    push cx
    push dx

    mov ax, bx
    mov cx, 0

next_digit:
    mov dx, 0
    mov bx, 10
    div bx          ; AX ÷ 10 → quotient in AX, remainder in DX
    push dx         ; Save remainder (digit)
    inc cx
    cmp ax, 0
    jne next_digit

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number ENDP

END MAIN
