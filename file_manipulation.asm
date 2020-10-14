%include "linux64.inc"

section .data
	filename db "0.txt",0
	out_filename db "imagen_desencriptada.txt",0
	len equ $ - out_filename
	text0 db "Ingrese el párametro 'd' de la llave privada...",10,0
	text1 db "Introduzca el parámetro 'n' de la llave privada...",10,0
	fd dq 0

section .bss
	text resb 1750866
	d resb 16
	n resb 16
	output resb 1000

section .text
	global _start

_start:
	print text0

_getD:
	mov rax, 0
	mov rdi, 0
	mov rsi, d
	mov rdx, 16
	syscall

	mov rbp, d
	call _convertParam
	mov r8, rax

	print text1

_getN:
        mov rax, 0
        mov rdi, 0
        mov rsi, n
        mov rdx, 16
        syscall

	mov rbp, n
	call _convertParam
	mov r9, rax

_fileManipulation:
	mov rax, 2
	mov rdi, filename
	mov rsi, 0
	mov rdx, 0
	syscall

	push rax

	mov rdi, rax
	mov rax, 0
	mov rsi, text
	mov rdx, 1750865
	syscall

	mov rax, 3
	pop rdi
	syscall

_getByte:
	mov rcx, text		;guarda el input en el registro rcx
	add rcx, 0x94		;coloca puntero en el primer dato
	add rcx, 1		;aumenta un byte
	mov rsi, 0 		;contador
	mov rax, 0  		;inicializo resultado
	mov rbx, 10		;constante de multiplicacion (rax = rax * 10)
	mov r14, 0		;contador para la variable output

_aux_getByte:
	movzx rdx, byte[rcx]	;agarra el primer byte
	cmp rdx, 0xd		;se termino la matriz
	je _done 		;verificar porque no se que mierdas hacer
	cmp rdx, 0x20		;comprueba si es un espacio
	je _incByte

_toInt:
        inc rcx                 ;siguiente byte
        sub rdx, '0'            ;brinda el valor en decimal
        imul rax, rbx           ;rax = rax*10
        add rax, rdx            ;rax = rax + rdx
	jmp _aux_getByte

_incByte:
	cmp rsi, 1		;compara si la bandera(dos numeros) esta activa
	je _toDesencrip
	inc rcx			;siguiente byte
	inc rsi			;aumenta el contador
	mov rdi, rax		;guardo el primer valor obtenido en rdi
	mov rax, 0		;inicializa resultado
	jmp _aux_getByte

_toDesencrip:
	shl rdi, 8		;se mueven 8 espacios a la izquierda
	add rdi, rax		;se suman los dos valores
	mov r10, rdi		;se guarda el valor a desencriptar
	mov r11, 1		;se inicializa el valor del auxiliar
	mov r12, 0		;contador
	mov r13, r10		;temporal que alberga el valor a desencriptar

_desencripProcess:
	cmp r12, r8		; compara si d == r11
	je _prepareWriting
	mov r10,r13		;reafirma el parámetro
	imul r10, r11		; =(1*c)
	mov rax, r10
	mov rdx, 0		;confirmacion de que el registro no hay nada
	div r9			; mod(n)
	mov r11, rdx		;guarda el valor en r11
	inc r12			;incrementa el contador
	jmp _desencripProcess

_prepareWriting:
	mov rax, r11		;muevo el valor desencriptado al registro rax
	call  _toStr		;llama a la función para volver el decimal a ascii

_writeFile:
	mov rdi, out_filename
	mov rsi, 0102o     ;O_CREAT, man open
	mov rdx, 0666o     ;umode_t
 	mov rax, 2
 	syscall

	mov [fd], rax
 	mov rdx, 100       ;message length
 	mov rsi, output       ;message to write
 	mov rdi, [fd]      ;file descriptor
 	mov rax, 1         ;system call number (sys_write)
 	syscall            ;call kernel

 	mov rdi, [fd]
 	mov rax, 3         ;sys_close
 	syscall

 	mov rax, 60        ;system call number (sys_exit)
	syscall            ;call k

_convertParam:
	mov rax, 0		;inicializo resultado
	mov rbx, 10		;constante
	mov rcx, rbp		;guarda el input en el registro rcx

_aux_convertParam:
	movzx rdx, byte[rcx]	;agarra el primer byte
	cmp rdx, 0xa		;rdx == 0?
	je _completed
	inc rcx			;siguiente byte
	sub rdx, '0'		;brinda el valor en decimal
	imul rax, rbx		;rax = rax*10
	add rax, rdx		;rax = rax + rdx
	jmp _aux_convertParam

_completed:
	ret

_toStr:
	mov r12, 32	;resultado
	mov rbx, 10	;constante de división
	mov r11, 100	;constante para ubicación
	mov rdx, 1	;inicializo el registro

_aux_toStr:
	mov rdx, 0	;inicializa el registro rdx
	div rbx		;divide por 10 el registro 10
	cmp rdx, 0	;compara el número se convirtio en cero
	je _toStore
	add rdx, 48	;suma 48 al resultado
	imul rdx, r11	;multiplica por la constante
	add r12, rdx	;suma al resultado el valor calculado
	imul r11, 100	;actualiza la constante de multiplicacion
	jmp _aux_toStr

_toStore:
	mov rax, r11	;mueve la constante de ubicacion a rax
	mov rdx, 0	;inicializa el registro para almacenar el residuo
	mov rcx, 100	;carga 100 al registro rcx
	div rcx		;divido rax entre 100
	mov r11, rax	;carga en r11 la constante de ubicacion actualizada
	mov rax, r12    ;carga a rax el valor en ascii ordenado

_aux_toStore:
	cmp rax, 0			;se concluye la funcion
	je _aux_getByte
	mov rdx, 0			;incializa el registro para almacenar el residuo
	div r11				;divido por la constante de ubicacion
	mov [output + r14], rax		;carga en la variable output el n elemento ascii
	inc r14				;incrementa el contador de output
	mov r12, rdx			;guardo el resto del ascii
	mov rax, r11   			;mueve la constante de ubicacion a rax
        mov rdx, 0     			;inicializa el registro para almacenar el residuo
        mov rcx, 100   			;carga 100 al registro rcx
        div rcx         		;divido rax entre 100
        mov r11, rax    		;carga en r11 la constante de ubicacion actualizada
	mov rax, r12			;carga a rax el valor en ascii ordenado
	jmp _aux_toStore

_fixEntry:
        inc rcx         ;siguiente byte
        ret

_done:
	exit
