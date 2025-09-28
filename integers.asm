IDEAL
MODEL small
STACK 256

DATASEG
    num1 DW 7       ; перше число
    num2 DW 3       ; друге число
    res1 DW ?       ; сума
    res2 DW ?       ; різниця
    res3 DW ?       ; добуток
    exitCode DB 0

CODESEG
Start:
    mov ax, @data
    mov ds, ax

    ; Сума
    mov ax, [num1]
    add ax, [num2]
    mov [res1], ax

    ; Різниця
    mov ax, [num1]
    sub ax, [num2]
    mov [res2], ax

    ; Добуток
    mov ax, [num1]
    mov bx, [num2]
    mul bx
    mov [res3], ax

Exit:
    mov ah, 4Ch
    mov al, [exitCode]
    int 21h
END Start
