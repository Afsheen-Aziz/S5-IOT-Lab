.model small
.stack 100h
.data
    prompt_str db 'Enter a string: $'
    prompt_search db 0Dh,0Ah, 'Enter character to search: $'
    prompt_replace db 0Dh,0Ah, 'Enter character to replace with: $'
    output_msg db 0Dh,0Ah, 'Modified string: $'
    inputbuf db 255,?,255 dup(0)
    search_char db ?
    replace_char db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Input STRING
    lea dx, prompt_str
    mov ah, 09h
    int 21h

    lea dx, inputbuf
    mov ah, 0Ah
    int 21h


    ; Prompt for SEARCH character
    lea dx, prompt_search
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    mov search_char, al

    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    int 21h

    ; Prompt for REPLACE character
    lea dx, prompt_replace
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    mov replace_char, al

    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    int 21h
    
     ; Get string length
    mov bl, [inputbuf+1]        ; BL = length
    mov bh, 0
    lea si, inputbuf + 2

    
    ; DO THE REPLACE
    mov cx, bx                  ; CX = string length
    lea si, inputbuf + 2
replace_loop:
    cmp cx, 0
    je done_replacement

    mov al, [si]
    cmp al, search_char
    jne no_replace
    mov al, replace_char
    mov [si], al

no_replace:
    inc si
    dec cx
    jmp replace_loop

done_replacement:
    ; Add $ at new end
    lea di, inputbuf + 2
    add di, bx                 ; di now at the position after the last valid char
    mov byte ptr [di], '$'

    ; Print output message and result
    lea dx, output_msg
    mov ah, 09h
    int 21h

    lea dx, inputbuf + 2
    mov ah, 09h
    int 21h

done:
    mov ax, 4Ch
    int 21h
main endp
end main
 