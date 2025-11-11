; lab2_nasm.asm — NASM 64-bit для Linux
; Обчислення: (4*c + d - l) / (c - a/2)

section .data
    a   dq 10
    c   dq 11
    d   dq 2
    l   dq 3
    res dq 0
    fmt db "Результат: %ld",10,0     ; для printf

section .text
    global main
    extern printf

main:
    ; --- чисельник ---
    mov rax, [c]        ; rax = c
    shl rax, 2          ; rax = 4*c
    add rax, [d]        ; rax = 4*c + d
    sub rax, [l]        ; rax = 4*c + d - l
    mov rbx, rax        ; rbx = чисельник

    ; --- знаменник ---
    mov rax, [a]        ; rax = a
    shr rax, 1          ; rax = a/2
    mov rcx, [c]
    sub rcx, rax        ; rcx = c - a/2

    ; --- ділення ---
    mov rax, rbx        ; rax = чисельник
    cqo                 ; розширюємо RAX у RDX:RAX
    idiv rcx            ; rax = (4*c + d - l)/(c - a/2)

    ; --- зберігаємо результат ---
    mov [res], rax

    ; --- виклик printf ---
    mov rdi, fmt        ; перший аргумент — формат
    mov rsi, rax        ; другий аргумент — результат
    xor rax, rax        ; для printf: число аргументів xmm = 0
    call printf

    ; --- вихід ---
    mov rax, 0
    ret

