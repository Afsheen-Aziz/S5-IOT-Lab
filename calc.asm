.model small
.stack 1000h
.data
msg1 db 0dh,0ah,'enter the first number : $'
msg2 db 0dh,0ah,'enter the second number : $'
msg3 db 0dh,0ah,'enter the operation , 1=add,2=subtract,3=multiply,4=division,5= exit : $'
msg4 db 0dh,0ah,'result : $'
msg5 db 0dh,0ah,'reminder : $'
num1 dw ?
num2 dw ?
op db ?
result dw ?
reminder dw ?
buffer db 6 dup('$')
.code
main PROC
    mov ax,@data
    mov ds,ax
read:
    lea dx,msg1
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    mov bh,al

    mov ah,01h
    int 21h
    sub al,'0'
    mov bl,al

    mov al,bh
    mov cl,10
    mul cl
    add al,bl
    mov num1,ax

     lea dx,msg2
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    mov bh,al

    mov ah,01h
    int 21h
    sub al,'0'
    mov bl,al

    mov al,bh
    mov cl,10
    mul cl
    add al,bl
    mov num2,ax

    lea dx,msg3
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    mov op,al

    lea dx,msg4
    mov ah,09H
    int 21h



    cmp op ,'1'
    je addition
    cmp op ,'2'
    je subt
    cmp op ,'3'
    je mult
    cmp op ,'4'
    je divi
    cmp op ,'5'
    je done

addition:
    mov ax,num1
    add ax, num2
    mov result,ax
    call DisplayDecimal
    jmp read
subt:
    mov ax,num1
    sub ax,num2
    mov result,ax
    call DisplayDecimal
    jmp read
mult:
    mov ax,num1
    mul num2
    mov result,ax
    call DisplayDecimal 
    jmp read
divi:
    mov dx,0
    mov ax,num1
    div num2
    mov result,ax
    mov reminder,dx
    call DisplayDecimal
    lea dx,msg5
    mov ah,09H
    int 21h
    mov ax,reminder
    call DisplayDecimal
    jmp read
done:
    mov ah,4Ch
    int 21H
main endp  

DisplayDecimal PROC
 PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX, 0           ; CX = digit counter
    MOV BX, 10          ; Divisor (base 10)

CONVERT_LOOP:
    MOV DX, 0           ; Clear DX for division (DX:AX / 10)
    DIV BX              ; AX = quotient, DX = remainder
    PUSH DX             ; Push remainder (digit) onto stack
    INC CX              ; Increment digit counter
    CMP AX, 0
    JNE CONVERT_LOOP

DISPLAY_LOOP:
    POP DX              ; Get digit from stack
    ADD DL, '0'         ; Convert digit to ASCII
    MOV AH, 02H         ; Function to display character
    INT 21H
    LOOP DISPLAY_LOOP   ; Decrement CX and jump if not zero

    POP SI
    POP DX 
    POP CX
    POP BX
    POP AX
    RET
DisplayDecimal ENDP
end main    




    







    

