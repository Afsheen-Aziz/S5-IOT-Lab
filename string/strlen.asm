.MODEL SMALL
.STACK 100h
.DATA
msg1 db 'Enter string: $'
msg2 db 0Dh,0Ah,'Length is: $'
str1 db 20,0,20 dup(?)
.CODE
main:
    mov ax,@data
    mov ds,ax

    lea dx,msg1
    mov ah,09h
    int 21h

    lea dx,str1
    mov ah,0Ah
    int 21h

    lea dx,msg2
    mov ah,09h
    int 21h

    ; Get length from buffer
    mov al, str1+1     ; AL = length
    mov ah, 0
    call print_number   ; print decimal value

    mov ah,4Ch
    int 21h

;---------------------------
; print_number: print AX in decimal
;---------------------------
print_number proc
    push ax
    push bx
    push cx
    push dx

    mov bx,10
    xor cx,cx

next_digit:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne next_digit

print_loop:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

end main