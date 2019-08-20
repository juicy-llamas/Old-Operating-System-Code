bits 16

;we don't worry about an entry point here because this bootloader will be imaged seperately from the kernel
	mov ax, 0E47H	;print a char to test
	int 10H
	
	cli
	hlt		;halt the processor
	times 446-($-$$) db 0

	db 81H		;bootable (10000001 for bootable, 00000001 for not, aka eight bit set)
	db 0
	dw 0004H	;starting address of 0 (in head-sector-cylinder addressing)
	db 0BH		;FAT32 partition
	db 0		;the partition ends at the next sector, really it doesn't matter where it ends as long as we can load in the bootloader.
	dw 0008H	;extension of last thing
	dd 0		;starting address in LBA (same)
	dd 1		;total sectors in partition (1)!

	times 6 dq 0

	dw 0AA55H
