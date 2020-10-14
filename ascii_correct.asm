%include "linux64.inc"

section .bss
	output resb 10

section .text
	global _start

_start:
	mov rax, 0
	mov r14, 0	;borrrraaaaaaaaaaaaaaaaarrrrrrrrrrrrrrrrrr
	mov r12, 32	;resultado
	mov rbx, 10	;constante de división
	mov r11, 100	;constante para ubicación
	mov rdx, 1	;inicializo el registro
	cmp rax, 0	;si el resultado es cero
	je _excepcion

_aux_toStr:
	mov rdx, 0	;inicializa el registro rdx
	cmp rax, 0      ;compara el número se convirtio en cero
        je _toStore
	div rbx		;divide por 10 el registro 10
	add rdx, 48	;suma 48 al resultado
	imul rdx, r11	;multiplica por la constante
	add r12, rdx	;suma al resultado el valor calculado
	imul r11, 100	;actualiza la constante de multiplicacion
	jmp _aux_toStr

_excepcion:
	mov r12, 4832	;almacena el equivalente de 0 en ascii
	jmp _toStore

_toStore:
	mov rax, r11	;mueve la constante de ubicacion a rax
	mov rdx, 0	;inicializa el registro para almacenar el residuo
	mov r15, 100	;carga 100 al registro rcx
	div r15		;divido rax entre 100
	mov r11, rax	;carga en r11 la constante de ubicacion actualizada
	mov rax, r12    ;carga a rax el valor en ascii ordenado

_aux_toStore:
	cmp rax, 0			;se concluye la funcion
	je _done
	mov rdx, 0			;incializa el registro para almacenar el residuo
	div r11				;divido por la constante de ubicacion
	mov [output + r14], rax		;carga en la variable output el n elemento ascii
	inc r14				;incrementa el contador de output
	mov r12, rdx			;guardo el resto del ascii
	mov rax, r11   			;mueve la constante de ubicacion a rax
        mov rdx, 0     			;inicializa el registro para almacenar el residuo
        mov r15, 100   			;carga 100 al registro rcx
        div r15         		;divido rax entre 100
        mov r11, rax    		;carga en r11 la constante de ubicacion actualizada
	mov rax, r12			;carga a rax el valor en ascii ordenado
	jmp _aux_toStore



_done:
	exit
