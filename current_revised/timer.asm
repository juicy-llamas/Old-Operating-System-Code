cycle_rate dw 0x1	;rate in Hz ~ 1193180/cycles
;rate in minutes ~ 1080000 clock cycles/min = 270000*4 = 3*3*4*10^4
;18 cycles/minute

timer_setup:
	mov al, 0x36
	out 0x43, al
	mov ax, word [cycle_rate]		;set the rate 
	out 0x40, al
	mov al, ah
	out 0x40, al
	
	;any other commands we wish to send the timer go here
	
	ret
	
current_time dw 0
	
timer_int_real:
	mov al, 0x20		;another special opcode (the same except to the other pic, i guess. that is why there are two of them (one for master one for slave).)
	out 0x20, al
	pop eax
	sti
	iret
