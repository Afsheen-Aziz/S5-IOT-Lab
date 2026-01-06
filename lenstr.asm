; simple_length.asm
.model small
.stack 100h

.data
    prompt db 'Enter a string: $'
    buffer db 10      ; max 9 chars + CR
           db 0       ; DOS will store length here
           db 10 dup(?) ; space for input

    msg db 0Ah,0Dh,'Length of string is: $'

.code
main:
    mov ax,@data
    mov ds,ax

    ; print prompt
    mov ah,09h
    lea dx,prompt
    int 21h

    ; read string
    lea dx,buffer
    mov ah,0Ah
    int 21h

    ; print message
    mov ah,09h
    lea dx,msg
    int 21h

    ; print length (single digit)
    mov al,[buffer+1]  ; AL = number of chars typed
    add al,'0'         ; convert to ASCII
    mov dl,al
    mov ah,02h
    int 21h

    ; exit
    mov ah,4Ch
    int 21h
end main
