.model small
.stack 100h

.data
msg1 db 'Enter a string (max 20 chars): $'
msg2 db 0Ah,0Dh,'Number of digits: $'
buffer db 20,0,20 dup(?)   ; 0 = maxlen, 1 = length, 2.. = chars
digitCount db 0

.code
main:
    mov ax,@data
    mov ds,ax


    ;--- Prompt user ---
    lea dx,msg1
    mov ah,09h
    int 21h

    ;--- Read string ---
    lea dx,buffer
    mov ah,0Ah
    int 21h

mov cl,[buffer+1]
lea si,buffer+2
digit_loop:
    mov al,[si]
    cmp al,'0'
    jb next_char
    cmp al,'9'
    ja next_char
    inc digitCount

next_char:
    inc si
    dec cl
    jnz digit_loop

print_result:
    lea dx,msg2
    mov ah,09h
    int 21h

    mov al,digitCount
    mov ah,0
    call print_word     ; using your procedure

done:
    mov ah,4Ch
    int 21h

;--- Your print_word procedure ---
print_word proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx,10
    mov cx,0

convert_loop:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne convert_loop

display_loop:
    pop dx
    add dl,30h
    mov ah,02h
    int 21h
    loop display_loop

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_word endp

end main
