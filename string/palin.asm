.model small
.stack 100h

.data
msg1 db 'Enter a string (max 20 chars): $'
msg_pal db 0Ah,0Dh,'The string is a palindrome.$'
msg_not db 0Ah,0Dh,'The string is NOT a palindrome.$'
buffer db 20,0,20 dup(?)   ; 0 = maxlen, 1 = length, 2.. = chars

.code
main:
    mov ax,@data
    mov ds,ax

    ;--- Prompt ---
    lea dx,msg1
    mov ah,09h
    int 21h

    ;--- Read string ---
    lea dx,buffer
    mov ah,0Ah
    int 21h

    ;--- Get actual length ---
    mov al,buffer+1       ; number of chars typed
    mov cl,al
    cmp cl,0
    je done               ; nothing entered

    ;--- Set pointers ---
    mov si,2              ; start of string
    mov ax,0
    mov al,cl
    add si,0              ; SI already start, keep for clarity
    mov di,2
    add di,ax
    dec di                ; DI points to last character

check_loop:
    mov al,buffer[si]
    mov bl,buffer[di]
    cmp al,bl
    jne not_palindrome    ; mismatch → not palindrome

    inc si
    dec di
    cmp si,di
    jl check_loop         ; continue until SI >= DI

    ;--- If loop finished, it's palindrome ---
    lea dx,msg_pal
    mov ah,09h
    int 21h
    jmp done

not_palindrome:
    lea dx,msg_not
    mov ah,09h
    int 21h

done:
    mov ah,4Ch
    int 21h

end main
