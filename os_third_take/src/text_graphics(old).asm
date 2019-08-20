cur_mem dq 000B8000H
curcolor db 00101010B	;bytes in order: blinking, background r, background g, background b, intensity (brightness), letter r, letter g, letter b

print_str:				;esi == string, ah == an alternate termination character (but null always terminates no matter what).
	mov edi, dword [cur_mem]	;move our current position
	mov bl, byte [curcolor]	;and our current color								so we go back 16 spaces (bytes) on the stack (the stack grows in a downwards direction, so we SUBTRACT 16 and ADD 12, and pop ADDS 4 to the pointer)
	mov ah, al					;we got a six
	.loop:
		cmp edi, 0B8FA0H		;TRASHED: edi, eax, ebx
		jge .scroll
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
		call shift_cursor
		ret
	.scroll:
		call scroll_screen
		jmp .loop
		
print_length:			;esi == stuff, cx == length (chars) to print for
	mov edi, dword [cur_mem]	;virtually identical to print_str
	mov bl, byte [curcolor]		;TRASHED: edi, al, bl, cx
	.loop:
		cmp edi, 0B8FA0H
		jge .scroll
		mov al, byte [esi]
		mov [edi], byte al
		mov [edi+1], byte bl
		inc esi
		add edi, 2
		dec cx
		jnz .loop
	.end:
		call shift_cursor
		ret
	.scroll:
		call scroll_screen
		jmp .loop
		
scroll_screen:
	push rax
	mov edi, 0B8000H
	mov ebx, 50H
	.loop:
		cmp edi, 0B8F00H				;trashed: ebx (edi is set to the current printing location)
		je .clear_bottom
		mov ax, word [edi+0A0H]
		mov [edi], word ax
		add edi, 2
		jmp .loop
	.clear_bottom:
		mov al, [curcolor]
	.loop2:
		cmp edi, 0B8FA0H
		je .end
		mov [edi], byte ' '
		mov [edi+1], byte al
		add edi, 2
		jmp .loop2
	.end:
		mov edi, 0B8F00H
		pop rax
		mov [cur_mem], dword edi
		ret
		
scroll_by_amount:	;amount (of lines) to scroll in al
	mov edi, 0B8000H				;trashed: ebx
	mov ebx, 50H
	.loop:
		cmp edi, 0B8F00H
		je .clear_bottom
		mov ax, word [edi+0A0H]
		mov [edi], word ax
		add edi, 2
		jmp .loop
	.clear_bottom:
		mov al, [curcolor]
	.loop2:
		cmp edi, 0B8FA0H
		je .end
		mov [edi], byte ' '
		mov [edi+1], byte al
		add edi, 2
		jmp .loop2
	.end:
		mov edi, 0B8F00H
		mov [cur_mem], dword edi
		ret
	
clear_screen:					;trashed: edi and al
	mov edi, 0B8000H			;clear all visible screen: from the beginning
	mov al, [curcolor]			;move our color
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
	
new_line:						;trashed: eax, cx, dx
	xor dx, dx
	mov eax, dword [cur_mem]
	sub eax, 0B8000H
	mov cx, 160
	div cx
	mov cx, 160
	sub cx, dx
	mov ax, cx
	add eax, dword [cur_mem]
	mov [cur_mem], dword eax
	call shift_cursor
	cmp eax, 0B8FA0H
	je .scroll
	.end:
		call shift_cursor
		ret
	.scroll:
		call scroll_screen
		jmp .end
		
;_type:		;char in al
;	mov ah, byte [curcolor]
;	mov edi, dword [cur_mem]
;	mov ebx, dword [cur_buf_addr]
;	cmp edi, 0B8FA0H
;	je .scroll
;	.back:
;		mov [edi], byte al
;		mov [edi+1], byte ah
;		add edi, 2
;		mov [ebx], byte al
;		inc ebx
;		mov [cur_mem], dword edi
;		mov [cur_buf_addr], dword ebx
;		call shift_cursor
;		ret
;	.scroll:
;		call scroll_screen
;		jmp .back

print_char:		;char in al
	mov ah, byte [curcolor]		;trashed: edi
	mov edi, dword [cur_mem]
	cmp edi, 0B8FA0H
	je .scroll
	.back:
		mov [edi], byte al
		mov [edi+1], byte ah
		add edi, 2
		mov [cur_mem], dword edi
		call shift_cursor
		ret
	.scroll:
		call scroll_screen
		jmp .back
	
shift_cursor:		;trashes ax and ebx
	mov ebx, dword [cur_mem]		;get position of text
	sub ebx, 0B8000H
	shr ebx, 1						;very quick way of dividing by 2 (ebx is already divisible by 2, so this works. for other cases, test if it is divisible by doing 'and (something), 1'. this will return the modulus of something.)
	mov al, 0FH				;in/out voo doo with the VGA hardware
	mov dx, 3D4H
	out dx, al			;curtosy of http://wiki.osdev.org/Text_Mode_Cursor
	mov dx, 3D5H		;adapted to assembly by MYSELF
	mov al, bl
	out dx, al
	mov al, 0EH
	mov dx, 3D4H
	out dx, al
	mov al, bh
	mov dx, 3D5H
	out dx, al
	ret
	
;if you have a sequence like '000000FA0H', then you don't want to print the 1st zeroes. this is what this function does: it skips a char of your choice and prints after it.
skip_print:		;esi == string, ah == char to skip_print
	mov edi, dword [cur_mem]	;move our current position		trash: edi, ax, bx
	mov bl, byte [curcolor]	;and our current color								so we go back 16 spaces (bytes) on the stack (the stack grows in a downwards direction, so we SUBTRACT 16 and ADD 12, and pop ADDS 4 to the pointer)
	mov al, ah					;we got a six
	.loop:
		cmp edi, 0B8FA0H
		jge .scroll
		mov al, byte [esi]
		cmp al, 0
		je .end	
		cmp al, ah
		je .skip
		mov [edi], byte al
		mov [edi+1], byte bl
		add edi, 2
	.skip:
		inc esi
		jmp .loop
	.end:
		mov [cur_mem], dword edi
		call shift_cursor
		ret
	.scroll:
		call scroll_screen
		jmp .loop

;THESE ARE NEW FUNCTIONS

print_rax:			;prints rax in hex. simple.
	mov rdi, qword [cur_mem]	;rdi, bl, cl, and rax trashed
	add rdi, 30
	mov bl, byte [curcolor]
	mov cl, 17
	.loop:
		dec cl
		jz .end
		cmp rdi, 0xB8FA0
		jge .scroll
	.back:
		push rax
		and al, 0x0F
		cmp al, 0x0A
		jl .low
	.high:
		add al, 55
		jmp .print
	.low:
		add al, 48
	.print:
		mov [rdi], byte al
		mov [rdi+1], byte bl
		sub rdi, 2
		pop rax
		ror rax, 4
		jmp .loop
	.scroll:
		call scroll_screen
		jmp .back
	.end:
		add rdi, 34
		mov [cur_mem], qword rdi
		call shift_cursor
		ret	

print_itoa:				;trash: rdi, bx 
	mov rdi, qword [cur_mem]
	mov bl, byte [curcolor]
	.loop:
		
	








