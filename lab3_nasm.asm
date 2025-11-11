; Завдання 1: Обчислити g + fe/d/cb - a

section .data
    ; Вхідні дані
    a dq 2
    b dq 3
    c dq 4
    d dq 5
    e dq 6
    f dq 7
    g dq 10
    
    ; Повідомлення для виводу
    msg db "Результат обчислення g + fe/d/cb - a = ", 0
    msg_len equ $ - msg
    newline db 10
    
section .bss
    result resq 1
    buffer resb 20

section .text
    global _start

_start:
    ; Обчислення виразу: g + fe/d/cb - a
    ; Розбиваємо на частини: g + (f*e/d)/(c*b) - a
    
    ; 1. Обчислюємо f*e
    mov rax, [f]
    imul rax, [e]       ; rax = f*e
    
    ; 2. Ділимо на d: (f*e)/d
    cqo                 ; Розширюємо знак rax в rdx:rax
    idiv qword [d]      ; rax = (f*e)/d
    
    ; 3. Зберігаємо проміжний результат
    mov r10, rax        ; r10 = (f*e)/d
    
    ; 4. Обчислюємо c*b
    mov rax, [c]
    imul rax, [b]       ; rax = c*b
    
    ; 5. Ділимо (f*e)/d на c*b
    mov rbx, rax        ; rbx = c*b
    mov rax, r10        ; rax = (f*e)/d
    cqo
    idiv rbx            ; rax = (f*e)/d/(c*b)
    
    ; 6. Додаємо g
    add rax, [g]        ; rax = g + (f*e)/d/(c*b)
    
    ; 7. Віднімаємо a
    sub rax, [a]        ; rax = g + (f*e)/d/(c*b) - a
    
    ; Зберігаємо результат
    mov [result], rax
    
    ; Виводимо повідомлення
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    ; Конвертуємо число в рядок
    mov rax, [result]
    call print_number
    
    ; Виводимо новий рядок
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Вихід з програми
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; код завершення 0
    syscall

; Функція для виводу числа
print_number:
    push rbp
    mov rbp, rsp
    
    ; Перевірка на від'ємне число
    test rax, rax
    jns .positive
    
    ; Виводимо мінус
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, minus_sign
    mov rdx, 1
    syscall
    pop rax
    neg rax             ; Робимо число додатним
    
.positive:
    mov rcx, buffer
    add rcx, 19
    mov byte [rcx], 0
    mov rbx, 10
    
.convert_loop:
    dec rcx
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rcx], dl
    test rax, rax
    jnz .convert_loop
    
    ; Виводимо число
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, buffer
    add rdx, 19
    sub rdx, rcx
    syscall
    
    pop rbp
    ret

section .data
    minus_sign db '-'
