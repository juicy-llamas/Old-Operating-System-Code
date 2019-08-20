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

;ENDINGS OF FUNCTIONS!
;to end function 8-15, you do:

	;mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	;out 0xA0, al
	;mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	;out 0x20, al
	;popa
	;sti
	;iret
	
;0-7:
	
	;mov al, 0x20
	;out 0x20, al
	;popa
	;sti
	;iret


irq0:					;irq handlers
	cli					;clear interrupts so they don't spawn in the middle of us
	push eax
	jmp timer_int_real
irq1:
	cli
	push eax
	jmp keyboard_stub
irq2:
	cli
	push eax
	mov al, 0x20
	out 0x20, al
	pop eax
	sti				;placeholder for unimplemented irqs
	iret
irq3:
	cli
	push eax
	mov al, 0x20
	out 0x20, al
	pop eax
	sti				;placeholder for unimplemented irqs
	iret
irq4:
	cli
	push eax
	mov al, 0x20
	out 0x20, al
	pop eax
	sti				;placeholder for unimplemented irqs
	iret
irq5:
	cli
	push eax
	mov al, 0x20
	out 0x20, al
	pop eax
	sti				;placeholder for unimplemented irqs
	iret
irq6:
	cli
	push eax
	mov al, 0x20
	out 0x20, al
	pop eax
	sti				;placeholder for unimplemented irqs
	iret
irq7:
	cli
	push eax
	mov al, 0x20
	out 0x20, al
	pop eax
	sti				;placeholder for unimplemented irqs
	iret
irq8:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq9:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq10:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq11:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq12:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq13:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq14:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
irq15:
	cli
	push eax
	mov al, 0x20			;otherwise output this special opcode (to the pic (master?))
	out 0xA0, al
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
	
disable_irq:			;irq bit in bx. irq bit = 2^irq #
	push ax
	test bx, 0xFF 
	jz .master
	.slave:
		shl bx, 8
		in ax, 0xA1
		or ax, bx
		out 0xA1, al
		pop ax
		ret
	.master:
		in ax, 0x21
		or ax, bx
		out 0x21, al
		pop ax
		ret
		
enable_irq:			;irq bit in bx
	push ax
	not bx
	test bx, 0xFF00 
	jz .master
	.slave:
		shl bx, 8
		in al, 0xA1
		and al, bl
		out 0xA1, al
		pop ax
		ret
	.master:
		in ax, 0x21
		and ax, bx
		out 0x21, al
		pop ax
		ret
		
load_irqs:
	call reconfigure_pic

	mov edi, 0x20
	mov ax, 0x8
	mov bl, 0x8E
	
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
