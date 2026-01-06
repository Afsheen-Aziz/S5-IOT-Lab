.model small
.stack 100h

.data
m1 db 'enter string$'
m2 db 0ah,0dh,'enter old sub string$'
m3 db 0ah,0dh,'enter new sub string$'
m4 db 0ah,0dh,'new string: $'
mstr db 50
        db ?
        db 50 dup('$')
oldsub db 50
        db ?
        db 50 dup('$')
newsub db 50
        db ?
        db 50 dup('$')
temp db 50
        db ?
        db 50 dup('$')
.code 
main PROC
    mov ax, @data
    mov ds, ax

    ;print m1
    lea dx, m1
    mov ah, 09h
    int 21h

    lea dx, mstr
    mov ah, 0ah
    int 21h 

    ;print m2
    lea dx, m2
    mov ah, 09h
    int 21h

    lea dx, oldsub
    mov ah, 0ah
    int 21h 

    lea dx, m3
    mov ah, 09h
    int 21h

    lea dx, newsub
    mov ah, 0ah
    int 21h 

    lea si, mstr+2
reinit:
    inc si
    mov bx, si
    lea di, oldsub+2
    mov cl, [oldsub+1]

compare:
    mov al, [si]
    cmp al, [di]
    jne reinit
    inc si
    inc di
    dec cl
    jnz compare
    lea di, temp+2
copy_rest:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    mov al, [si]
    cmp al, '$'
    jne copy_rest
    
    mov ch, [oldsub+1]
    mov si, bx

    mov cl, [newsub+1]
    
    lea di, [newsub+2]
combine:
    mov al, [di]
    mov [si], al
    inc si
    inc di
    dec cl
    jnz combine

    mov cl, [temp+1]
    lea di, [temp+2]
rest:
    mov al, [di]
    mov [si], al
    inc si
    inc di
    dec cl
    jnz rest


    lea dx, m4
    mov ah, 09h
    int 21h

    lea dx, mstr+2
    mov ah, 09h
    int 21h

done:
    mov ah, 4ch
    int 21h

main ENDP
END main



