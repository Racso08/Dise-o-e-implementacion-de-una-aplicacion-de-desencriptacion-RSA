section .data
        text0 db "Introduzca el parámetro 'd' de la llave privada...",10,0
        text1 db "Introduzca el parámetro 'n' de la llave privada...",10,0
        text2 db "Introduzca la dirección de la imagen encriptada...",10,0

section .bss
        d resb 16
        n resb 16
	direccion resb 25	

section .text
        global _start 

_start:
	mov rax, text0
	call _print
	call _getD

	mov rax, text1
	call _print
	call _getN

	mov rax, text2
	call _print
	call _getDireccion

        mov rax, 60
        mov rdi, 0
        syscall

_print:
    	push rax
   	 mov rbx, 0
_printLoop:
   	 inc rax
   	 inc rbx
   	 mov cl, [rax]
   	 cmp cl, 0
   	 jne _printLoop

   	 mov rax, 1
   	 mov rdi, 1
   	 pop rsi
   	 mov rdx, rbx
   	 syscall

	 ret

_getD:
	mov rax, 0
	mov rdi, 0
	mov rsi, d
	mov rdx, 16
	syscall
	ret

_getN:
        mov rax, 0
        mov rdi, 0
        mov rsi, n
        mov rdx, 16
        syscall
        ret

_getDireccion:
        mov rax, 0
        mov rdi, 0
        mov rsi, direccion
        mov rdx, 25
        syscall
        ret
