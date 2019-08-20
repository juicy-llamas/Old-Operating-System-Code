echo "making image..." | tee -a ../log.txt
rm -f kernel.img

if [ $export_mode = "img" ]; then
	if [ $mode = "uefi" ]; then
		dd if=/dev/zero of=kernel.img bs=1K count=46875 &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		mkfs.vfat kernel.img &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		mkdir temp
		mount kernel.img temp &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		mkdir temp/EFI &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		mkdir temp/EFI/BOOT &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		cp BOOTX64.EFI temp/EFI/BOOT/BOOTX64.EFI &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		cp kernel.bin temp/kernel.bin &>> ../log.txt
        ! [[ $? = 0 ]] && exit 1
		umount kernel.img &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		rmdir temp
		exit 0
	elif [ $mode = "bios" ]; then
		kernel_size="$( stat -c%s kernel.bin )"
		dd if=bootloader.bin of=kernel.img bs=512 count=1 &>> ../log.txt
		! [[ $? = 0 ]] && exit 1
		dd if=kernel.bin of=kernel.img bs=$kernel_size count=1 oflag=append conv=notrunc &>> ../log.txt
		! [[ $? = 0 ]] && exit 1 || exit 0
	fi
elif [ $export_mode = "iso" ]; then
	#something
	exit 0
fi
