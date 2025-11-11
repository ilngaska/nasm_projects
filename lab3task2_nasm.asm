; Task 2: Creating array В from first 8 positive elements of array А

section .data
    ; Array А (10+ elements, including negative)
    arrayA dq -5, 3, -2, 7, 12, -8, 15, 4, -1, 9, 22, -3, 11, 6, 18
    lenA equ ($ - arrayA) / 8
    
    msg_a db "Array A: ", 0
    msg_a_len equ $ - msg_a
    
    msg_b db "Array B (8 positive elements): ", 0
    msg_b_len equ $ - msg_b
    
    space db " ", 0
    newline db 10
    
section .bss
    arrayB resq 8       ; Array B of 8 positive elements
    buffer resb 20      ; Buffer for number convertation

section .text
    global _start

_start:
    ; Message abt array A
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_a
    mov rdx, msg_a_len
    syscall
    
    ; Array A
    xor r12, r12        ; Counter for array A
.print_a:
    cmp r12, lenA
    jge .end_print_a
    
    mov rax, [arrayA + r12*8]
    call print_number
    
    ; outpur space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    inc r12
    jmp .print_a
    
.end_print_a:
    ; new line
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Array B
    xor r12, r12        ; index for array A
    xor r13, r13        ; positive elements counter
    
.loop:
    cmp r12, lenA       ; Checking if all elements of array A were checked
    jge .end_loop
    
    cmp r13, 8          ; 8 positive found?
    jge .end_loop
    
    mov rax, [arrayA + r12*8]
    
    ; Checking if positive
    test rax, rax
    jle .skip           ; Good to go if <= 0
    
    ; Adding to array B
    mov [arrayB + r13*8], rax
    inc r13
    
.skip:
    inc r12
    jmp .loop
    
.end_loop:
    ; Message abt array B
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_b
    mov rdx, msg_b_len
    syscall
    
    ; Array B
    xor r12, r12
.print_b:
    cmp r12, r13        ; Elements
    jge .end_print_b
    
    mov rax, [arrayB + r12*8]
    call print_number
    
    ; Space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    inc r12
    jmp .print_b
    
.end_print_b:
    ; new line
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; end of programme
    mov rax, 60
    xor rdi, rdi
    syscall

; Number output (signed)
print_number:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    mov r13, rax        ; Saving
    
    ; Is negative?
    test rax, rax
    jns .positive
    
    ; minus sign
    push rax
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel minus_sign]
    mov rdx, 1
    syscall
    pop rax
    neg rax
    
.positive:
    ; int to str
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
    
    ; Output number
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
