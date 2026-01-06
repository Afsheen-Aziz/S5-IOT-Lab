.model small
.stack 100h
.data
    msg db 'Hello World$'     ; '$' terminator required for DOS function 09h

.code
main proc
    mov ax, @data             ; initialize data segment
    mov ds, ax

    mov ah, 09h               ; DOS interrupt: display string
    lea dx, msg               ; load address of message into dx
    int 21h                   ; call DOS interrupt

    mov ah, 4Ch               ; DOS interrupt: exit program
    int 21h

main endp
end main
