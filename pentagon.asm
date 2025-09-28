.MODEL small
.STACK 256

.DATA
curx    DW ?
cury    DW ?
x2_var  DW ?
y2_var  DW ?

dx_abs  DW ?
dy_abs  DW ?
sx      DW ?
sy      DW ?
error   DW ?

.CODE
start:
    mov ax, @DATA
    mov ds, ax

    mov ax, 0013h
    int 10h

    mov ax,160
    mov bx,50
    mov cx,200
    mov dx,100
    call DrawLine

    mov ax,200
    mov bx,100
    mov cx,180
    mov dx,150
    call DrawLine

    mov ax,180
    mov bx,150
    mov cx,140
    mov dx,150
    call DrawLine

    mov ax,140
    mov bx,150
    mov cx,120
    mov dx,100
    call DrawLine

    mov ax,120
    mov bx,100
    mov cx,160
    mov dx,50
    call DrawLine

wait_key:
    mov ah, 0
    int 16h

    mov ax, 0003h
    int 10h

    mov ah, 4Ch
    int 21h


DrawLine PROC
    push ax bx cx dx si di bp

    mov [curx], ax
    mov [cury], bx
    mov [x2_var], cx
    mov [y2_var], dx

    ; dx = abs(x2-x1), sx = sign(x2-x1)
    mov ax, [x2_var]
    sub ax, [curx]
    mov [sx], 1
    cmp ax, 0
    jge dx_pos
    neg ax
    mov [sx], -1
dx_pos:
    mov [dx_abs], ax

    ; dy = abs(y2-y1), sy = sign(y2-y1)
    mov ax, [y2_var]
    sub ax, [cury]
    mov [sy], 1
    cmp ax, 0
    jge dy_pos
    neg ax
    mov [sy], -1
dy_pos:
    mov [dy_abs], ax

    ; error = dx - dy
    mov ax, [dx_abs]
    sub ax, [dy_abs]
    mov [error], ax

draw_loop:
    mov cx, [curx]
    mov dx, [cury]
    mov ah, 0Ch
    mov al, 2      ; зелений
    int 10h

    ; якщо curx=x2 і cury=y2 → кінець
    mov ax, [curx]
    cmp ax, [x2_var]
    jne not_done
    mov ax, [cury]
    cmp ax, [y2_var]
    je line_done
not_done:

    mov ax, [error]
    shl ax, 1

    mov bp, [dy_abs]
    neg bp
    cmp ax, bp
    jle skip_x
    mov ax, [error]
    sub ax, [dy_abs]
    mov [error], ax
    mov ax, [curx]
    add ax, [sx]
    mov [curx], ax
skip_x:

    cmp ax, [dx_abs]
    jge skip_y
    mov ax, [error]
    add ax, [dx_abs]
    mov [error], ax
    mov ax, [cury]
    add ax, [sy]
    mov [cury], ax
skip_y:

    jmp draw_loop

line_done:
    pop bp di si dx cx bx ax
    ret
DrawLine ENDP

END start
