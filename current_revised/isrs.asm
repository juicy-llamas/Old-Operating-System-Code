load_isrs:					;loads the exception handlers
	xor edi, edi			;we point to the first entry since isrs are the first 32 entries (0-31)
	mov ax, 08H				;our code segment is 08H
	mov bl, 8EH				;flags
	
	mov esi, isr0			;esi holds the address of the handler
	call load_idt_entry		;
	inc edi
	mov esi, isr1
	call load_idt_entry
	inc edi
	mov esi, isr2
	call load_idt_entry
	inc edi
	mov esi, isr3
	call load_idt_entry
	inc edi
	mov esi, isr4
	call load_idt_entry
	inc edi
	mov esi, isr5
	call load_idt_entry
	inc edi
	mov esi, isr6
	call load_idt_entry
	inc edi
	mov esi, isr7
	call load_idt_entry
	inc edi
	mov esi, isr8
	call load_idt_entry
	inc edi
	mov esi, isr9
	call load_idt_entry
	inc edi
	mov esi, isr10
	call load_idt_entry
	inc edi
	mov esi, isr11
	call load_idt_entry
	inc edi
	mov esi, isr12
	call load_idt_entry
	inc edi
	mov esi, isr13
	call load_idt_entry
	inc edi
	mov esi, isr14
	call load_idt_entry
	inc edi
	mov esi, isr15
	call load_idt_entry
	inc edi
	mov esi, isr16
	call load_idt_entry
	inc edi
	mov esi, isr17
	call load_idt_entry
	inc edi
	mov esi, isr18
	call load_idt_entry
	inc edi
	mov esi, isr19
	call load_idt_entry
	inc edi
	mov esi, isr20
	call load_idt_entry
	inc edi
	mov esi, isr21
	call load_idt_entry
	inc edi
	mov esi, isr22
	call load_idt_entry
	inc edi
	mov esi, isr23
	call load_idt_entry
	inc edi
	mov esi, isr24
	call load_idt_entry
	inc edi
	mov esi, isr25
	call load_idt_entry
	inc edi
	mov esi, isr26
	call load_idt_entry
	inc edi
	mov esi, isr27
	call load_idt_entry
	inc edi
	mov esi, isr28
	call load_idt_entry
	inc edi
	mov esi, isr29
	call load_idt_entry
	inc edi
	mov esi, isr30
	call load_idt_entry
	inc edi
	mov esi, isr31
	call load_idt_entry
	inc edi
	
	ret
	
;exception numbers in a C array:
;(0->31)
;
;when an exception occurs, look it up in the table
;
;unsigned char *exception_message[] =
;{
;	"Division by Zero",						0
;	"Debug",								1
;	"Non-Maskable Interrrupt",				2
;	"Breakpoint",							3
;	"Into Detected Overflow",				4	
;	"Out of Bounds",						5
;	"Invalid Opcode",						6
;	"No Coprocessor",						7
;	"Double Fault",							8
;	"Coprocessor Segment Overrun",			9	
;	"Bad TSS",								a
;	"Segment Not Present",					b	
;	"Stack Fault",							c	
;	"General Protection Fault",				d
;	"Page Fault",							e	
;	"Unknown Interrupt",					f
;	"Coprocessor Fault",					10	
;	"Alignment Check",						11
;	"Machine Check",						12
;	"Reserved",								etc...
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;	"Reserved",
;};	

isr_1 db 'An exception occured. Processor halt.',0
isr_eax db 'eax: ',0
isr_ebx db 'ebx: ',0
isr_ecx db 'ecx: ',0
isr_edx db 'edx: ',0
isr_esi db 'esi: ',0
isr_edi db 'edi: ',0
isr_ebp db 'ebp: ',0
isr_esp db 'esp: ',0
isr_cs db 'cs: ',0
isr_ds db 'ds: ',0
isr_es db 'es: ',0
isr_fs db 'fs: ',0
isr_gs db 'gs: ',0
isr_eip db 'eip: ',0
isr_eflags db 'eflags: ',0
isr_useresp db 'user esp: ',0
isr_ss db 'ss: ',0
isr_2 db 'Exception Number: ',0
isr_4 db 'Error Code: ',0
isr_3 db 'Sorry :(',0

;these guys' jobs are to push a number onto the stack to tell us what exception occured (0-31)

isr0:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 0
	jmp isr_handler
isr1:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 1
	jmp isr_handler
isr2:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 2
	jmp isr_handler
isr3:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 3
	jmp isr_handler
isr4:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 4
	jmp isr_handler
isr5:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 5
	jmp isr_handler
isr6:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 6
	jmp isr_handler
isr7:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 7
	jmp isr_handler
isr8:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 8
	jmp isr_handler
isr9:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 9
	jmp isr_handler
isr10:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0AH
	jmp isr_handler
isr11:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0BH
	jmp isr_handler
isr12:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0CH
	jmp isr_handler
isr13:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0DH
	jmp isr_handler
isr14:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0EH
	jmp isr_handler
isr15:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 0FH
	jmp isr_handler
isr16:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 10H
	jmp isr_handler
isr17:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 11H
	jmp isr_handler
isr18:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 12H
	jmp isr_handler
isr19:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 13H
	jmp isr_handler
isr20:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 14H
	jmp isr_handler
isr21:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 15H
	jmp isr_handler
isr22:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 16H
	jmp isr_handler
isr23:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 17H
	jmp isr_handler
isr24:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 18H
	jmp isr_handler
isr25:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 19H
	jmp isr_handler
isr26:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 1AH
	jmp isr_handler
isr27:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 1BH
	jmp isr_handler
isr28:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 1CH
	jmp isr_handler
isr29:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 1DH
	jmp isr_handler
isr30:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 1EH
	jmp isr_handler
isr31:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	mov [register_struct.eax], dword eax
	push 0
	push 1FH
	jmp isr_handler
	
num_buf times 9 db 0

num1 dd 0
num2 dd 0

register_struct:
	.eax dd 0
	.ebx dd 0
	.ecx dd 0
	.edx dd 0
	.esi dd 0
	.edi dd 0
	.ebp dd 0
	.esp dd 0

segments:
	.ds: dw 0
	.es: dw 0
	.fs: dw 0
	.gs: dw 0

isr_handler:
	mov [register_struct.ebx], ebx
	mov [register_struct.ecx], ecx
	mov [register_struct.edx], edx
	mov [register_struct.esi], esi
	mov [register_struct.edi], edi
	mov [register_struct.ebp], ebp
	mov [register_struct.esp], esp
	
	mov ax, ds
	mov [segments.ds], word ax
	mov ax, es
	mov [segments.es], word ax
	mov ax, fs
	mov [segments.fs], word ax
	mov ax, gs
	mov [segments.gs], word ax

	pop eax
	mov [num1], dword eax
	pop eax
	mov [num2], dword eax
	
	mov [curcolor], byte 01001100B		;give us a red color
	call clear_screen				;reset our screen
	mov si, isr_1
	call print_str		;tell us that an exception occured
	call new_line
	
	mov si, isr_2
	call print_str
	mov eax, dword [num1]
	mov edi, num_buf		;spit out every single register value.
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_4
	call print_str
	mov eax, dword [num2]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_eax
	call print_str
	mov eax, dword [register_struct.eax]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_ebx
	call print_str
	mov eax, dword [register_struct.ebx]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_ecx
	call print_str
	mov eax, dword [register_struct.ecx]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_edx
	call print_str
	mov eax, dword [register_struct.edx]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_esi
	call print_str
	mov eax, dword [register_struct.esi]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_edi
	call print_str
	mov eax, dword [register_struct.edi]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_ebp
	call print_str
	mov eax, dword [register_struct.ebp]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_esp
	call print_str
	mov eax, dword [register_struct.esp]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	xor eax, eax
	
	mov si, isr_ds
	call print_str
	mov ax, word [segments.ds]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	xor eax, eax
	
	mov si, isr_es
	call print_str
	mov ax, word [segments.es]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	xor eax, eax
	
	mov si, isr_fs
	call print_str
	mov ax, word [segments.fs]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	xor eax, eax
	
	mov si, isr_gs
	call print_str
	mov ax, word [segments.gs]
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_eip
	call print_str
	pop eax
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_cs
	call print_str
	pop eax
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_eflags
	call print_str
	pop eax
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_useresp
	call print_str
	pop eax
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_ss
	call print_str
	pop eax
	mov edi, num_buf
	call num_to_hex_small
	mov esi, num_buf
	xor eax, eax
	call print_str
	call new_line
	
	mov si, isr_3		;give us an apology for halting
	call print_str		
	call new_line
	
	hlt					;for now we halt
	
	;TODO: notify the task manager that an exception was reached.
	;and restore registers
	
	sti					;enable interrupts again
	iret				;iret -> interrupt return. this normalizes the stack (and i guess does other things) becuase a lot of values are pushed when you do an interrupt.
