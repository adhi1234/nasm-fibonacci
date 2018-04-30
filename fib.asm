BITS 64

EXTERN printf

SECTION .data
	printdigit DB "%llu ",10,0

SECTION .text
	GLOBAL main

main:
	push	rbp		; set up the stack frame.
	mov	rbp,	rsp
	sub	rsp,	0x20

	; set up stack frame with some initial variables.
	; int a = qword [ rbp - 0x08 ]
	mov	qword [ rbp - 0x08 ], 0
	; int b = qword [ rbp - 0x10 ]
	mov	qword [ rbp - 0x10 ], 1
	; int c = qword [ rbp - 0x18 ]
	mov	qword [ rbp - 0x18 ], 0
	; int counter = qword [ rbp - 0x20 ]
	mov	qword [ rbp - 0x20 ], 1
	
main_loop:

	; while (rcx < 20) {
	; 	print a
	mov rdi, qword [ rbp - 0x08 ]
	call printn

	mov rax, qword [ rbp - 0x08 ] ; restore registers from stack frame
	mov rbx, qword [ rbp - 0x10 ]
	mov rcx, qword [ rbp - 0x18 ]

	; 	c = a + b
	mov rcx, rax
	add rcx, rbx

	; 	a = b
	mov rax, rbx
	; 	b = c
	mov rbx, rcx
	; }
	
	mov  qword [ rbp - 0x08 ], rax ; store the registers in the stack frame
	mov  qword [ rbp - 0x10 ], rbx
	mov  qword [ rbp - 0x18 ], rcx

	mov 	rcx, qword [ rbp - 0x20 ]	; retrieve the counter from stack frame
	add	rcx, 1				; increment it
	mov 	qword [ rbp - 0x20 ], rcx	; save it back to the stack frame
	cmp	rcx, 90				; loop at most 90 times
	jl main_loop


	mov	rsp, rbp	; tear down the stack frame.
	pop	rbp
exit:
	mov	rax,	60
	mov	rdi,	0
	syscall


printn:
	push	rbp
	mov	rbp,	rsp
	sub	rsp,	0x10

	mov	rax, 	2
	mov	rsi,	rdi
	mov	rdi,	qword printdigit
	call	printf

	mov	rsp,	rbp
	pop	rbp
	ret
