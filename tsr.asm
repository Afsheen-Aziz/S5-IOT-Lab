.model small
.stack 100h
.data
oldtsr dd ?
msg db "TSR Program working$"
.code
main proc far
mov ax,@data
mov ds,ax

mov ah,35h
mov al,09h
int 21h
mov word ptr oldtsr,bx
mov word ptr oldtsr+2,es

lea dx,newisr
mov ax,seg newisr
mov ds,ax
mov ah,25h
mov al,09h
int 21h

mov dx,(endprog-main+0Fh)/16
mov ah,31h
int 21h

main endp

newisr proc far
push ax
push dx
push ds
push es

mov ax,seg msg
mov ds,ax
mov dx,offset msg
mov ah,09h
int 21h

pushf
call dword ptr cs:oldtsr

pop es
pop ds
pop dx
pop ax
iret
newisr endp
endprog label byte
end main