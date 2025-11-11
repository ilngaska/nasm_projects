# ⚙️ Assembly Language Labs (NASM, x86-64 Linux) (Faculty of Engineering and Technology; Uzhhorod National University (UzhNU); Major: Computer Engineering (123))

This repository contains several **NASM (x86-64)** programs created for educational purposes.
Each program demonstrates fundamental assembly programming techniques — arithmetic and logical operations, division, shifts, loops, conditional jumps, and low-level I/O with system calls or `printf`.

---

## 🧮 1. `lab2_nasm.asm` — Expression Calculation Using Arithmetic and Shift Instructions

### 📄 Description

Computes the following **integer expression** using only low-level arithmetic (`add`, `sub`, `imul`, `idiv`, etc.) and shift (`sal`, `sar`, `shl`, `shr`) instructions:

[
(4 * c + d - l) / (c - a / 2)
]

### 🧠 Features

* Uses only arithmetic and bit-shift operations (no high-level instructions)
* Demonstrates signed division with `idiv`
* Outputs the result via the C library function `printf`

### 💾 Registers Used

| Register | Purpose                                                   |
| -------- | --------------------------------------------------------- |
| `RAX`    | General accumulator, holds intermediate and final results |
| `RBX`    | Stores the numerator                                      |
| `RCX`    | Stores the denominator                                    |
| `RDX`    | Used for sign extension during division (`cqo`)           |

### ▶️ Example Output

```
Результат: 3
```

### 🧩 Code Structure

```nasm
section .data
    a dq 10
    c dq 11
    d dq 2
    l dq 3
    res dq 0
    fmt db "Result: %ld", 10, 0

section .text
    global main
    extern printf
```

---

## 🧮 2. `lab3_1.asm` — Expression Evaluation: `g + fe/d/cb - a`

### 📄 Description

Calculates a **compound arithmetic expression** using integer division and multiplication:

[
g + \frac{f \times e}{d \times c \times b} - a
]

### 🧠 Features

* Uses **register arithmetic** only
* Step-by-step computation:

  1. Multiply `f * e`
  2. Divide by `d`
  3. Divide by `(c * b)`
  4. Add `g`, subtract `a`
* Outputs the result directly to **stdout** using Linux syscalls (`write`, `exit`)
* Includes a **custom integer-to-string** routine (`print_number`)

### 🧩 Key Instructions

* `imul` — signed integer multiplication
* `idiv` — signed integer division
* `add`, `sub`, `cqo` — arithmetic operations and sign extension
* System calls for output (`sys_write`, `sys_exit`)

### ▶️ Example Output

```
Result g + fe/d/cb - a = 10
```

---

## 📊 3. `lab3_2.asm` — Creating Array B from the First 8 Positive Elements of Array A

### 📄 Description

Given an array `A` containing more than 10 integer elements, the program forms a new array `B` consisting of the **first 8 positive elements** of `A`.

### 🧠 Features

* Iterates through `A` using index registers
* Checks each element’s sign (`test`, `jle`)
* Stores only positive elements into `B`
* Prints both arrays to **stdout**
* Reuses the same `print_number` routine for integer output

### 🧩 Key Operations

| Instruction                 | Purpose               |
| --------------------------- | --------------------- |
| `test` + `jle`              | Check if number ≤ 0   |
| `mov [arrayB + r13*8], rax` | Save positive element |
| `inc`                       | Increment counters    |
| `cmp` + `jge`               | Loop termination      |

### ▶️ Example Output

```
Array A: -5 3 -2 7 12 -8 15 4 -1 9 22 -3 11 6 18
Array B (8 positive elements): 3 7 12 15 4 9 22 11
```

---

## 🧱 Program Structure

Each assembly program follows the same **logical structure**:

```nasm
section .data
    ; Constants and messages

section .bss
    ; Buffers and arrays

section .text
    global _start
_start:
    ; Core logic (arithmetic or loops)
    ; Output section
    ; Exit syscall
```

### 🧩 System Calls Used

| Syscall | Code | Purpose          |
| ------- | ---- | ---------------- |
| `write` | 1    | Output to stdout |
| `exit`  | 60   | End program      |

---

## 🧰 Tools & Setup

### 🧱 Requirements

* **Assembler:** NASM (Netwide Assembler)
* **Linker:** `ld` (GNU linker)
* **Platform:** Linux x86-64

### ▶️ Build and Run

```bash
nasm -f elf64 lab2_nasm.asm -o lab2_nasm.o
gcc -no-pie lab2_nasm.o -o lab2_nasm
./lab2_nasm

nasm -f elf64 lab3_1.asm -o lab3_1.o
ld lab3_1.o -o lab3_1
./lab3_1

nasm -f elf64 lab3_2.asm -o lab3_2.o
ld lab3_2.o -o lab3_2
./lab3_2
```
