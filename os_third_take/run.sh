reset
cd src
nasm -f bin kernel.asm -o ../bin/kernel.bin || { echo "compilation failed"; exit 1; }
cd ..
cp bin/kernel.bin iso_dir/
grub-mkrescue -o bin/kernel.iso iso_dir || exit 1
qemu-system-x86_64 -cdrom bin/kernel.iso -d int -no-shutdown -no-reboot
