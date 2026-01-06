.model small
.stack 100h
.data
msg1 db 'system memory:$'
.code
main:
mov ax,@data
mov ds,ax

int 12h

call printnum

mov ah,4Ch
int 21h

printnum proc
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
printnum endp
end main