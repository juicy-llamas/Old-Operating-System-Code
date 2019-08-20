;idt entry:
;8 bytes (4 words)
;	1st word == lower portion of the address to jump to when the interrupt is called
;	2nd word == the current code segment (should be 08H, but when we start creating new ones for user programs it will be different)
;	3rd word:
;		1st byte of 3rd word is null
;		2nd byte contains flags: (flags guide will go here)
;	4th word == upper portion of address to jump to (you will see this as the 'offset')
	
load_idt_entry:			;esi == base, edi == number of entry in idt, ax == code segment, bl == flags
	push edi			;save state of edi as not to screw up our load_isrs function
						
	shl edi, 3			;then, we multiply edi by 8 (because 8 bytes in an entry)
	add edi, idt		;and add the address of idt, so as to point to a specific entry in the idt
	
	mov [edi], word si		;  3rd byte  2nd byte  [1st byte  0th byte]  we are grabbing these
	add edi, 2				;we moved a word, so we add 2
	mov [edi], word 0008H		;then we move code segment
	add edi, 2				;add again
	mov [edi], byte 0		;null portion
	inc edi					;inc (we moved byte that time)
	mov [edi], byte bl		;flags
	inc edi					;inc again
	shr esi, 16				;shift esi down so as to grab upper word
	mov [edi], word si		;  0  0  [3rd byte  2nd byte] grabbing upper word
							;no more increments
	pop edi
	ret

idt_setup:
	call load_isrs
	call load_irqs
	
	lidt [idtptr]
	sti
	ret
	
idtptr:
	dw end_idt-idt-1			;4 bytes per entry * 256 entries (256 interrupts) - 1 (just cause)
	dd idt
	
idt times 2048 db 0				;the idt itself

end_idt
