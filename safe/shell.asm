init:
	call clear_screen
	
	mov esi, intro
	call print_str
	call new_line
	mov esi, intro2
	call print_str
	call new_line
	
	mov esi, prompt
	call print_str
	call shift_cursor
	ret
		
_type:		;char in al
	mov ah, byte [curcolor]
	mov edi, dword [cur_mem]
	mov ebx, dword [cur_buf_addr]
	cmp edi, 0B8FA0H
	je .scroll
	.back:
		mov [edi], byte al
		mov [edi+1], byte ah
		add edi, 2
		mov [ebx], byte al
		inc ebx
		mov [cur_mem], dword edi
		mov [cur_buf_addr], dword ebx
		call shift_cursor
		ret
	.scroll:
		call scroll_screen
		jmp .back
	
command:
	mov edi, buffer		;we move POINTER of buffer to edi
	
	;cmp [edi], byte '$'		;vars are initialized with the dollar sign. (but not yet! under development...).
	;je var_handler
	cmp [edi], byte 'h'			;when we get a lot of commands, it will be more efficient to search by the first letter rather than a giant one-dimensional list.
	je .hs
	cmp [edi], byte 'e'
	je .es
	cmp [edi], byte 'c'
	je .cs
	;cmp [edi], byte 'w'
	;je .ws					;for a 'wait' command that is not to be tested yet.
	
	jmp .bad
	.hs:
		mov esi, command_array.cmd1		;edi and esi are string pointers
		mov ah, ' '						;ah is our termination (space)
		xor cl, cl						;we dont want to use strict (since the buffer could be a space or a zero). see strcmp for a definition of 'strict'.
		call strcmp
		jc help				;if yes then transfer control to help cmd.
		
		jmp .bad		;since 1st char was h, then we dont need to test other letters.
	.cs:
		mov esi, command_array.cmd3		;edi and esi are string pointers
		mov ah, ' '						;ah is our termination (space)
		xor cl, cl						;we dont want to use strict (since the buffer could be a space or a zero). see strcmp for a definition of 'strict'.
		call strcmp
		jc color				;if yes then transfer control to color cmd.
		
		mov edi, buffer
		mov esi, command_array.cmd4		;edi and esi are string pointers
		mov ah, ' '						;ah is our termination (space)
		xor cl, cl						;we dont want to use strict (since the buffer could be a space or a zero). see strcmp for a definition of 'strict'.
		call strcmp
		jc clear_cmd				;if yes then transfer control to clear cmd.
		
		jmp .bad
	.ws:
		;mov esi, command_array.cmd5
		;mov ah, ' '
		;xor cl, cl
		;call strcmp
		;jc wait_cmd
		
		jmp .bad
	.es:
		mov esi, command_array.cmd2
		mov ah, ' '
		xor cl, cl
		call strcmp
		jc echo_		;we don't need jmp since bad is right underneath
	.bad:
		xor ah, ah							;if no command is found, then print our interpreter error msg.
		mov esi, command_array.bad_cmd
		call print_str
		call new_line					;new line (of course)
		ret
	
help:
	call get_next_arg			;moves the pointer of the next arg in 'cur_arg'
	jc .compare					;if there IS a next arg, then 
	.print_gen:
		xor ah, ah
		mov esi, help_menu.out_general
		call print_str
		call new_line
		mov esi, help_menu.out_general2			;print our massive help msg
		call print_str
		call new_line
		mov esi, help_menu.out_general3
		call print_str
		call new_line
		mov esi, help_menu.out_general3.5
		call print_str
		call new_line
		mov esi, help_menu.out_general4
		call print_str
		call new_line
		mov esi, help_menu.out_general5
		call print_str
		call new_line
		mov esi, help_menu.out_general6
		call print_str
		call new_line
		ret
	.compare:
		mov edi, dword [cur_arg]
		mov esi, command_array.cmd1		;eventually might be optimized more, but for now we only have 2 cmds.
		mov ah, ' '
		xor cl, cl
		call strcmp
		jc .help
		
		mov edi, dword [cur_arg]
		mov esi, command_array.cmd2
		mov ah, ' '
		xor cl, cl
		call strcmp
		jc .echo
		
		mov edi, dword [cur_arg]
		mov esi, command_array.cmd3
		mov ah, ' '
		xor cl, cl
		call strcmp
		jc .color
		
		mov edi, dword [cur_arg]
		mov esi, command_array.cmd4
		mov ah, ' '
		xor cl, cl
		call strcmp
		jc .clear
		
		jmp .bad					;invalid cmd == bad
	.help:
		xor ah, ah
		mov esi, help_menu.help			;just printing stuff...
		call print_str
		call new_line
		mov esi, help_menu.help2
		call print_str
		call new_line
		mov [cur_arg], dword buffer			;important because if cur_arg is not reset, then get_next_arg will not work.
		ret
	.echo:
		xor ah, ah
		mov esi, help_menu.echo
		call print_str
		call new_line
		mov [cur_arg], dword buffer
		ret
	.color:
		xor ah, ah
		mov esi, help_menu.color
		call print_str
		call new_line
		mov [cur_arg], dword buffer
		ret
	.clear:
		xor ah, ah
		mov esi, help_menu.clear
		call print_str
		call new_line
		mov [cur_arg], dword buffer
		ret
	.bad:
		xor ah, ah
		mov esi, help_menu.bad
		call print_str
		call new_line
		mov [cur_arg], dword buffer
		ret
		
echo_:
	call get_next_arg
	jnc .ret						;if we don't have args, then we return.
	mov esi, dword [cur_arg]
	cmp [esi], byte '"'
	je .quote
	xor ah, ah
	call print_str
	mov [cur_arg], dword buffer
	.ret:
		call new_line
		ret
	.quote:
		inc esi
		mov ah, '"'
		call print_char
		mov [cur_arg], dword buffer
		jmp .ret
		
color:
	call get_next_arg
	jnc .invalid
	xor al, al
	
	mov edi, dword [cur_arg]
	mov esi, color_menu.opt_1		;short for 'option 1', opt_1
	mov ah, ' '
	xor cl, cl
	call strcmp
	jnc .convert
	
	.print_help:
		xor ah, ah
		mov esi, color_menu.help1
		call print_str
		call new_line
		mov esi, color_menu.help1.5			;print our massive help msg
		call print_str
		call new_line
		mov esi, color_menu.help2
		call print_str
		call new_line
		mov esi, color_menu.help3
		call print_str
		call new_line
		mov esi, color_menu.help4
		call print_str
		call new_line
		mov esi, color_menu.help5
		call print_str
		call new_line
		mov [cur_arg], dword buffer
		ret
	.convert:
		mov esi, dword [cur_arg]
		call strlen
		cmp ecx, 2		;if it is over two chars, then it is invalid
		ja .invalid
		
		mov esi, dword [cur_arg]
		xor ah, ah
		call hex_to_num_small		;get num
		jnc .invalid
		mov [curcolor], byte cl		;put num in curcolor
		
		mov al, cl
		call change_screen_color
		
		mov [cur_arg], dword buffer	;reset
		ret
	.invalid:
		mov esi, color_menu.bad_arg
		call print_str
		call new_line
		mov [cur_arg], dword buffer
		ret

clear_cmd:
	call clear_screen
	ret

get_next_arg:			;gets the next argument in line
	mov edi, dword [cur_arg]
	.loop:
		cmp [edi], byte ' '	;if its a space
		je .set			;then we set the 'cur_arg to that location (+1 to get the start of the next arg)


		cmp [edi], byte 0	;if null
		je .reset		;then we move cur_arg back to the start of the buffer
		inc edi
		jmp .loop
	.set:
		inc edi			;getting the pointer AFTER the space
		mov [cur_arg], dword edi	;if space, then set the cur_arg pointer to edi
		stc				;stc (CF=1) (in this case) means that there is indeed a next argument.
		ret
	.reset:
		mov [cur_arg], dword buffer		;if not, then clear it.
		clc				;clc (CF=0) means that there isn't a next arg.
		ret	
		
cur_arg dd buffer
		
command_array:
	.cmd1 db 'help',0
	.cmd2 db 'echo',0
	.cmd3 db 'color',0
	.cmd4 db 'clear',0
	.cmd5 db 'wait',0
	.bad_cmd db 'That command is not recognized by the interpreter.',0
	
help_menu:
	.out_general db 'Commands: help, echo, color, and clear.',0
	.out_general2 db 'Type "help [command]" for more information on a particular command.',0
	.out_general3 db 'Square brackets are optional arguments.',0
	.out_general3.5 db 'Squiggly brackets are mandatory arguments.',0
	.out_general4 db 'For more information on that command, try something like "{command} -help".',0
	.out_general5 db 'Most all commands have a internal help menu, but some may not.',0 
	.out_general6 db 'This list guarantees a comprehensive list of all commands.',0
	.help db 'help - displays help on a particular command, or the list of commands.',0
	.help2 db 'Usage: help [command]',0
	.echo db 'echo - outputs text. Usage: echo [text]',0
	.bad db 'The command you searched for does not exist.',0
	.color db 'color - changes the color. Usage: color {color number}',0
	.clear db 'clear - clears the screen. Usage: clear',0

color_menu:
	.opt_1 db '-help',0
	.help1 db '"color" changes the color of your text.',0
	.help1.5 db 'The color is a single parameter (the color byte, it is called).',0
	.help2 db 'The color byte should be in hexadecimal.',0
	.help3 db 'Byte layout (little endian):',0
	.help4 db 'blink,Rback,Gback,Bback,intensity,Rtext,Gtext,Btext',0
	.help5 db '"back" refers to the background while "text" refers to the characters.',0
	.bad_arg db 'Bad argument.',0