.MODEL SMALL
.STACK 100h
.DATA
    msg1 db "Enter number of elements (1-9): $"
    msg2 db 0Dh,0Ah, "Enter elements (0-9): $"
    msg3 db 0Dh,0Ah, "Count of EVEN numbers: $"
    msg4 db 0Dh,0Ah, "Count of ODD numbers: $"
    arr  db 10 dup(?)
    n    db ?
    even_count db 0
    odd_count  db 0

.CODE
MAIN PROC
    mov ax, @data
    mov ds, ax

    ; Ask for count
    lea dx, msg1
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov n, al

    ; Ask for elements
    lea dx, msg2
    mov ah, 09h
    int 21h

    mov cl, n
    lea si, arr

read_loop:
    mov ah, 01h
    int 21h
    sub al, '0'
    mov [si], al
    inc si
    loop read_loop

    ; Initialize counters
    mov even_count, 0
    mov odd_count, 0

    ; Check odd/even
    mov cl, n
    lea si, arr

check_loop:
    mov al, [si]
    test al, 1
    jz is_even

is_odd:
    inc odd_count
    jmp next_num

is_even:
    inc even_count

next_num:
    inc si
    loop check_loop

    ; Display even count
    lea dx, msg3
    mov ah, 09h
    int 21h

    mov al, even_count
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    ; Display odd count
    lea dx, msg4
    mov ah, 09h
    int 21h

    mov al, odd_count
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    ; Exit
    mov ah, 4Ch
    int 21h
MAIN ENDP
END MAIN
