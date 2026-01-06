.model small
.stack 100h

.data
arr db 20 dup(?)              ; Reserve space for up to 20 elements
arrSize db ?                  ; Actual number of elements (user input)
maxVal db ?                   ; To store max value

msg1 db 'Enter number of elements (1-9):', 13, 10, '$'
msg2 db 'Enter number:', 13, 10, '$'
msg3 db 'Largest number is: ', '$'
newline db 13, 10, '$'        ; Carriage return + line feed

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
    mov cl, arrSize           ; Set loop counter
    mov si, 0                 ; Array index

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

    ; Find max
    mov si, 0
    mov al, arr[si]
    mov maxVal, al
    inc si
    mov cl, arrSize
    dec cl                    ; Already checked first

find_max:
    mov al, arr[si]
    cmp al, maxVal
    jbe skip
    mov maxVal, al

skip:
    inc si
    loop find_max

    ; New line before result
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display result message
    mov ah, 09h
    lea dx, msg3
    int 21h

    ; Show max value
    mov ah, 02h
    mov dl, maxVal
    add dl, 30h
    int 21h

    ; Final newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Exit
    mov ah, 4Ch
    int 21h

end main
