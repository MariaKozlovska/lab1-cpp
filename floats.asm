DOSSEG
MODEL small
STACK 256

DATASEG
    ; Вихідні дані
    num1        DD 15.5     ; Перше дійсне число
    num2        DD 4.2      ; Друге дійсне число  
    num3        DD 9.0      ; Третє число для кореня
    
    ; Результати обчислень
    sum_result  DD ?        ; додавання
    sub_result  DD ?        ; віднімання  
    mul_result  DD ?        ; множення
    div_result  DD ?        ; ділення
    sqrt_result DD ?        ; квадратного кореня
    
    ; Константи
    two_const   DD 2.0
    exitCode    DB 0

CODESEG
START:
    mov ax, @data           ; Ініціалізація сегмента даних
    mov ds, ax
    
    finit                   ; Ініціалізація FPU
    
    ; === ДОДАВАННЯ: num1 + num2 ===
    fld num1                
    fld num2                
    fadd                    ; ST(0) = ST(0) + ST(1)
    fstp sum_result         ; Зберегти результат
    
    ; === ВІДНІМАННЯ: num1 - num2 ===
    fld num1                
    fld num2                
    fsubr                   ; ST(0) = ST(1) - ST(0)
    fstp sub_result         ; Зберегти результат
    
    ; === МНОЖЕННЯ: num1 * num2 ===
    fld num1                
    fld num2                
    fmul                    ; ST(0) = ST(0) * ST(1)
    fstp mul_result         ; Зберегти результат
    
    ; === ДІЛЕННЯ: num1 / num2 ===
    fld num1                
    fld num2                
    fdivr                   ; ST(0) = ST(1) / ST(0)
    fstp div_result         ; Зберегти результат
    
    ; === КВАДРАТНИЙ КОРІНЬ: sqrt(num3) ===
    fld num3                
    fsqrt                   ; ST(0) = sqrt(ST(0))
    fstp sqrt_result        ; Зберегти результат
    
    ; === ДЕМОНСТРАЦІЯ КОНСТАНТ ===
    fld1                    
    fldz                    
    fadd                    ; 0.0 + 1.0 = 1.0
    fstp st                 ; Видалити результат зі стеку
    
    ; === АБСОЛЮТНЕ ЗНАЧЕННЯ ===
    fld num1                
    fabs                    ; |ST(0)|
    fstp st                 ; Очистити стек
    
    ; === ЗМІНА ЗНАКУ ===
    fld num2                
    fchs                    ; -ST(0)
    fstp st                 ; Очистити стек
    
EXIT_PROGRAM:
    mov ah, 4Ch             ;завершити програму
    mov al, exitCode        
    int 21h                 ; Виклик DOS
    
END START