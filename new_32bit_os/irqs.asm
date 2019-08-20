reconfigure_pic:
	mov al, 0x11
	out 0x20, al		;a bunch of commands to the PIC chips (that handle irqs) to reconfigure irqs 0-7 to be where irqs 0-7 should be.
	out 0xA0, al		;they are normally where 8-15 are, and without re-configuration can cause unwanted exceptions to happen.
	mov al, 0x20
	out 0x21, al		;courtesy of http://osdever.com/bkerndev/
	mov al, 0x28
	out 0xA1, al
	mov al, 0x04
	out 0x21, al
	mov al, 0x02
	out 0xA1, al
	mov al, 0x01
	out 0x21, al
	out 0xA1, al
	mov al, 0x0
	out 0x21, al
	out 0xA1, al
	ret

irq0:					;irq handlers
	cli					;clear interrupts so they don't spawn in the middle of us
	push eax			;SAVE eax because we will pop from it later
	push 0				;push our interrupt #
	jmp master_irq_handler	;jump to master handler
irq1:
	cli
	push eax
	push 1
	jmp master_irq_handler
irq2:
	cli
	push eax
	push 2
	jmp master_irq_handler
irq3:
	cli
	push eax
	push 3
	jmp master_irq_handler
irq4:
	cli
	push eax
	push 4
	jmp master_irq_handler
irq5:
	cli
	push eax
	push 5
	jmp master_irq_handler
irq6:
	cli
	push eax
	push 6
	jmp master_irq_handler
irq7:
	cli
	push eax
	push 7
	jmp master_irq_handler
irq8:
	cli
	push eax
	push 8
	jmp master_irq_handler
irq9:
	cli
	push eax
	push 9
	jmp master_irq_handler
irq10:
	cli
	push eax
	push 0AH
	jmp master_irq_handler
irq11:
	cli
	push eax
	push 0BH
	jmp master_irq_handler
irq12:
	cli
	push eax
	push 0CH
	jmp master_irq_handler
irq13:
	cli
	push eax
	push 0DH
	jmp master_irq_handler
irq14:
	cli
	push eax
	push 0EH
	jmp master_irq_handler
irq15:
	cli
	push eax
	push 0FH
	jmp master_irq_handler
		
irq_array_of_handlers times 16 dd 0
	
set_irq_handler:	;esi == handler #, ebx == function address. To reset/null a handler, just set the function pointer to null.
	push esi
	push ebx
	shl esi, 2
	add esi, irq_array_of_handlers
	mov [esi], dword ebx
	pop ebx
	pop esi
	ret
	
master_irq_handler:
	pop eax				;pop our code
	pusha				;stands for push all (registers)
	push ds
	push es				;saving state......
	push fs
	push gs				;push segments (descriptors) to stack

	mov edx, eax		;save the code in edx for comparing later
	
	mov esi, eax		
	shl esi, 2			;see the idt entry loader for a explanation on this behaviour
	add esi, irq_array_of_handlers
	mov eax, dword [esi]	;we get the address of the function that handles our irq
	
	cmp eax, 0			;if handler is undefined (not set)
	je .end			;end

	call eax			;otherwise call the function
				
	cmp edx, 8			;if exception is less than 8 jump to end
	jl .end
	
	mov al, 20H			;otherwise output this special opcode (to the pic (master?))
	out 0A0H, al
	.end:
		mov al, 20H		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
		out 20H, al
		pop gs				;we pop all values back
		pop fs
		pop es
		pop ds
		popa
		pop eax				;again, code
		sti					;enable interrupts again
		iret
		
load_irqs:
	call reconfigure_pic

	mov edi, 20H
	mov ax, 08H
	mov bl, 8EH
	
	mov esi, irq0
	call load_idt_entry
	inc edi
	mov esi, irq1
	call load_idt_entry
	inc edi
	mov esi, irq2
	call load_idt_entry
	inc edi
	mov esi, irq3
	call load_idt_entry
	inc edi
	mov esi, irq4
	call load_idt_entry
	inc edi
	mov esi, irq5
	call load_idt_entry
	inc edi
	mov esi, irq6
	call load_idt_entry
	inc edi
	mov esi, irq7
	call load_idt_entry
	inc edi
	mov esi, irq8
	call load_idt_entry
	inc edi
	mov esi, irq9
	call load_idt_entry
	inc edi
	mov esi, irq10
	call load_idt_entry
	inc edi
	mov esi, irq11
	call load_idt_entry
	inc edi
	mov esi, irq12
	call load_idt_entry
	inc edi
	mov esi, irq13
	call load_idt_entry
	inc edi
	mov esi, irq14
	call load_idt_entry
	inc edi
	mov esi, irq15
	call load_idt_entry
	
	ret