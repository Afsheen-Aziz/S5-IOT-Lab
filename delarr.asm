.model small
.stack 100h
.data
msg1 db 'Enter string: $'
msg2 0Ah,0Ch,'length of string: $'
str1 20,0,20 dup(?)

.code
main:
mov ax,@data
mov ds,ax

lea dx,msg1
mov ah,09h
int 21h


lea dx,str1
mov ah,0Ah
int 21h

lea dx,msg2
mov ah,09h
int 21h

mov al,str1+1
mov ah,0
call print_num

mov ah,4Ch
int 21h

print_num proc
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
print_num endp
end main