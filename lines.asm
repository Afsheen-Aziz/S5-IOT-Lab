.model small
.stack 100h

.data

msg1 db 'Hi!$'
msg2 db 0Ah,0Dh, 'My name is Afsheen$'

.code
main:
mov ax,@data
mov ds,ax

mov ah,09h
lea dx,msg1
int 21h

mov ah,09h
lea dx,msg2
int 21h

mov ah,4Ch
int 21h

end main
