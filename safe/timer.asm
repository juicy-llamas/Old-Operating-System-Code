;this is just some code for setting up the PIT timer, not much to really get here...
;this is used by the task scheduler to 

timer_divisor dw 1H
timer_counter dw 0

timer_reset:
	mov al, 36H
	out 43H, al
	
	mov ax, word [timer_divisor]
	out 40H, al
	mov al, ah
	out 40H, al
	ret
	
timer_irq:
	cli
	inc word [timer_counter]
	
	
	;call task_manager_update
	
	