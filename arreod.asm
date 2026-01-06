.model small
.stack 100h

.data
msg1 db 'Enter number of elements (00-20):$'
msg2 db 0Ah,0Ch,'Enter element:$'
msg3 db 0Ah,0Ch,'Number of even elements: $'
msg4 db 0Ah,0Ch,'Number of odd elements: $'
n db ?
arr db 20 dup(?)
evenCount db ?
oddCount db ?

.code
main:
    mov ax,@data
    mov ds,ax

    ;--- Input n as 2-digit number ---
    lea dx,msg1
    mov ah,09h
    int 21h

    ; tens digit
    mov ah,01h
    int 21h
    sub al,30h
    mov bh,al

    ; units digit
    mov ah,01h
    int 21h
    sub al,30h
    mov bl,al

    mov al,bh
    mov dl,10
    mul dl
    add al,bl
    mov n,al

    ;--- Input array elements ---
    mov cx,0
    mov cl,n
    mov si,0
input_loop:
    lea dx,msg2
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,30h
    mov bh,al

    mov ah,01h
    int 21h
    sub al,30h
    mov bl,al

    mov al,bh
    mov dl,10
    mul dl
    add al,bl
    mov arr[si],al

    inc si
    loop input_loop

    ;--- Count even and odd numbers ---
    mov evenCount,0
    mov oddCount,0
    mov cx,0
    mov cl,n
    mov si,0
count_loop:
    mov al,arr[si]
    and al,1          ; check LSB
    cmp al,0
    je is_even
    ; odd
    inc oddCount
    jmp next_elem
is_even:
    inc evenCount
next_elem:
    inc si
    loop count_loop

    ;--- Print results ---
    lea dx,msg3
    mov ah,09h
    int 21h
    mov al,evenCount
    call print_word

    lea dx,msg4
    mov ah,09h
    int 21h
    mov al,oddCount
    call print_word

    mov ah,4Ch
    int 21h

;--- Procedure to print numbers ---
print_word proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx,10
    mov cx,0

    ; convert to decimal digits
    mov ah,0
convert_loop:
    mov dx,0
    div bx
    push dx
    inc cx
    cmp ax,0
    jne convert_loop

display_loop:
    pop dx
    add dl,30h
    mov ah,02h
    int 21h
    loop display_loop

    mov dl,' '
    mov ah,02h
    int 21h

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_word endp

end main
