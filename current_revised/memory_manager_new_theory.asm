que_low_end_kern dd 0x400
que_high_end_kern dd 0x480

init:

;memalloc functions in general return a pointer in ebx: this is the base pointer of the memory.
;at the base pointer of the memory is a memory map that contains the limit address and subsequent bases and limits of subsequent blocks of memory.
;here is an example of one block:
	;dword 0x34 -> this is the limit(max) address for this block before running into another application's space.
	;dword 0x78 -> this is the base address for the next block
;blocks are placed one after the other, so the base of a subsequent block is right after the limit of the previous block.
	

mem_allocate_kern:	;eax == amount; trashes ecx, esi, and edi; carry flag set if mem goes over 0x10000. Allocates mem to kernel processes only.
	mov ebx, dword [que_low_end_kern]
	mov edi, dword [que_high_end_kern]
	mov ecx, dword [edi]
	mov [ebx], dword ecx
		
		
		
	
