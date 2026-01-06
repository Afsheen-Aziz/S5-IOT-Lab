.model small
.stack 100h
.data
msg1 db 'Enter character: $'
msg2 db 0Ah,0Dh,'Character is: $'
.code
main:
mov ax,@data
mov ds,ax

mov ah,09h
lea dx,msg1
int 21h

mov ah,01h
int 21h
mov bl,al

mov ah,09h
lea dx,msg2
int 21h

mov ah,02h
mov dl,bl
int 21h

mov ah,4Ch
int 21h

end main