lsusb -d 0781:5530
#! [[ $? = 0 ]] && { echo "please plug in the sandisk cruzer usb before proceeding"; exit 1; }
nasm -f bin -o kern.img complete_kernel.asm
#[[ $1 = "all" ]] && nasm -f bin -o paging_table.img paging_table.asm
#sudo dd if=code.img of=kern.img
#sudo dd if=paging_table.img of=kern.img oflag=append conv=notrunc
sudo dd if=kern.img of=/dev/sdb bs=4M
