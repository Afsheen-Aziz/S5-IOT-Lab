.model small
.stack 100h
.data
msg1 db 'Enter n: $'
msg2 db 0Ah,0Ch,'Enter array element: $'
msg3 db 0Ah,0Ch,'Enter element too be found: $'
msg4 db 0Ah,0Ch,'Not found$'
msg5 db 0Ah,0Ch,'Found at:$'
arr db 20 dup(?)
n db ?
ele db ?

.code
main:
mov ax,@data
mov ds,ax

lea dx,msg1
mov ah,09h
int 21h

mov ah,01h
int 21h
sub al,30h
mov n,al

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
mov ele,al

mov cx,0
mov cl,n
mov si,0
find_loop:
mov al,arr[si]
cmp ele,al
je found
inc si
loop find_loop
jmp not_found

found:
lea dx,msg5
mov ah,09h
int 21h
inc si
mov ax,si
call print_word
jmp end_pgm

not_found:
lea dx,msg4
mov ah,09h
int 21h

end_pgm:
mov ah,4Ch
int 21h

print_word proc
push ax
push bx
push cx
push dx

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

pop dx
pop cx
pop bx
pop ax
ret
print_word endp
end main