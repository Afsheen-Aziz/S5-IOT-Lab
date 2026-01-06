.model small
.stack 100h
.data
msg1 db 'ENter first string: $'
msg2 db 0Ah,0Ch,'Enter second string: $'
msg3 db 0Ah,0Ch,'Longer is: $'
msg4 db 0Ah,0Ch,'String 1$'
msg5 db 0Ah,0Ch,'String 2$'
str1 db 20,0,20 dup('$')
str2 db 20,0,20 dup('$')
len1 db ?
len2 db ?


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

lea dx,str2
mov ah,0Ah
int 21h

lea dx,msg3
mov ah,09h
int 21h

mov al,[str1+1]
mov len1,al

mov al,[str1+1]
mov len2,al

mov len1,bl
mov len2,bh

cmp bl,bh
jl s1
lea dx,msg5
mov ah,09h
int 21h
jmp done
s1:
lea dx,msg4 
mov ah,09h
int 21h
done:
mov ah,4Ch
int 21h
end main


