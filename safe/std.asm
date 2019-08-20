strcmp:		;esi == string1, edi == string2, ah == termination character. strings can have different terminations to be considered equal. note: the only other termination (other than al) is a null, so if a char is null, then it will terminate with a result of yes or no, depending on strings.
	push ax			;the carry flag is set on equal				^> AND cl == use strict (if cl >= 0001, then it uses strict)
	.compare:
		mov al, byte [esi]	;take byte from esi and compare with edi.
		cmp al, byte [edi]
		jne .use_strict				;if they are not equal, then do no routine
		cmp al, 0			;if they are zero or our selected termination character, then 
		je .yes
		cmp al, ah
		je .yes
		inc esi
		inc edi
		jmp .compare
	.maybe2:
		cmp al, ah
		jne .no
		cmp [edi], byte 0
		je .yes
	.no:
		pop ax
		clc
		ret
	.use_strict:
		cmp cl, 1
		jae .no
	.maybe:
		cmp al, 0
		jne .maybe2				;'maybe's are for comparing ending chars; ex. if one ending has a space and the other has a zero, but they are the same otherwise
		cmp [edi], byte ah
		jne .no
	.yes:
		pop ax
		stc
		ret
		
strcmp_len:		;esi == string1, edi == string2, and cx == length. carry flag is set as in regular strcmp.
	push ax
	.loop:
		mov al, byte [esi]
		cmp al, byte [edi]		;compare two bytes (except we check if not equal)
		jne .no
		inc esi					;if they are equal, the we increment and loop
		inc edi
		dec cx
		jnz .loop
	.yes:
		pop ax					;if loop stops, it moves to next code block
		stc
		ret
	.no:
		pop ax
		clc
		ret

timer_tick_temp dq 0		
		
wait_for_ticks:			;ecx:ebx == up4bits:low4bits ticks. i would say this has +/- 10 ticks accuracy, assuming 'rdtsc' is perfect
	cli 			;we disable keyboard and all other possible interrupts
	push eax
	push edx
	rdtsc				;terrible, i know. eventually i will upgrade to a much more accurate timer and set that up. rdtsc reads the time-stamp counter (current ticks) into edx:eax
	mov [timer_tick_temp], dword eax
	mov [timer_tick_temp+4], dword edx		;little endian -> 
	add [timer_tick_temp], dword ebx
	add [timer_tick_temp+4], dword ecx
	.loop:
		rdtsc
		cmp edx, dword [timer_tick_temp+4]
		jb .loop
		ja .fin
		cmp eax, dword [timer_tick_temp]
		jae .fin
		jmp .loop
	.fin:
		pop edx
		pop eax
		sti
		ret

counter db 0
		
hex_to_num:			;esi == string, edi == out buffer, ah == optional termination char, ecx == size of the out buffer. hex must be IN CAPITAL LETTERS: like 'FF' 
	push ebx
	mov ebx, edi
	dec ecx
	add ebx, ecx
	xor cl, cl
	.loop:
		mov al, byte [esi]
		cmp al, 0
		je .done				;if terminated, then we're done
		cmp al, ah
		je .done
		cmp ebx, edi
		jb .buf_exceeded
		cmp al, '0'
		jb .invalid_sequence	;if ascii is below 0, then its invalid.
		cmp al, '9'
		jbe .zero_nine			;if 0-9, then call that
		cmp al, 'A'
		jb .invalid_sequence	;if lower than A (it was highter than 0-9 before), then invalid.
		cmp al, 'F'
		jbe .A_F				;if A-F, then goto A-F
		jmp .invalid_sequence	;othewise, give error by clearing the carry flag (so after this function, there should be a 'jc' or 'jnc' similar to strcmp).
	.zero_nine:
		sub al, 30H				;subtract the ascii offset to get num
		jmp .convert
	.A_F:
		sub al, 37H				;same here
	.convert:
		shl cl, 4				;shift previous nibble up
		or cl, al				;move nibble in al into ecx without overwriting other nibbles
		mov [ebx], byte cl
	.compare:
		cmp [counter], byte 1
		je .reset
		inc byte [counter]
		inc esi
		jmp .loop
	.reset:
		dec ebx
		dec byte [counter]
		inc esi
		jmp .loop
	.done:
		mov [counter], byte 0
		pop ebx
		stc
		ret
	.invalid_sequence:
		mov [counter], byte 0
		pop ebx
		xor al, al
		clc
		ret
	.buf_exceeded:
		mov [counter], byte 0
		pop ebx
		mov al, 1
		clc
		ret

hex_to_num_small:	;ecx == string, ah == optional termination. small means <= 4 bytes.
	xor ecx, ecx		;clear counter                             small is much faster than regular hex to num, and it is less complex as it just stores result in ecx.
	push ebx
	.loop:
		mov al, byte [esi]
		cmp al, 0
		je .done				;if terminated, then we're done
		cmp al, ah
		je .done
		cmp al, '0'
		jb .invalid_sequence	;if ascii is below 0, then its invalid.
		cmp al, '9'
		jbe .zero_nine			;if 0-9, then call that
		cmp al, 'A'
		jb .invalid_sequence	;if lower than A (it was highter than 0-9 before), then invalid.
		cmp al, 'F'
		jbe .A_F				;if A-F, then goto A-F
		jmp .invalid_sequence	;othewise, give error by clearing the carry flag (so after this function, there should be a 'jc' or 'jnc' similar to strcmp).
	.zero_nine:
		sub al, 30H				;subtract the ascii offset to get num
		jmp .convert
	.A_F:
		sub al, 37H				;same here
	.convert:					;ecx == return value
		shl ecx, 4				;shift previous nibble up
		movzx ebx, al			;movzx -> move and pad with zeros, so al == 00 00 00 al
		or ecx, ebx				;move nibble in al into ecx without overwriting other nibbles
		inc esi
		jmp .loop
	.invalid_sequence:
		pop ebx
		clc			;carry set on SUCCESS
		ret
	.done:
		pop ebx
		stc
		ret
		
num_to_hex_small:	;eax == number, edi == return buffer <- function assumes the buffer is cleared. number <= 4 bytes (it has to fit in ecx).
	push ebx		
	push edx
	mov ebx, 0F0000000H
	mov edx, eax
	mov cl, 28
	.grab:
		and eax, ebx
		shr eax, cl
		cmp eax, 9
		jle .zero_nine
	.A_F:
		add eax, 37H
		jmp .put_in_buf
	.zero_nine:
		add eax, 30H
	.put_in_buf:
		mov [edi], byte al
		inc edi
		shr ebx, 4
		jz .end
		sub cl, 4
		mov eax, edx
		jmp .grab
	.end:
		pop edx
		pop ebx
		ret
		
		
num_to_hex:	;esi == number, edi == return buffer. number <= 4 bytes (it has to fit in ecx).
	push ebx		;cf is set on error -> cx is error code; 0 == overflow of ecx
	push edx
	mov ebx, 0000000FH
	mov eax, dword [esi]
	mov edx, eax
	xor cx, cx
	.grab:
		and eax, ebx
		shr eax, cl
		cmp eax, 9
		jle .zero_nine
	.A_F:
		add eax, 30H
		jmp .put_in_buf
	.zero_nine:
		add eax, 37H
	.put_in_buf:
		mov [edi], byte al
		inc edi
		shl ebx, 4
		add cl, 4
		;jo .overflow
		mov eax, edx
		jmp .grab
	.end:
		pop edx
		pop ebx
		ret
	.overflow:
		pop edx
		pop ebx
		xor cx, cx
		ret
		
strlen:		;esi == string, ah == optional termination. string must be less than 2^32 chars (which is perfectly reasonable, i would think)
	xor ecx, ecx
	.loop:
		cmp [esi], byte 0
		je .done
		cmp [esi], byte ah
		je .done
		inc ecx			;ecx == string length
		inc esi
		jmp .loop
	.done:
		ret
		
mem_clear:	;edi == buffer, ecx == length
	.loop:
		test ecx, 3
		jnz .ones
		mov [edi], dword 0
		add edi, 4
		sub ecx, 4
		jz .done
		jmp .loop
	.ones:
		mov [edi], byte 0
		inc edi
		dec ecx
		jz .done
		jmp .ones
	.done:
		ret
