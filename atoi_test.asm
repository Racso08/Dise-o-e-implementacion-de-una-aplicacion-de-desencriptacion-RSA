%include "linux64.inc"

section .data
	filename db "imagen_desencriptada.txt",0

section .text
	global _start
_start:
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

_fileManipulation:
	mov rax, 2
	mov rdi, filename
	mov rsi, 64 + 1
	mov rdx, 0644o
	syscall

	push rax
	mov rdi, rax
	mov rax, 1
	mov rsi, r10
	mov rdx, 1000
	syscall

	mov rax, 3
	pop rdi
	syscall

	exit
