.model small
.stack 100h

.data
msg1 db 'Enter n:$'
msg2 db 0Ah,0Ch,'Enter element:$'
msg3 db 0Ah,0Ch,'Reveresed Array:$'
n db ?
arr db 20 dup(?)

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


mov al,n
mov ah,0
mov cx,ax       ; CX = N (total count)
shr cx,1        ; CX = N / 2 (number of swaps needed)

mov si,0        ; SI = Start index (i=0)
mov di,0
mov dl,n        ; DL = N
dec dl          ; DL = End index (j=N-1)
mov dh,0
mov di,dx       ; DI = End index (j=N-1)

reverse_loop:
mov al,arr[si]
mov ah,arr[di]
mov arr[si],ah
mov arr[di],al

inc si          ; Move start index forward
dec di          ; Move end index backward
loop reverse_loop


mov cx,0
mov cl,n
mov si,0
print_loop:
mov al,arr[si]
mov ah,0
call print_word
inc si
loop print_loop

mov ah,4Ch
int 21h

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