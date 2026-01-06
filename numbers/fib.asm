.model small
.stack 100h
.data
msg1 db 'Enter count: $'
msg2 db 0Ah,0Dh,'Fibonacci series: $'
count dw ?
temp dw 0
fib1 dw 0
fib2 dw 1

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
cbw
mov count,ax

mov ax,count
cmp ax,0
je exit
cmp ax,1
je one
cmp ax,2
je two

mov cx,count
mov ax,fib1
call printnum
mov ax,fib2
call printnum
sub cx,2

fibloop:
mov ax,fib1
add ax,fib2
mov temp,ax
call printnum

mov ax,fib2
mov fib1,ax
mov ax,temp
mov fib2,ax
loop fibloop
jmp exit

one:
mov ax,fib1
call printnum
jmp exit

two:
mov ax,fib1
call printnum
mov ax,fib2
call printnum
jmp exit

exit:
mov ah,4Ch
int 21h

printnum proc
push ax
push bx
push cx
push dx

mov cx,0
mov bx,10

convertloop:
mov dx,0
div bx
push dx
inc cx
cmp ax,0
jne convertloop

displayloop:
pop dx
add dl,30h
mov ah,02h
int 21h
loop displayloop

pop dx
pop cx
pop bx
pop ax
ret
printnum endp
end main
