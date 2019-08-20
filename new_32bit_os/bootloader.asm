bits 16					;bootloader is 16 bit code

entry:					;entry point for bootloader

mov di, 0				;move ds to zero (because of org)
mov ds, di				;fixes any loading errors (some bioses load into '07C0:0000H' instead of '0000:7C00H', making the segment register have a faulty address.

mov si, loading
call print
mov ax, 0E0AH
int 10H
mov ax, 0E0DH
int 10H

mov si, diskthingy
mov ah, 42H				;42h = read
int 13H					;call disk services

jc error_handler		;jump to the error handler if not successful (carry)

mov si, message			;print that the kernel has been loaded
call print
xor ah, ah
int 16H					;wait for keypress.

jmp setup_protected_mode

error_handler:
	mov dh, ah			;save value of ah currently (ah gets overwritten by print)

	mov si, fail
	call print
	
	mov al, dh			;putting value of old ah into al		
	int 10H				;print
	cli					;clear all interrupts (so we don't get interrupted)
	jmp $				;jmp here

loading db 'Kernel loading...',0
message db 'Kernel loaded. Press any key to continue...',0
fail db 'Loading the kernel failed. Error code: ',0 

print:
	mov ah, 0EH
	.loopc:				;a little improvised printing function
		mov al, [si]
		cmp al, 0
		je .endc		
		int 10H
		inc si
		jmp .loopc
	.endc:
		ret

diskthingy: db 16,0			;16 == #of bytes, 0 is null
.read_sector: dw 2850
.offset: dw 7E00H			;we load the kernel right next to the bootloader, which is very convinent for us since we don't have to change our origin :)
.segment: dw 0000H
.end: dq 1H

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
	
gdtp:
	dw gdtp-gdt-1
	dd gdt
	
setup_protected_mode:
	mov ax, 03H			;setup VGA graphics mode for ease
	int 10H				
	
	in al, 92H			;enabling A20 gate via motherboard port 146 (somehow, when you logical or the second bit of port 146 (92H), then you enable A20. Depends on mother board, obviously)
	or al, 2			;if it doesn't work, google "how to enable A20 gate" and copy someone else's more elaborate A20 function that actually has error handling :I
	out 92H, al 		;this should work for most, though
	
	cli					;disable interupts
	lgdt [gdtp]			;global descriptor table
	mov eax, cr0		;we need to set bit one of cr0 to enter protected
	or eax, 1			;so we set it in eax
	mov cr0, eax		;and move it back
	jmp 08H:clear		;far jump to clear all of the registers (and main code)
	
times 510-($-$$) db 0
dw 0AA55H						;END OF 1st stage of BOOTLOADER