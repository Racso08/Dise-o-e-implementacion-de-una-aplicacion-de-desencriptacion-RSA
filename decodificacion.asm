section .data
	msg1 db "Enter a digit",10,13
	len1 equ $- msg1

	msg2 db "Please enter a second digit", 10,13
  	len2 equ $- msg2

   	msg3 db "The result is: ",10,13
   	len3 equ $- msg3

section .bss
	num1 resb 3
	num2 resb 3
	res resb  3

section .text
	global _start

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, len1
	syscall

	mov rax, 0
	mov rdi, 0
	mov rsi, num1
	mov rdx, 3
	syscall

	mov rax, 1
        mov rdi, 1
        mov rsi, msg2
        mov rdx, len2
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, num2
        mov rdx, 3
        syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, msg3
	mov rdx, len3
	syscall
_aqui:
	mov eax, [num1]
	;sub eax, '0'

	mov ebx, [num2]
	;sub ebx, '0'

	mov edx, 0

	div ebx
	;add eax, '0'

	mov [res], eax

	mov rax, 1
	mov rdi, 1
	mov rsi, res
	mov rdx, 1
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
