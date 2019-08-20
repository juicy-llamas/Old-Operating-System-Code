;these arrays map the keyboard keymap opcodes with their resepective ascii codes. i figured these out all by myself by experimentation.

key_array_noshift:		;these are the ascii keys in correspondance with their opcodes. if a key is released, you subtract 80H (half of a byte) to get original value (80H is added to value of key)
	db 0	;no signal (?)
	db 0	;esc
	db '1'	;0-9
	db '2'
	db '3'						;4		(i include increments of 5 for easy counting, opcode is displayed)
	db '4'
	db '5'
	db '6'
	db '7'
	db '8'	;note: on the computer i have, 8 is actually equal to the eject disk drive button (on my keyboard, there is such a thing), except disk eject doesnt have a release opcode
	db '9'
	db '0'
	db '-'	;dash
	db '='	;equals
	db 0	;backspace			;14/E
	db 0	;tab
	db 'q'	;Q-P	
	db 'w'
	db 'e'
	db 'r'						;19/13
	db 't'
	db 'y'
	db 'u'
	db 'i'
	db 'o'						;24/18
	db 'p'
	db '['	;brackets
	db ']'
	db 0	;enter
	db 0	;control (both of them)		;29/1D
	db 'a'	;A-L
	db 's'
	db 'd'
	db 'f'
	db 'g'						;34/22
	db 'h'
	db 'j'
	db 'k'
	db 'l'
	db ';'	;semicolon			;39/27
	db "'"	;single quote
	db '`'	;backslash (this jumps a fair amount)
	db 0	;LEFT shift
	db '\'	;backslash (nasm ignores backslash codes, such as '/n'. if your ide does not account for this, just know its ok.)
	db 'z'	;z-m				;44/2C
	db 'x'						
	db 'c'
	db 'v'
	db 'b'
	db 'n'						;49/31
	db 'm'						
	db ','	;comma
	db '.'	;period
	db '/'	;slash
	db 0	;RIGHT shift		;54/36
	db 0	;print screen button	
	db 0	;BOTH alts			
	db ' '	;spacebar
	db 0	;caps lock
	db 0	;function keys 1-10		;59/3B
	db 0
	db 0
	db 0
	db 0
	db 0						;64/40
	db 0
	db 0
	db 0
	db 0
	
key_array_shift:		;because im lazy/it's better performance to just browse an array rather than create a tree of cases that you have to manage
	db 0	;no signal (?)
	db 0	;esc
	db '!'	;0-9
	db '@'
	db '#'						;4		(i include increments of 5 for easy counting, opcode is displayed)
	db '$'
	db '%'
	db '^'
	db '&'
	db '*'	;note: on the computer i have, 8 is actually equal to the eject disk drive button (on my keyboard, there is such a thing), except disk eject doesnt have a release opcode
	db '('
	db ')'
	db '_'	;dash
	db '+'	;equals
	db 0	;backspace  		;14/D
	db 0	;tab
	db 'Q'	;Q-P
	db 'W'
	db 'E'
	db 'R'						;19/13
	db 'T'
	db 'Y'
	db 'U'
	db 'I'
	db 'O'						;24/18
	db 'P'
	db '{'	;brackets
	db '}'
	db 0	;enter
	db 0	;control (both of them)		;29/1D
	db 'A'	;A-L
	db 'S'
	db 'D'
	db 'F'
	db 'G'						;34/22
	db 'H'
	db 'J'
	db 'K'
	db 'L'
	db ':'	;colon				;39/27
	db '"'	;double quote
	db '~'	;tilde/wavey thingy
	db 0	;LEFT shift
	db '|'	;pipe
	db 'Z'	;z-m				;44/2B
	db 'X'						
	db 'C'
	db 'V'
	db 'B'
	db 'N'						;49/31
	db 'M'						
	db '<'	;brackets
	db '>'	
	db '?'	;question mark
	db 0	;RIGHT shift		;54/36
	db 0	;print screen button	
	db 0	;BOTH alts			
	db ' '	;spacebar					for caps lock, we just use the no shift array and add 20H to the character (since they are lined up like that)
	db 0	;caps lock
	db 0	;function keys 1-10		;59/3B
	db 0
	db 0
	db 0
	db 0
	db 0						;64/40
	db 0
	db 0
	db 0
	db 0

caps_lock_stat db 0
alt_stat db 0
shift_stat db 0
control_stat db 0
numbers_stat db 0

clear_buffer:
	mov edi, buffer
	lea ecx, [buffer+1024]
	.loop:
		cmp edi, ecx
		je .end
		mov [edi], dword 0
		add edi, 4
		jmp .loop
	.end:
		ret

;keyboard microcontroller on the keyboard == port 60H
;the controller that controls the keyboard (encoder) is port 64H
;the opcodes and the basic functionality of these functions that send cmds to keyboard are curtosy of osdev.org and www.brokenthorn.com/Resources/OSDev19.html (the later of which offers a brilliant explanation of how the microcontrollers actually work).
	
keyboard_send_cmd: ;command in ah
	.wait_for_buffer_clear:
		in al, 64H
		test al, 2		;we make sure byte 2 of al is CLEARED (to make sure that the keyboard is not caught up in other commands.
		jnz .wait_for_buffer_clear		;fyi, test is basically a 'cmp' instruction except it ANDS the two values instead of subtracting them. the zero flag is set if the result of the 'ANDing' of the two is zero.
	.send_cmd:
		mov al, ah
		out 60H, al
		ret
		
keyboard_controller_send_cmd: ;command in ah
	.wait_for_buffer_clear:
		in al, 64H
		test al, 2		;we make sure byte 2 of al is CLEARED (to make sure that the keyboard is not caught up in other commands.
		jnz .wait_for_buffer_clear		;fyi, test is basically a 'cmp' instruction except it ANDS the two values instead of subtracting them. the zero flag is set if the result of the and is zero.
	.send_cmd:
		mov al, ah		;we transfer cmd byte to al because in and out instructions needs byte to be in al, not ah (just way its wired).
		out 64H, al
		ret

keyboard_read_out:
	.wait:
		in al, 64H
		test al, 1
		jz .wait
	.get_val:
		in al, 60H
		ret
		
keyboard_stub:			
	xor eax, eax
	in al, 60H	
	mov [space_for_key], byte al
	ret
	
keyboard_setup:
	mov ah, 0F3H				;basically shifts the typematic rate to the highest speed.
	call keyboard_send_cmd
	mov ah, 20H
	call keyboard_send_cmd
	
	ret
	
main_keyboard_handler:

	xor eax, eax
	mov al, byte [space_for_key]
	
	cmp al, 1		;just setting up handling for special chars
	je .esc
	cmp al, 14
	je .backspace
	cmp al, 15
	je .tab
	cmp al, 29
	je .control
	cmp al, 28
	je .enter
	cmp al, 42
	je .shift
	cmp al, 54
	je .shift
	cmp al, 55
	je .print_screen
	cmp al, 56
	je .alt
	cmp al, 58
	je .caps_lock
	
	cmp al, 80H		;if a key is released, check if it is a special key
	jae .cmp80
	cmp [cur_buf_addr], dword end_buffer	;if the buffer length is exceeded don't do anything (except permit the actions above)
	je .end
	cmp [control_stat], byte 1
	je .control_handle
	cmp [shift_stat], byte 1
	je .print_in_shift
	cmp [caps_lock_stat], byte 0FFH			;if the caps lock (or shift) is engaged, browse from the caps lock key array
	je .print_in_caps
	cmp [alt_stat], byte 1
	je .alt_hand
	
	mov edi, eax
	add edi, key_array_noshift
	mov al, byte [edi]
	call _type	;call our type (which will print al & store in buffer for future use)	

	.end:
		mov [space_for_key], byte 0
		ret
	.esc:
		jmp .end
	.backspace:
		cmp [cur_buf_addr], dword buffer	;to prevent users from backspacing TOO far (into the pointer itself!)...
		jbe .end
		mov ebx, dword [cur_buf_addr]
		sub [cur_mem], dword 2
		dec byte [cur_buf_addr]
		mov edi, dword [cur_mem]
		mov [ebx], byte 0
		mov [edi], byte 0
		call shift_cursor
		jmp .end
	.tab:
		;mov ebx, dword [cur_mem]
		;mov cl, 0
		;mov ch, byte [curcolor]
		;mov [ebx], word cx
		;mov [ebx+2], word cx
		;mov [ebx+4], word cx		;do not try to use this, it does not work...
		;mov [ebx+6], word cx
		;add [ebx], dword 8
		;call shift_cursor
		jmp .end
	.control:
		mov [control_stat], byte 1
		jmp .end
	.shift:
		mov [shift_stat], byte 1
		jmp .end
	.alt:
		mov [alt_stat], byte 1
		jmp .end
	.release_shift:
		mov [shift_stat], byte 0
		jmp .end
	.release_control:
		mov [control_stat], byte 0
		jmp .end
	.release_alt:
		mov al, [numbers_stat]
		call print_char
		mov [alt_stat], byte 0
		jmp .end
	.enter:
		call new_line	;new line
		call command	;call our command dictionary
		call clear_buffer
		mov esi, prompt						
		call print_str				;print our prompt
		call shift_cursor	
		mov [cur_buf_addr], dword buffer	;reset the buffer
		jmp .end
	.print_screen:
		jmp .end
	.caps_lock:
		mov al, byte [caps_lock_stat]
		not al
		mov [caps_lock_stat], byte al
		jmp .end
	.print_in_shift:
		mov edi, eax
		add edi, key_array_shift
		mov al, byte [edi]
		cmp [caps_lock_stat], byte 0FFH
		jne .back2
		cmp al, 41H
		jge .great2
		.back2:
			call _type	;call our type (which will print al & store in buffer for future use)
			jmp .end
		.great2:
			cmp al, 5AH
			jg .back2
		.less2:
			add al, 20H
			jmp .back2
	.print_in_caps:
		mov edi, eax
		add edi, key_array_noshift
		mov al, byte [edi]
		cmp al, 61H
		jge .great
		.back:
			call _type	;call our type (which will print al & store in buffer for future use)
			jmp .end
		.great:
			cmp al, 7AH
			jg .back
		.less:
			sub al, 20H
			jmp .back
	.alt_hand:	;PROGRESS
		cmp al, 2
		jbe .end
		cmp al, 12
		jae .end
		jmp .end
	.control_handle:
		cmp al, 2DH
		je .end_task
		
		jmp .end
		.end_task:
			
			int 31H
			
	.cmp80:
		;if a key is released, its handler can go here (such as if you release control or alt or shift or other sorts)
		cmp al, 0AAH
		je .release_shift
		cmp al, 0B6H
		je .release_shift
		cmp al, 0B8H
		je .release_alt
		cmp al, 09DH
		je .release_control
		jmp .end
