;the entry point of the kernel
;i also do a lot of the initial setting up here, such as loading the idt and entering long mode and paging and such...

BITS 32

;grub header (when i switch to my own bootloader this will change. so will the size of my iso :D)

align 4
magic dd 0x1BADB002							;magic: grub looks for this number to identify such a header
flags dd 0x00010003								;flags: bit 0 is for 4KiB aligning (page aligning), bit 1 is to detect our memory map, bit 2 is to set a graphical mode, 
													;and bit 16 is to load the kernel at the given offsets below.
checksum dd -(0x1BADB002 + 0x00010003)			;another magical number (when added with flags and magic, it will be 0 (twos complement subtraction)).

header_addr dd magic							;base addr of this header
load_addr dd _START								;base addr of our kernel
load_end_addr dd _END							;end addr of our kernel
bss_end_addr dd 0xA000							;END of the stack (where the stack grows from?).
entry_addr dd _START							;where our code is

_START:
	;first thing we will do is copy the grub table we get to go after our os.

	;next thing we do is jump to long mode and set up an extremely bare paging environment.
	;this code assumes you have an x86_64 processor in your computer (if you don't have a 64 bit processor by now then I really don't know what to say :/)

	mov eax, cr0						;paging should not be enabled, but we just make sure of that.
	and eax, 0x7FFFFFFF
	mov cr0, eax

	call setup_paging					;set up page tables in mem
	
	mov ecx, 0xC0000080					;this sets long mode (which is basically 4 layer paging)
	rdmsr
	or eax, 0x100
	wrmsr

	mov eax, cr0						;enable paging
	or eax, 0x80000000
	mov cr0, eax

	lgdt [gdt_ptr]	
	
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp 0x08:main

;copied from osdev with minor stylistic modifications (i am a horrible person i know). the gdt doesn't really matter anyway since we will use paging, not segment descriptors.
GDT64:                           ; Global Descriptor Table (64-bit).
    .null:				         ; The null descriptor.
    	dw 0xFFFF                    ; Limit (low).
    	dw 0                         ; Base (low).
    	db 0                         ; Base (middle)
    	db 0                         ; Access.
    	db 1                         ; Granularity.
    	db 0                         ; Base (high).
    .code:				         ; The code descriptor.
    	dw 0                         ; Limit (low).
    	dw 0                         ; Base (low).
    	db 0                         ; Base (middle)
    	db 10011010b                 ; Access (exec/read).
    	db 10101111b                 ; Granularity, 64 bits flag, limit19:16.
    	db 0                         ; Base (high).
    .data:				         ; The data descriptor.
   		dw 0                         ; Limit (low).
    	dw 0                         ; Base (low).
    	db 0                         ; Base (middle)
    	db 10010010b                 ; Access (read/write).
    	db 00000000b                 ; Granularity.
    	db 0                         ; Base (high).
    gdt_ptr:	                 ; The GDT-pointer.
    	dw $ - GDT64 - 1  			 ; Limit.
    	dq GDT64			         ; Base.

basic_setup_paging:							;sets up BASIC paging tables (don't delete this; fallback)

	xor edi, edi
	mov cr3, edi
	mov [edi], dword 0x1003 
	add edi, 0x1000
	mov [edi], dword 0x2003
	add edi, 0x1000
	mov [edi], dword 0x3003
	add edi, 0x1000
	
	mov ebx, 3
	mov ecx, 512
	.loop:
		mov [edi], dword ebx
		add edi, 8
		add ebx, 0x1000
		dec ecx
		jnz .loop
	ret

full_identity_paging:
	
	xor eax, eax		;this is going to be the current memory address
	
	;TODO

_print_str:				;esi == string, ah == an alternate termination character (but null always terminates no matter what).
	mov edi, dword [cur_mem]	;move our current position
	mov bl, 01111000B
	mov ah, al					;we got a six
	.loop:
		mov al, byte [esi]
		cmp al, 0
		je .end	
		cmp al, ah
		je .end	
		mov [edi], byte al
		mov [edi+1], byte bl
		inc esi
		add edi, 2
		jmp .loop
	.end:
		mov [cur_mem], dword edi
		ret

_clear_screen:					;trashed: edi and al
	mov edi, 0B8000H			;clear all visible screen: from the beginning
	mov al, 01111000B
	.loop:
		cmp edi, 0B8FA0H		;the amount of bytes of memory in the screen: 80 columns of chars * 25 rows of chars * 2 bytes PER char = 4000 bytes.
								;THEN you have to add the 0B8000H (the starting value of edi). 4000 == 15*256+10*16 == 0FA0H and 0B8000H + 0FA0H == 0B8FA0H
		je .end					;if edi is 0B8FA0H then jump to end
		mov [edi], byte ' '		;move a blank space (because space)
		mov [edi+1], byte al	;move our color
		add edi, 2				;we add 2 to edi (2 bytes, you should get the jist of these things by now)
		jmp .loop				;we jump back to the loop
	.end:
		mov [cur_mem], dword 000B8000H	;reset all of our values to their initial places.
		ret	

grub_fail db "grub version not high enough",0
