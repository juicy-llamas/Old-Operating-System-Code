;defines the idt, the tss (MAYBE IF I NEED THIS), and related functions.

;			+---+---+---+---+---+---+---+---+
;flags:  	|pre| priv. |sto|   gate type   |
;			+---+---+---+---+---+---+---+---+

_idt:
	int_0:
		.low_offset dw exception_handler_0
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_1:
		.low_offset dw exception_handler_1
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_2:
		.low_offset dw exception_handler_2
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_3:
		.low_offset dw exception_handler_3
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_4:
		.low_offset dw exception_handler_4
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_5:
		.low_offset dw exception_handler_5
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_6:
		.low_offset dw exception_handler_6
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_7:
		.low_offset dw exception_handler_7
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_8:
		.low_offset dw exception_handler_8
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_9:
		.low_offset dw exception_handler_9
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_10:
		.low_offset dw exception_handler_10
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_11:
		.low_offset dw exception_handler_11
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_12:
		.low_offset dw exception_handler_12
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_13:
		.low_offset dw exception_handler_13
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_14:
		.low_offset dw exception_handler_14
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_15:
		.low_offset dw exception_handler_15
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_16:
		.low_offset dw exception_handler_16
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_17:
		.low_offset dw exception_handler_17
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_18:
		.low_offset dw exception_handler_18
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_19:
		.low_offset dw exception_handler_19
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_20:
		.low_offset dw exception_handler_20
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers a238re trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_21:
		.low_offset dw exception_handler_21
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_22:
		.low_offset dw exception_handler_22
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_23:
		.low_offset dw exception_handler_23
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_24:
		.low_offset dw exception_handler_24
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_25:
		.low_offset dw exception_handler_25
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_26:
		.low_offset dw exception_handler_26
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_27:
		.low_offset dw exception_handler_27
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_28:
		.low_offset dw exception_handler_28
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_29:
		.low_offset dw exception_handler_29
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_30:
		.low_offset dw exception_handler_30
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	int_31:
		.low_offset dw exception_handler_31
		.code_segment dw 8
		.zero db 0
		.flags db 10001110B					;our exception handlers are trap gates.
		.offset_mid dw 0
		.offset_high dd 0
		._zero dd 0
	;pad times (256-32)*16 db 0
	idt_ptr:
		dw (idt_ptr-_idt-1)
		dq (_idt)

exception_handler_0:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 0
	jmp exception_handler
exception_handler_1:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 1
	jmp exception_handler
exception_handler_2:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 2
	jmp exception_handler
exception_handler_3:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 3
	jmp exception_handler
exception_handler_4:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 4
	jmp exception_handler
exception_handler_5:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 5
	jmp exception_handler
exception_handler_6:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 6
	jmp exception_handler
exception_handler_7:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 7
	jmp exception_handler
exception_handler_8:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 8
	jmp exception_handler
exception_handler_9:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 9
	jmp exception_handler
exception_handler_10:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 10
	jmp exception_handler
exception_handler_11:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 11
	jmp exception_handler
exception_handler_12:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 12
	jmp exception_handler
exception_handler_13:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 13
	jmp exception_handler
exception_handler_14:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 14
	jmp exception_handler
exception_handler_15:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 15
	jmp exception_handler
exception_handler_16:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 16
	jmp exception_handler
exception_handler_17:
	pop qword [exception_info_struct.error_code]
	mov qword [exception_info_struct.exception_no], 17
	jmp exception_handler
exception_handler_18:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 18
	jmp exception_handler
exception_handler_19:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 19
	jmp exception_handler
exception_handler_20:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 20
	jmp exception_handler
exception_handler_21:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 21
	jmp exception_handler
exception_handler_22:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 22
	jmp exception_handler
exception_handler_23:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 23
	jmp exception_handler
exception_handler_24:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 24
	jmp exception_handler
exception_handler_25:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 25
	jmp exception_handler
exception_handler_26:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 26
	jmp exception_handler
exception_handler_27:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 27
	jmp exception_handler
exception_handler_28:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 28
	jmp exception_handler
exception_handler_29:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 29
	jmp exception_handler
exception_handler_30:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 30
	jmp exception_handler
exception_handler_31:
	mov qword [exception_info_struct.error_code], 0
	mov qword [exception_info_struct.exception_no], 31
	jmp exception_handler

exception_info_struct:
	.exception_no dq 0
	.error_code dq 0
	._rip dq 0
	._cs dq 0
	._rflags dq 0
	._rsp dq 0
	._ss dq 0

exception_handler:
	push rax
	mov rax, qword [rsp+8*2]
	mov qword [exception_info_struct._rip], rax
	mov rax, qword [rsp+8*3]
	mov qword [exception_info_struct._rip], rax
	mov rax, qword [rsp+8*4]
	mov qword [exception_info_struct._rip], rax
	mov rax, qword [rsp+8*5]
	mov qword [exception_info_struct._rip], rax
	mov rax, qword [rsp+8*6]
	mov qword [exception_info_struct._rip], rax

	;DO ANY OTHER EXCEPTION NOTIFICATION/TASK MANAGEMENT STUFF HERE

	pop rax
	iretq

exception_0 db "#DE "
exception_1 db "#DB "
exception_2 db "NOMA"
exception_3 db "#BP "
exception_4 db "#OF "
exception_5 db "#BR "
exception_6 db "#UD "
exception_7 db "#NM "
exception_8 db "#DF "
exception_9 db "COPS"
exception_10 db "#TS "
exception_11 db "#NP "
exception_12 db "#SS "
exception_13 db "#GP "
exception_14 db "#PF "
exception_15 db "RES."
exception_16 db "#MF "
exception_17 db "#AC "
exception_18 db "#MC "
exception_19 db "#XM "
exception_20 db "#VE "
exception_21 db "RES."
exception_22 db "RES."
exception_23 db "RES."
exception_24 db "RES."
exception_25 db "RES."
exception_26 db "RES."
exception_27 db "RES."
exception_28 db "RES."
exception_29 db "RES."
exception_30 db "RES."
exception_31 db "RES."
exception_32 db "RES."

exception_msg db "exception: ",0
rflags_msg db "rflags: ",0
rax_msg db "rax: ",0
rbx_msg db "rbx: ",0
rcx_msg db "rcx: ",0
rdx_msg db "rdx: ",0
rsi_msg db "rsi: ",0
rdi_msg db "rdi: ",0
rsp_msg db "rsp: ",0
rbp_msg db "rbp: ",0
r8_msg db "r8: ",0
r9_msg db "r9: ",0
r10_msg db "r10: ",0
r11_msg db "r11: ",0
r12_msg db "r12: ",0
r13_msg db "r13: ",0
r14_msg db "r14: ",0
r15_msg db "r15: ",0
rip_msg db "rip: ",0
error_msg db "error code: ",0
cs_msg db "cs: ",0
ss_msg db "ss: ",0

