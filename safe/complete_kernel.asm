;
;The NOT SO Cringy Os by Daniel Moylan and Brandon Koerner.
;
;License:
;
;	You are free to edit and republish an edited version as long as:
;		1: you title the software as such: "[Your Title], derived from [or "based off of," you can phrase it how you wish] The NOT SO Cringy Os by Daniel Moylan and Brandon Koerner.",
;		2: your license includes provisions that provide credit to the original authors,
;		3: you do not use this product to make any sort of fiscal GAIN (meaning not necessarily profit) whatsoever,
;		4: and you follow any other rules and regulations pretaining to this software stated in this license.
;
;	You can publish the software in its original form as long as:
;		1: you title the software after the original title as you first found it in this software,
;		2: you do not license it for anyone to use,
;		3: you do not take credit for editing this software in any way,
;		4: you do not use this product to make any sort of fiscal GAIN (meaning not neccesarily profit) whatsoever,
;		5: and you follow any other rules and regulations pretaining to this software stated in this license.
;		
;	This software comes AS IS, meaning if you used it, you take full responsibility for any damages you cause with this software.
;	These damages do include how you use this software, therefore if one commits any crimes/acts of vandalism with it, we (as the authors) are not responsible in any way.
;	If you were affected by this software in any way, we still take no responsibility whatsoever (sorry).
;	
;	By interacting with this software in anyway (ex. downloading, using, editing, copying, sending, possesing in any sort of drive, etc.), you consent to these rules stated above.
;	Any deviation from these rules will require the HANDWRITTEN concent of AT LEAST Daniel Moylan AND Brandon Koerner.
;
;	You can contact us (as the authors) at demoylan@gmail.com if you have problems with this software. ---email might change, depending on how big this gets---
;	Please note that we are not obliged to respond to you in any way, it is our discression as to who we help or to what extent we help.
;	A helpful resource for these types of projects might be osdev.org or the intel IA-32 manuals (or even the comments on this page), please consult them 
;

org 7C00H				;our entry point in memory

%include 'bootloader.asm'

bits 32					;tell nasm that we want 32 bit compilation from now on.	

clear:
	mov ax, 10H			;move all segment registers to the DATA segment and say goodbye to them FOREVER!!!
	mov ds, ax			;unless we need extra descriptors for apps (which we are going to)
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esp, 90000H		;move the stack pointer (points to the current stack location) to a distant location so as not to interfere (this will be edited later)...
	
_start_:
	cli
	xor ah, ah			;to not confuse printing functions...
	call clear_screen
	mov esi, waiting	;clear the screen and print a waiting message.
	call print_str
	
	call keyboard_setup
	call idt_setup
	
	call init

hang:
	cmp [space_for_key], byte 0
	jne main_keyboard_handler
	jmp hang
	
	
gdt:					;GDT GUIDE !!!!!!!!
	dq 0				;64 bits null ('null descriptor' or whatever)
						;start of code descriptor (where we define our executable code, i guess...)
	dw 0FFFFH			;this is the max we can set our segment registers (so we can load highest potental value in there)
	dw 0				;this is the segment starting address (0), so we can access from 0 to FFFFH
	db 0				;continuation of last section (with segment starter address)
	db 10011010B		;MAGICAL TABLE!!!! ;;;;;;;KEY;;;;;;;; (bits go least -> most significance: 76543210, in other words little endian)
						;bit 0 == 'access bit' (dont worry about it, something called 'virtual memory' or some bullshit)
						;bit 1 == 'read/write bit' (1 for read/execute, 0 is for just execute)
						;bit 2 == 'expansion direction' don't quite know what it does, leave to 0
						;bit 3 == 'code/data descriptor' (this is a code descriptor, so we set to 1)
						;bit 4 == 'system/(code or data)' (again, this is code, so it is a 1)
						;bit 5-6 == 'permissions level' (0 == kernel, 3 == apps)
						;bit 7 == again, virtual memory. don't really know/care.
	db 11001111B		;another key
						;bits 0-3 == 20th address line max value (for when we enable the address line)
						;bits 4-5 == reserved/we just dont care
						;bit 6 == 16 (0) or 32 (1) bit (we want 1, since that's why we are doing this in the first place -_____-)
						;bit 7 == 'granulaity', set to 1 for 4 kB for something to do with segments.... (i hate segments)
	db 0				;last byte of starting address for segments that was before the two 'magical tables' (wtf is this ordering...)
						;data descriptor (or whatever)
	dw 0FFFFH			;same thing basically
	dw 0				
	db 0				
	db 10010010B		;except we set the code descriptor bit to zero, because data descriptor!
	db 11001111B		
	db 0	
	
%include 'text_graphics.asm'
%include 'isrs.asm'
%include 'irqs.asm'	
%include 'keyboard.asm'
%include 'shell.asm'
%include 'std.asm'
%include 'timer.asm'

;add new files here (makes for convinent hex editing/debugging, since idt is a huge blank space)
%include 'idt.asm'			;because we have a big blank space for idt here

space_for_key db 0

cur_buf_addr dd buffer		;and a kilobyte of buffer for user to type here

buffer times 1024 db 0			;give the user a kilobyte of bufferage for the command line (no one will type a kilobyte of text, but just in case, we will handle that.)

end_buffer db 0						;define an end point

intro db 'The Not-SO Cringy Os',0
intro2 db 'By Daniel Moylan and Brandon Koerner.',0	
waiting db 'Initializing keyboard and interrupt vector tables...', 0
prompt db 'NonCringeOs@'				;NO TERMINATION!!!
path db 'A:\>',0						;so we print next string, which is the path we are on: A is supposed to be the flash drive that you booted from.
;drive letters are basically A-Z, the system checks flash drive ports 1st, then SATA ports, then CD drives. the drive letters are assigned in that order.
;if the current drive is unavaliable (ex. you pulled out your flash drive), then the system will go up a drive letter.
;if there are NO drives PERIOD, then it will display a question mark ("NonCringeOs@?>")
;note that none of the above is implemented yet, just concepts...

times 100000H-($-$$)-7C00H db 0		;pad with zeros (i just chose this number because that would make my program exactly 1.44 MB, aka the amount of space on a floppy drive)
end_of_kernel_space
