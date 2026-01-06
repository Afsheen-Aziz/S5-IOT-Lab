.model small
.stack 100h
.data
msg1 db 'Enter name: $'
msg2 db 0Ah,0Dh,'Hi there $'

buffer db 20
db ?
input db 20 dup('$')

.code
main:
mov ax,@data
mov ds,ax

mov ah,09h
lea dx,msg1
int 21h

lea dx,buffer
mov ah,0Ah
int 21h

mov ah,09h
lea dx,msg2
int 21h

lea dx,input
mov ah,09h
int 21h

mov ah,4Ch
int 21h

end main