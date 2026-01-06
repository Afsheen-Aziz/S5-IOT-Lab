.MODEL SMALL
.STACK 100h
.DATA
msg1 db 'Enter string: $'
msg2 db 0Ah,0Dh, 'Number of vowels: $'
str1 db 20,0,20 dup(?)
count db 0

.CODE
main:
    mov ax, @data
    mov ds, ax

    ; Prompt
    lea dx, msg1
    mov ah, 09h
    int 21h

    ; Read string
    lea dx, str1
    mov ah, 0Ah
    int 21h

    ; Initialize
    mov cl, [str1+1]      ; length
    lea si, str1+2        ; start of data
    mov count, 0

check_loop:
    cmp cl, 0
    je done
    mov al, [si]

    ; Check vowels (lowercase)
    cmp al, 'a'
    je is_vowel
    cmp al, 'e'
    je is_vowel
    cmp al, 'i'
    je is_vowel
    cmp al, 'o'
    je is_vowel
    cmp al, 'u'
    je is_vowel
    jmp next_char

is_vowel:
    inc count

next_char:
    inc si
    dec cl
    jmp check_loop

done:
    ; Print message
    lea dx, msg2
    mov ah, 09h
    int 21h

    ; Print count
    mov al, count
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    ; Exit
    mov ah, 4Ch
    int 21h
END main
