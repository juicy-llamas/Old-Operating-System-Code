;the 64 bit entry of the kernel.

%define kernel_size 4096*2
%include "_START.asm"

BITS 64

welcome_2 db "WE JUMPED TO LONG MODE!!!",0
welcome_3 db "returned from int",0
max_high_mem dd 0

mem_map dq 0xA000

main:			;we arrive at main after _START. main marks the official start point of the kernel.

	call clear_screen
	mov rsi, welcome_2
	call print_str

	call paging_complete_setup
	
	lidt [idt_ptr]
	
	mov rax, 0x0A
	mov rbx, 0x0B
	mov rcx, 0x0C
	mov rdx, 0x0D
	
	hlt

%include "text_graphics(old).asm"
%include "tables.asm"
%include "tasks.asm"

paging_complete_setup:
	;the REAL pages. also provides task pages.

	;make the page tables themselves at address 0x10000
	
	mov edi, 0x10000
	mov esi, [ebx+44]
	mov eax, 3
	;ecx is set to length of block
	.get_block:
	.check:
	.load:
		sub ecx, 0x1000		;4 kib pages
		jz .end ;.get_block		;signed (we round down to the nearest free 4kib block. are the other kibs really worth saving?)
		stosd				;if our block hasnt terminated
		add eax, 0x1000
		jmp .load
	.end:
		ret
	

times kernel_size-($-$$) db 0

_END
