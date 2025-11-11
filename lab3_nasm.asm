; g + fe/d/cb - a

section .data
    ; DATA
    a dq 2
    b dq 3
    c dq 4
    d dq 5
    e dq 6
    f dq 7
    g dq 10
    
    ; Message for output
    msg db "Result g + fe/d/cb - a = ", 0
    msg_len equ $ - msg
    newline db 10
    
section .bss
    result resq 1
    buffer resb 20

section .text
    global _start

_start:
    ; g + fe/d/cb - a
    ; dividing into parts: g + (f*e/d)/(c*b) - a
    
    ; 1. f*e
    mov rax, [f]
    imul rax, [e]       ; rax = f*e
    
    ; 2. Dividing onto d: (f*e)/d
    cqo                 ; Expanding sign rax to rdx:rax
    idiv qword [d]      ; rax = (f*e)/d
    
    ; 3. Saving result
    mov r10, rax        ; r10 = (f*e)/d
    
    ; 4. c*b
    mov rax, [c]
    imul rax, [b]       ; rax = c*b
    
    ; 5. Dividing (f*e)/d on c*b
    mov rbx, rax        ; rbx = c*b
    mov rax, r10        ; rax = (f*e)/d
    cqo
    idiv rbx            ; rax = (f*e)/d/(c*b)
    
    ; 6. Adding g
    add rax, [g]        ; rax = g + (f*e)/d/(c*b)
    
    ; 7. Sub a
    sub rax, [a]        ; rax = g + (f*e)/d/(c*b) - a
    
    ; Saving result
    mov [result], rax
    
    ; Message
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    ; Number to str
    mov rax, [result]
    call print_number
    
    ; New line
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; End of programme
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; code 0
    syscall

; number output
print_number:
    push rbp
    mov rbp, rsp
    
    ; is negative?
    test rax, rax
    jns .positive
    
    ; minus sign
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, minus_sign
    mov rdx, 1
    syscall
    pop rax
    neg rax             ; makin' it positive
    
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
    
    ; output number
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
