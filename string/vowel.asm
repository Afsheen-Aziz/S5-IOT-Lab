;string vowel count
.MODEL SMALL
.STACK 100h

.DATA
msg1 db 'Enter a string: $'
msg2 db 13,10,'Number of vowels: $'
str1 db 50,?,50 dup('$')
count db 0

.CODE
main PROC
    mov ax,@data
    mov ds,ax

    ; Prompt user
    mov ah,09h
    lea dx,msg1
    int 21h

    ; Take input
    mov ah,0Ah
    lea dx,str1
    int 21h

    ; Initialize pointers and counters
    lea si,str1+2
    mov cl,[si+1]     ; string length
    mov bl,0          ; vowel counter = 0

next_char:
    mov al,[si]
    ; Check for vowels (both cases)
    cmp al,'A'
    je is_vowel
    cmp al,'E'
    je is_vowel
    cmp al,'I'
    je is_vowel
    cmp al,'O'
    je is_vowel
    cmp al,'U'
    je is_vowel
    cmp al,'a'
    je is_vowel
    cmp al,'e'
    je is_vowel
    cmp al,'i'
    je is_vowel
    cmp al,'o'
    je is_vowel
    cmp al,'u'
    je is_vowel
    jmp skip_vowel

is_vowel:
    inc bl

skip_vowel:
    inc si
    dec cl
    jnz next_char

    mov count,bl

    ; Print result message
    mov ah,09h
    lea dx,msg2
    int 21h

    ; Display count
    mov al,count
    mov ah,0
    call print_num

    ; Exit
    mov ah,4Ch
    int 21h

main ENDP

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
END main
