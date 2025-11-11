; Завдання 2: Формування масиву В з перших 8 додатних елементів масиву А

section .data
    ; Масив А (більше 10 елементів, включаючи від'ємні)
    arrayA dq -5, 3, -2, 7, 12, -8, 15, 4, -1, 9, 22, -3, 11, 6, 18
    lenA equ ($ - arrayA) / 8
    
    msg_a db "Масив A: ", 0
    msg_a_len equ $ - msg_a
    
    msg_b db "Масив B (8 додатних): ", 0
    msg_b_len equ $ - msg_b
    
    space db " ", 0
    newline db 10
    
section .bss
    arrayB resq 8       ; Масив B для 8 додатних елементів
    buffer resb 20      ; Буфер для конвертації чисел

section .text
    global _start

_start:
    ; Виводимо повідомлення про масив A
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_a
    mov rdx, msg_a_len
    syscall
    
    ; Виводимо масив A
    xor r12, r12        ; Лічильник для масиву A
.print_a:
    cmp r12, lenA
    jge .end_print_a
    
    mov rax, [arrayA + r12*8]
    call print_number
    
    ; Виводимо пробіл
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    inc r12
    jmp .print_a
    
.end_print_a:
    ; Новий рядок
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Формуємо масив B
    xor r12, r12        ; Індекс для масиву A
    xor r13, r13        ; Лічильник додатних елементів
    
.loop:
    cmp r12, lenA       ; Перевірка, чи пройшли весь масив A
    jge .end_loop
    
    cmp r13, 8          ; Перевірка, чи знайшли 8 додатних
    jge .end_loop
    
    mov rax, [arrayA + r12*8]
    
    ; Перевірка, чи число додатне
    test rax, rax
    jle .skip           ; Пропускаємо, якщо <= 0
    
    ; Додаємо до масиву B
    mov [arrayB + r13*8], rax
    inc r13
    
.skip:
    inc r12
    jmp .loop
    
.end_loop:
    ; Виводимо повідомлення про масив B
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_b
    mov rdx, msg_b_len
    syscall
    
    ; Виводимо масив B
    xor r12, r12
.print_b:
    cmp r12, r13        ; Виводимо тільки знайдені елементи
    jge .end_print_b
    
    mov rax, [arrayB + r12*8]
    call print_number
    
    ; Виводимо пробіл
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    inc r12
    jmp .print_b
    
.end_print_b:
    ; Новий рядок
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Вихід з програми
    mov rax, 60
    xor rdi, rdi
    syscall

; Функція для виводу числа (signed)
print_number:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    mov r13, rax        ; Зберігаємо число
    
    ; Перевірка на від'ємне число
    test rax, rax
    jns .positive
    
    ; Виводимо мінус
    push rax
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel minus_sign]
    mov rdx, 1
    syscall
    pop rax
    neg rax
    
.positive:
    ; Конвертуємо число в рядок
    lea rcx, [rel buffer]
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
    lea rdx, [rel buffer]
    add rdx, 19
    sub rdx, rcx
    syscall
    
    pop r13
    pop r12
    pop rbp
    ret

section .data
    minus_sign db '-'
