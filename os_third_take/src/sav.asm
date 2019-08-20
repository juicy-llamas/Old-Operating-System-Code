
old_rsp dq 0
err_code dq 0
old_exception_handler:
	mov [old_rsp], qword rsp	;store the old stack pointer and move the new stack pointer to a random location to store registers (this location will probably change)
	mov rsp, 0x30000
	push rax					;push the registers that will be used
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push rbp

	mov rsp, qword [old_rsp]	;restore stack
	
	call clear_screen
	mov rsi, exception_msg
	call print_str
	
	pop rsi
	mov [old_rsp], qword rsp
	shl rsi, 2
	add rsi, exception_0
	mov rcx, 4
	call print_length

	call new_line
	mov rsi, error_msg
	call print_str
	
	mov rax, qword [err_code]
	call print_rax

	call new_line
	mov rsi, rip_msg
	call print_str
	
	pop rax
	call print_rax
	
	call new_line
	mov rsi, cs_msg
	call print_str
	
	pop rax
	call print_rax
	
	call new_line
	mov rsi, rflags_msg
	call print_str
	
	pop rax
	call print_rax

	call new_line
	mov rsi, rsp_msg
	call print_str
	
	pop rax
	call print_rax

	call new_line
	mov rsi, ss_msg
	call print_str
	
	pop rax
	call print_rax

	call new_line
	mov rsi, rax_msg
	call print_str
	
	mov rax, qword [0x30000-8*1]
	call print_rax

	call new_line
	mov rsi, rbx_msg
	call print_str
	
	mov rax, qword [0x30000-8*2]
	call print_rax
	
	call new_line
	mov rsi, rcx_msg
	call print_str
	
	mov rax, qword [0x30000-8*3]
	call print_rax

	call new_line
	mov rsi, rdx_msg
	call print_str
	
	mov rax, qword [0x30000-8*4]
	call print_rax

	call new_line
	mov rsi, rsi_msg
	call print_str
	
	mov rax, qword [0x30000-8*5]
	call print_rax

	call new_line
	mov rsi, rdi_msg
	call print_str
	
	mov rax, qword [0x30000-8*6]
	call print_rax

	call new_line
	mov rsi, rbp_msg
	call print_str
	
	mov rax, qword [0x30000-8*7]
	call print_rax
	
	mov rsp, 0x30000
	pop rbp
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	mov qword [err_code], 0
	mov rsp, qword [old_rsp]

