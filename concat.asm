.model small
.stack 100h
.data
msg1 db 'Enter first string: $'
msg2 db 0Ah,0Dh,'Enter second string: $'
msg3 db 0Ah,0Dh,'Concatenated string: $'

str1 db 20,0,20 dup(?)    ; DOS input buffer: [maxlen][len][data...]
str2 db 20,0,20 dup(?)
result db 40 dup('$')      ; buffer to store concatenated string

.code
main:
    mov ax,@data
    mov ds,ax

; --- Input first string ---
    lea dx,msg1
    mov ah,09h
    int 21h

    lea dx,str1
    mov ah,0Ah
    int 21h

; --- Input second string ---
    lea dx,msg2
    mov ah,09h
    int 21h

    lea dx,str2
    mov ah,0Ah
    int 21h

; --- Copy str1 to result ---
    lea si,str1+2         ; SI points to first char of str1
    lea di,result         ; DI points to result
    mov cl,[str1+1]       ; number of chars in str1
copy1:
    cmp cl,0
    je copy2_start
    mov al,[si]
    mov [di],al
    inc si
    inc di
    dec cl
    jmp copy1 

; --- Copy str2 to result ---
copy2_start:
    lea si,str2+2
    mov cl,[str2+1]
copy2:
    cmp cl,0
    je finish
    mov al,[si]
    mov [di],al
    inc si
    inc di
    dec cl
    jmp copy2

finish:
    mov byte ptr [di],'$'    ; terminate result with $

; --- Display concatenated string ---
    lea dx,msg3
    mov ah,09h
    int 21h

    lea dx,result
    mov ah,09h
    int 21h

; --- Exit ---
    mov ah,4Ch
    int 21h
end main
