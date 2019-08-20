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
;	"Division by Zero",
;	"Debug",
;	"Non-Maskable Interrrupt",
;	"Breakpoint",
;	"Into Detected Overflow",
;	"Out of Bounds",
;	"Invalid Opcode",
;	"No Coprocessor",
;	"Double Fault",
;	"Coprocessor Segment Overrun",
;	"Bad TSS",
;	"Segment Not Present",
;	"Stack Fault",
;	"General Protection Fault",
;	"Page Fault",
;	"Unknown Interrupt",
;	"Coprocessor Fault",
;	"Alignment Check",
;	"Machine Check",
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
;	"Reserved",
;};	

isr_1 db 'An exception occured. Processor halt.',0
isr_2 db 'Exception Number: ',0
isr_3 db 'Sorry :(',0

;these guys' jobs are to push a number onto the stack to tell us what exception occured (0-31)

isr0:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0
	jmp isr_handler
isr1:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1
	jmp isr_handler
isr2:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 2
	jmp isr_handler
isr3:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 3
	jmp isr_handler
isr4:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 4
	jmp isr_handler
isr5:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 5
	jmp isr_handler
isr6:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 6
	jmp isr_handler
isr7:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 7
	jmp isr_handler
isr8:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 8
	jmp isr_handler
isr9:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 9
	jmp isr_handler
isr10:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0AH
	jmp isr_handler
isr11:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0BH
	jmp isr_handler
isr12:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0CH
	jmp isr_handler
isr13:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0DH
	jmp isr_handler
isr14:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0EH
	jmp isr_handler
isr15:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 0FH
	jmp isr_handler
isr16:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 10H
	jmp isr_handler
isr17:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 11H
	jmp isr_handler
isr18:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 12H
	jmp isr_handler
isr19:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 13H
	jmp isr_handler
isr20:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 14H
	jmp isr_handler
isr21:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 15H
	jmp isr_handler
isr22:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 16H
	jmp isr_handler
isr23:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 17H
	jmp isr_handler
isr24:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 18H
	jmp isr_handler
isr25:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 19H
	jmp isr_handler
isr26:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1AH
	jmp isr_handler
isr27:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1BH
	jmp isr_handler
isr28:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1CH
	jmp isr_handler
isr29:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1DH
	jmp isr_handler
isr30:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1EH
	jmp isr_handler
isr31:
	cli					;so that irqs don't spawn in the middle of us (THIS HAS TO BE FIRST)
	push eax
	push 1FH
	jmp isr_handler
	
num_buf dq 0
	
isr_handler
	pop ax
	pusha				;stands for push all (registers)
	push ds
	push es				;saving state......
	push fs
	push gs				;push segments (descriptors) to stack
	
	mov [curcolor], byte 01001100B		;give us a red color
	call clear_screen				;reset our screen
	mov si, isr_1
	call print_str		;tell us that an exception occured
	call new_line
	mov si, isr_2
	call print_str		;tell us what exception occured
	
	;mov ecx, al
	;mov edi, num_buf
	;call num_to_hex
	;
	call new_line
	
	mov si, isr_3		;give us an apology for halting
	call print_str		
	call new_line
	
	pop gs				;for future, we pop all values back
	pop fs
	pop es				;TODO: NORMALIZE STACK BY PUSHING FALSE ERROR CODES
	pop ds
	popa
	pop eax				;eax because again we push our error code
	sti					;enable interrupts again
	iret				;iret -> interrupt return. this normalizes the stack (and i guess does other things) becuase a lot of values are pushed when you do an interrupt.
