.model small
.stack 100h

.data
msg1 db 'Enter a string (max 20 chars): $'
msg2 db 0Ah,0Dh,'Number of consonants: $'
buffer db 22 dup(?)   ; 0 = maxlen, 1 = length, 2.. = chars
consCount db 0

.code
main:
    mov ax,@data
    mov ds,ax

    ;--- Set maximum length ---
    mov byte ptr buffer,20

    ;--- Prompt user ---
    lea dx,msg1
    mov ah,09h
    int 21h

    ;--- Read string ---
    lea dx,buffer
    mov ah,0Ah
    int 21h

    ;--- Get length ---
    mov cl,buffer+1
    cmp cl,0
    je done          ; no input

    ;--- Initialize consonant count ---
    mov consCount,0
    mov si,2         ; first character at buffer+2

cons_loop:
    mov al,buffer[si]

    ; convert uppercase to lowercase if needed
    cmp al,'A'
    jb skip_char
    cmp al,'Z'
    ja check_lower
    add al,20h
    jmp check_letter

check_lower:
    cmp al,'a'
    jb skip_char
    cmp al,'z'
    ja skip_char

check_letter:
    ; now AL is lowercase a-z
    ; check if it is NOT a vowel
    cmp al,'a'
    je next_char
    cmp al,'e'
    je next_char
    cmp al,'i'
    je next_char
    cmp al,'o'
    je next_char
    cmp al,'u'
    je next_char

    ; it is a consonant
    inc consCount

next_char:
    inc si
    dec cl
    jnz cons_loop
    jmp print_result

skip_char:
    inc si
    dec cl
    jnz cons_loop

print_result:
    lea dx,msg2
    mov ah,09h
    int 21h

    mov al,consCount
    mov ah,0
    call print_word     ; <-- using your procedure

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
