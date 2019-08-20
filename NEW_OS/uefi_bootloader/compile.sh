efi_include="/usr/include/efi"
efi_lib="/usr/lib"

echo "compiling uefi bootloader..." | tee -a ../log.txt
gcc -I $efi_include -I $efi_include/x86_64 -I $efi_include/protocol -fno-stack-protector -fpic -mno-red-zone -fshort-wchar -Wall -DEFI_FUNCTION_WRAPPER -c -o ../bin/bootloader.o bootloader.c |& tee -a ../log.txt
! [[ $? = 0 ]] && exit 1
ld -nostdlib -znocombreloc -T $efi_lib/elf_x86_64_efi.lds -shared -Bsymbolic -L $efi_lib -o ../bin/bootloader.so ../bin/bootloader.o |& tee -a ../log.txt
! [[ $? = 0 ]] && exit 1
objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64 ../bin/bootloader.so ../bin/BOOTX64.EFI |& tee -a ../log.txt
! [[ $? = 0 ]] && exit 1 || exit 0
