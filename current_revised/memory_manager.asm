memory_list_in_kern dd 0x400	;list of all blocked addresses
memory_list_out_kern dd 0x500
active dd 0
bound dd 0

mem_init:
	mov [memory_list_in_kern], dword 0x0
	mov [memory_list_in_kern+4], dword 0x2000
	mov [memory_list_in_kern+8], dword 0x7e00
	mov [memory_list_in_kern+12], dword end_of_kernel
	add [memory_list_in_kern], dword 0x10
	
block_mem_kern: ;eax:ebx == starting addr:ending addr
	lea esi, [memory_list_in_kern/2-200]
	.loop:
		mov esi, ecx
		shl ecx, 1
		cmp e

free_mem_kern:
	
	
allocate_mem_kern: ;eax == size
	
