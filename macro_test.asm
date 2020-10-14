section .bss
	num resb 5

section .text
	global _start

_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, num
	mov rdx, 5
	syscall

	mov rbp, num
	call _toInt

	add rax, 2

	mov rax, 60
	mov rdi, 0
	syscall

_toInt:
	mov rax, 0		;inicializo resultado
	mov rbx, 10		;constante
	mov rcx, rbp		;guarda el input en el registro rcx
_aux_toInt:
	movzx rdx, byte[rcx]	;agarra el primer byte
	cmp rdx, 0xa		;rdx == 0?
	je _done
	inc rcx			;siguiente byte
	sub rdx, '0'		;brinda el valor en decimal
	imul rax, rbx		;rax = rax*10
	add rax, rdx		;rax = rax + rdx
	jmp _aux_toInt
_done:
	ret
