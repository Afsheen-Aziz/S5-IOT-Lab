.model small
.stack 100h
.data
yesdigit db 'Digit$'
nodigit db 0Ah,0Dh, 'Not Digit$'
.code
main:
mov ax,@data
mov ds,ax

mov ah,01h
int 21h

cmp al,'0'
jl notdigit

cmp al,'9'
jg notdigit

lea dx,yesdigit
jmp display
notdigit:
lea dx,nodigit
jmp display

display:
mov ah,09h
int 21h
mov ah,4Ch
int 21h

end main