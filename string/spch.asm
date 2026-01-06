;string special character count
.model small
.stack 100h
.data
msg1 db "enter a string: $"
msg2 db 13,10,"no. of spl chars: $"
str1 db 50,?,50 dup('$')
count db 0

.code
main proc
mov ax,@data
mov ds,ax

mov ah,09h
lea dx,msg1
int 21h

mov ah,0Ah
lea dx,str1
int 21h

lea si,str1+2
mov cl,[si+1]
mov bl,0

next_char:
mov al,[si]
cmp al,'A'
jb check_lower
cmp al,'Z'
jbe not_special

check_lower:
cmp al,'a'
jb check_digit
cmp al,'z'
jbe not_special

check_digit:
cmp al,'0'
jb is_special
cmp al,'9'
jbe not_special

is_special:
inc bl

not_special:
inc si
dec cl
jnz next_char
mov count,bl

mov ah,09h
lea dx,msg2
int 21h

mov al,count
mov ah,0
call print_num

mov ah,4Ch
int 21h

main endp

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