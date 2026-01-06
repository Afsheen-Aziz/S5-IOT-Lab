.model small
.stack 100h

.data
msg1 db 'Enter number of elements (00-20):$'
msg2 db 0Ah,0Ch,'Enter element for first array:$'
msg3 db 0Ah,0Ch,'Enter element for second array:$'
msg4 db 0Ah,0Ch,'Sum of arrays:$'
n db ?
arr1 db 20 dup(?)
arr2 db 20 dup(?)
sum  db 20 dup(?)

.code
main:
    mov ax,@data
    mov ds,ax

    ;--- Input n as 2-digit number ---
    lea dx,msg1
    mov ah,09h
    int 21h

    ; read tens digit
    mov ah,01h
    int 21h
    sub al,30h
    mov bh,al    ; tens digit

    ; read units digit
    mov ah,01h
    int 21h
    sub al,30h
    mov bl,al    ; units digit

    mov al,bh
    mov dl,10
    mul dl
    add al,bl
    mov n,al

    ;--- Input first array ---
    mov cx,0
    mov cl,n
    mov si,0
input_arr1:
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
    mov arr1[si],al

    inc si
    loop input_arr1

    ;--- Input second array ---
    mov cx,0
    mov cl,n
    mov si,0
input_arr2:
    lea dx,msg3
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
    mov arr2[si],al

    inc si
    loop input_arr2

    ;--- Add arrays ---
    mov cx,0
    mov cl,n
    mov si,0
add_loop:
    mov al,arr1[si]
    add al,arr2[si]
    mov sum[si],al
    inc si
    loop add_loop

    ;--- Print result ---
    lea dx,msg4
    mov ah,09h
    int 21h

    mov cx,0
    mov cl,n
    mov si,0
print_loop:
    mov al,sum[si]
    mov ah,0
    call print_word
    inc si
    loop print_loop

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
