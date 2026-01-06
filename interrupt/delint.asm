.model small
.stack 100h
.data
msg1 db 'Date:$'
msg2 db 0AH,0Dh,'Time:$'
.code
main:
mov ax,@data
mov ds,ax

lea dx,msg1
mov ah,09h
int 21h

mov ah,2Ah
int 21h

mov al,dl
mov ah,0
call printnum

mov dl,'-'
mov ah,02h
int 21h

mov al,dh
mov ah,0
call printnum

mov dl,'-'
mov ah,02h
int 21h

mov ax,cx
call printnum


lea dx,msg2
mov ah,09h
int 21h

mov ah,2Ch
int 21h

mov al,ch
call num

mov al,cl
call num

mov al,dl
call num

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

num proc
mov ah,0
mov bl,10
div bl
mov bh,ah

add al,30h
mov dl,al
mov ah,02h
int 21h

mov al,bh
add al,30h
mov dl,al
mov ah,02h
int 21h

mov dl,':'
mov ah,02h
int 21h

ret
num endp

end main