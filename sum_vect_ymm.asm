%define CLOCK_MONOTONIC 1
%define EOF 0xffffffff
%define N_INT 8

section .data
    filename db 'data.txt',0
    read_mode db "r",0
    read_fmt db "%d %d",10,0
    print_int_fmt db "%d",10,0
    time_fmt db "Elapsed time: %ld.%09ld seconds", 10, 0   

    

section .text
    global main
    extern fopen
    extern fclose
    extern fscanf
    extern printf
    extern aligned_alloc
    extern free
    extern rewind
    extern clock_gettime
    
main:
    push rbp
    mov rbp, rsp

    push rbx

    ;STACK: rbp
    mov rdi,filename
    mov rsi, read_mode
    call fopen

    mov r12, rax ; pointer to FILE

    sub rsp, 40

    ;STACK: rbp; rbx, (int32); (int32); timespec_1 (16-byte); timespect_2 (16-byte)

    ;let's count how many lines the file has

    xor r15,r15

    .for_loop1:

        mov rdi, r12
        mov rsi, read_fmt
        lea rdx, [rbp-12]
        lea rcx, [rbp-16]
        xor rax,rax
        call fscanf

        cmp eax,EOF
        je .end_for_loop1
        inc r15
        jmp .for_loop1
    
    .end_for_loop1:

    ; rewind file
    mov rdi, r12
    call rewind

    mov rdi, 32
    lea rsi, [r15*4] ; number of bytes to allocate
    call aligned_alloc
    mov r14,rax ; pointer left array

    mov rdi, 32
    lea rsi, [r15*4] ; number of bytes to allocate
    call aligned_alloc
    mov r13,rax ; pointer right array

    mov rdi, 32
    lea rsi, [r15*4] ; number of bytes to allocate
    call aligned_alloc
    mov rbx,rax ; pointer result array


     ;make for loop to read from file
    xor r15,r15

    .for_loop2:
        mov rdi, r12
        mov rsi, read_fmt
        lea rdx, [rbp-12]
        lea rcx, [rbp-16]
        xor rax,rax
        call fscanf

        cmp eax,EOF
        je .end_for_loop2

        mov eax, [rbp-12]
        mov [r14+r15*4],eax

        mov eax, [rbp-16]
        mov [r13+r15*4],eax

        inc r15
        jmp .for_loop2

    .end_for_loop2:

    mov edi, CLOCK_MONOTONIC
    lea rsi, [rbp-24]
    call clock_gettime

    ;--------------------------
    ;         SUM LOOP        |
    ;--------------------------
    xor rdx,rdx ; index for the next for loop
    ;sub r15, 2
    .sum_for_loop:
        cmp rdx, r15
        jge .end_sum_for_loop

        ;if I am here, I know I have 4 ints
        vmovdqa ymm0, [r14+rdx*4]
        vmovdqa ymm1, [r13+rdx*4]

        vpaddd ymm0,ymm1

        vmovdqa [rbx+rdx*4], ymm0
    

        add rdx, N_INT
        jmp .sum_for_loop
    .end_sum_for_loop:

    mov edi, CLOCK_MONOTONIC
    lea rsi, [rbp-40]
    call clock_gettime
    
    ; I pop r13 because I need a callee saved register to call printf
    ; However, printf needs aligned mem so I save also r14
    ; in this way I can use r13 as index register for the loop
    push r13
    push r14

    ; calculate time
    mov rax, [rbp-40]     ; end seconds
    sub rax, [rbp-24]     ; sec delta
    mov rdx, rax          ; save sec delta

    mov rax, [rbp - 40 + 8]   ; end nanoseconds
    sub rax, [rbp - 24 + 8] ; nsec delta
    js fix_nsec                   ; if negative, we need to adjust

    jmp save_time

    fix_nsec:
        add rax, 1000000000
        dec rdx  

    save_time:
        push rax
        push rdx

    ; print result

    xor r13,r13
    .print_for_loop:
        cmp r13, r15
        jge .end_print_for_loop

        mov rdi, print_int_fmt
        mov esi, dword [rbx+r13*4]
        xor eax, eax
        call printf

        inc r13
        jmp .print_for_loop

    .end_print_for_loop:

    ; print time
    pop rdx
    pop rax

    mov rsi, rdx
    mov rdx, rax
    lea rdi, time_fmt
    xor eax, eax
    call printf
    
    ; epologue 
    pop r14
    pop r13

    ;close file    
    mov rdi, r12
    call fclose

    ;free memory
    mov rdi, r14
    call free

    mov rdi, r13
    call free

    mov rdi, rbx
    call free

    ;restore stack

    add rsp, 40
    pop rbx
    pop rbp

    ;return 0

    xor rax, rax
    ret

section .note.GNU-stack progbits
