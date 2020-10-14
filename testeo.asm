section .text
global _start          ;must be declared for linker (ld)

_start:                ;tell linker entry point

mov eax, 88
	mov ebx, 0xCCCCCCCD
   	xor rdi, rdi

.loop:
    mov ecx, eax ; save original number

    mul ebx ; divide by 10 using agner fog's 'magic number'
    shr edx, 3 ;

    mov eax, edx ; store quotient for next loop

    lea edx, [edx*4 + edx] ; multiply by 10
    shl rdi, 8 ; make room for byte
    lea edx, [edx*2 - '0'] ; finish *10 and convert to ascii
    sub ecx, edx ; subtract from original number to get remainder

    lea rdi, [rdi + rcx] ; store next byte

    test eax, eax
    jnz .loop

	mov r10, rdi	;guarda el valor para escritura

    mov rdi, filename
    mov rsi, 0102o     ;O_CREAT, man open
    mov rdx, 0666o     ;umode_t
    mov rax, 2
    syscall

    mov [fd], rax
    mov rdx, len       ;message length
    mov rsi, r10       ;message to write
    mov rdi, [fd]      ;file descriptor
    mov rax, 1         ;system call number (sys_write)
    syscall            ;call kernel

    mov rdi, [fd]
    mov rax, 3         ;sys_close
    syscall

    mov rax, 60        ;system call number (sys_exit)
    syscall            ;call kernel

section .data
    msg db 'Hello, world', 0xa
    len equ $ - msg
    filename db 'imagen_desencriptada.txt', 0
    lenfilename equ $ - filename
    fd dq 0
