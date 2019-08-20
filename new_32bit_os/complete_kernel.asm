;
;The NOT SO Cringy Os by Daniel Moylan, Brandon Koerner, Brett Bolton, (and whomever else).
;
;License:
;
;	You are free to edit and republish your edited version as long as:
;		1: you title the software as such: "[Your Title], derived from [or "based off of", you can phrase it how you wish] The NOT SO Cringy Os by Daniel Moylan, Brandon Koerner, Brett Bolton, (and whomever else).",
;		2: your license includes provisions that provide credit to the original authors,
;		3: you do not use this product to make any sort of fiscal GAIN (meaning not neccesarily profit) whatsoever,
;		4: and you follow any other rules and regulations pretaining to this software stated in this license.
;
;	You can publish the software in its original form as long as:
;		1: you title the software after the original title as you first found it in this software,
;		2: you license it under the original license as you first found it in this software,
;		3: you do not take credit for editing this software in any way,
;		4: you do not use this product to make any sort of fiscal GAIN (meaning not neccesarily profit) whatsoever,
;		5: and you follow any other rules and regulations pretaining to this software stated in this license.
;		
;	This software comes AS IS, meaning if you used it, you take full responsibility for any damages you cause with this software.
;	These damages do include how you use this software, therefore if one commits any crimes/acts of vandalism with it, we (as the authors) are not responsible in any way.
;	If you were affected by this software in any way, we take no responsibility whatsoever.
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

null equ 0
NULL equ 0
false equ 0
true equ 1


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
	
standby:
	cmp [space_for_key], byte 0		;endless loop until a key is loaded in the space
	je standby
	call main_keyboard_handler			;then we call the keyboard handler (which then calls the command interpreter if the user presses enter)
	jmp standby					;and jump back.

intro db 'The Not-SO Cringy Os',0
intro2 db 'By Daniel Moylan, Brandon Koerner, Brett Bolton, and whomever else.',0	
waiting db 'Initializing keyboard and interrupt vector tables...', 0
prompt db 'NonCringeOs@'				;NO TERMINATION!!!
path db 'A:\>',0						;so we print next string, which is the path we are on: A is supposed to be the flash drive that you booted from.
;drive letters are basically A-Z, the system checks flash drive ports 1st, then SATA ports, then CD drives. the drive letters are assigned in that order.
;if the current drive is unavaliable (ex. you pulled out your flash drive), then the system will go up a drive letter.
;if there are NO drives PERIOD, then it will display a question mark ("NonCringeOs@?>")
;note that none of the above is implemented yet, just concepts...
	
%include 'text_graphics.asm'
%include 'isrs.asm'
%include 'irqs.asm'	
%include 'keyboard.asm'
%include 'command_structure.asm'
%include 'std.asm'
%include 'timer.asm'
;add new files here (makes for convinent hex editing/debugging, since idt is a huge blank space)
%include 'idt.asm'			;because we have a big blank space for idt here

space_for_key db 0

cur_buf_addr dd buffer		;and a kilobyte of buffer for user to type here

buffer times 1024 db 0			;give the user a kilobyte of bufferage for the command line (no one will type a kilobyte of text, but just in case, we will handle that.)

end_buffer						;define an end point

db 0							;end of buffer null so that 1024 bytes will be terminated.

times 1509437-($-$$) db 0		;pad with zeros (i just chose this number because that would make my program exactly 1.44 MB, aka the amount of space on a floppy drive)