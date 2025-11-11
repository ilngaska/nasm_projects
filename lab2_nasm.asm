; lab2_nasm.asm — NASM 64-bit для Linux
; (4*c + d - l) / (c - a/2)

section .data
    a   dq 10
    c   dq 11
    d   dq 2
    l   dq 3
    res dq 0
    fmt db "Результат: %ld",10,0     ; for printf

section .text
    global main
    extern printf

main:
    ; --- numerator ---
    mov rax, [c]        ; rax = c
    shl rax, 2          ; rax = 4*c
    add rax, [d]        ; rax = 4*c + d
    sub rax, [l]        ; rax = 4*c + d - l
    mov rbx, rax        ; rbx - numerator

    ; --- denominator ---
    mov rax, [a]        ; rax = a
    shr rax, 1          ; rax = a/2
    mov rcx, [c]
    sub rcx, rax        ; rcx = c - a/2

    ; --- division ---
    mov rax, rbx        ; rax = numerator
    cqo                 ; expand RAX у RDX:RAX
    idiv rcx            ; rax = (4*c + d - l)/(c - a/2)

    ; --- saving result ---
    mov [res], rax

    ; --- call printf ---
    mov rdi, fmt        ; first argument — format
    mov rsi, rax        ; second argument — result
    xor rax, rax        ; for printf: number of arguments xmm = 0
    call printf

    ; --- end ---
    mov rax, 0
    ret

