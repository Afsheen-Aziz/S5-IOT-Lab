.model small
.stack 100h
.data
msg db "Day: $"
days db "Monday   $"
     db "Tuesday  $"
     db "Wednesday$"
     db "Thursday $"
     db "Friday   $"
     db "Saturday $"
     db "Sunday   $"
.code
main:
    mov ax, @data
    mov ds, ax

    mov ah, 2Ah         ; Get system date
    int 21h
    mov bl, al          ; AL = day of week (1=Sunday, ..., 7=Saturday)
    dec bl              ; Convert to 0-based: 0 = Sunday

    mov ah, 09h
    lea dx, msg
    int 21h

    mov al, bl
    mov ah, 0
    mov cl, 10          ; Each entry is 10 bytes (including $ and spaces)
    mul cl
    lea dx, days
    add dx, ax

    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h
end main