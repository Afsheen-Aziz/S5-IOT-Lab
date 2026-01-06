.MODEL SMALL
.STACK 100h
.DATA
    prompt  db "Enter a number: $"
    evenMsg db 13,10, "Number is even.$"
    oddMsg  db 13,10, "Number is odd.$"
    buffer  db 5,0,5 dup(?)   ; buffered input (max 5 digits)

.CODE
main PROC
    mov ax, @data
    mov ds, ax

    ; print prompt
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; take buffered input
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; convert ASCII → number
    mov cl, [buffer+1]      ; number of digits entered
    mov si, offset buffer+2 ; pointer to first character
    xor ax, ax              ; AX = result = 0

next_digit:
    cmp cl, 0
    je done_input

    mov bl, [si]
    sub bl, '0'             ; convert to number

    mov dx, ax              ; save current result
    mov ax, 10
    mul dx                  ; AX = old_result * 10
    add ax, bx              ; AX = AX + current_digit

    inc si
    dec cl
    jmp next_digit

done_input:
    ; check even or odd
    test ax, 1
    jz print_even

print_odd:
    mov ah, 09h
    lea dx, oddMsg
    int 21h
    jmp exit

print_even:
    mov ah, 09h
    lea dx, evenMsg
    int 21h

exit:
    mov ah, 4Ch
    int 21h
main ENDP
END main
