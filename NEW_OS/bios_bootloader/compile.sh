echo "compiling bootlader..." | tee -a ../log.txt
nasm -f bin -o ../bin/bootloader.bin bootloader.asm |& tee -a ../log.txt
! [[ $? = 0 ]] && exit 1 || exit 0
