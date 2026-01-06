.model small
.stack 100h

.data
arr db 20 dup(?)              ; Reserve space for up to 20 elements
arrSize db ?                  ; Actual number of elements (user input)

msg1 db 'Enter number of elements (1-9):', 13, 10, '$'
msg2 db 'Enter number:', 13, 10, '$'
msg3 db 'You entered:', 13, 10, '$'
newline db 13, 10, '$'

.code
main:
    mov ax, @data
    mov ds, ax

    ; Ask for number of elements
    mov ah, 09h
    lea dx, msg1
    int 21h

    mov ah, 01h               ; Read single digit
    int 21h
    sub al, 30h               ; Convert ASCII to number
    mov arrSize, al

    ; Newline after input
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Input elements
    mov cx, 0
    mov cl, arrSize
    mov si, 0

input_loop:
    mov ah, 09h
    lea dx, msg2
    int 21h

    mov ah, 01h
    int 21h
    sub al, 30h
    mov arr[si], al

    ; Newline after each input
    mov ah, 09h
    lea dx, newline
    int 21h

    inc si
    loop input_loop

    ; Print all elements
    mov ah, 09h
    lea dx, msg3
    int 21h

    mov cx, 0
    mov cl, arrSize
    mov si, 0

print_loop:
    mov dl, arr[si]
    add dl, 30h               ; Convert to ASCII
    mov ah, 02h
    int 21h

    ; Newline after each number
    mov ah, 09h
    lea dx, newline
    int 21h

    inc si
    loop print_loop

    ; Exit
    mov ah, 4Ch
    int 21h

end main
