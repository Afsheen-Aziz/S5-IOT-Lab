.model small
.stack 100h

.data
msg1 db 'Enter a string (max 20 chars): $'
msg2 db 0Ah,0Dh,'Reversed string: $'
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

    ;--- Print reversed string ---
    lea dx,msg2
    mov ah,09h
    int 21h

    ;--- Calculate last character index ---
    mov si,2              ; string starts at buffer+2
    mov ax,0
    mov al,cl             ; length in AL
    add si,ax
    dec si                ; point to last char

rev_loop:
    mov dl,buffer[si]
    mov ah,02h
    int 21h
    dec si
    dec cl
    jnz rev_loop

done:
    mov ah,4Ch
    int 21h

end main
