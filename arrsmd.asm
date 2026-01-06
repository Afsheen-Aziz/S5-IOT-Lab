.model small
.stack 100h

.data
msg1 db 'Enter n:$'
msg2 db 0Ah,0Ch,'Enter element:$'
msg3 db 0Ah,0Ch,'Element:$'
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

; --- Sort array using Bubble Sort ---
    MOV CL, n          ; Outer loop counter (n)
    DEC CL             ; n-1 passes needed
OUTER_LOOP:
    MOV SI, 0
    MOV CH, CL         ; Inner loop counter
INNER_LOOP:
    MOV AL, arr[SI]
    MOV BL, arr[SI+1]
    CMP AL, BL
    JLE SKIP_SWAP      ; If in order, skip
    MOV arr[SI], BL
    MOV arr[SI+1], AL
SKIP_SWAP:
    INC SI
    DEC CH
    JNZ INNER_LOOP
    DEC CL
    JNZ OUTER_LOOP
    
lea dx,msg3
mov ah,09h
int 21h


mov si, 0
mov al, arr[si]
mov ah, 0
call print_word

mov ah,4Ch
int 21h

print_word proc
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

mov dl,' '
mov ah,02h
int 21h

pop dx
pop cx
pop bx
pop ax
ret
print_word endp
end main