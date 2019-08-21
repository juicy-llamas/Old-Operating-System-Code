# Old-Operating-System-Code

Old functioning toy OS projects I made.

Started when I was in the tenth grade, and continued for about a year until I moved on to other sorts of things.
I offer absolutely no warranty if you want to try and run this on your computer. 
Chances are it won't run unless your computer is extremely ancient (10 yrs).
This code was tested either on a Dell 1560 Inspiron or QEMU, depending on the particular version you pick.

## Running

If you want to run it on a live system (which I do not recommend, though *it does run*), 
the process I used was to image it to a USB using an imaging utility, like 
Rufus for windows or DD for linux. Then, just boot from the USB in bios. 

The particular version you may want to run would be in the called 'safe.' This version actually uses my own custom bootloader, so it runs on only a small subset of systems. All you have to do to actually make a boot drive is:

```
./compile.sh
dd if=kern.img of=/dev/yourusbnumber
```

That should be it, and you should have a working boot drive.

## Compiling and Building

Most of the versions should have a bash script called `compile.sh` or something similar, except for 'new 32 bit os' which lacks one, and 'NEW_OS,' which has a more complicated, robust script called `build.sh` which behaves similar to a makefile. That script, and the others in the folders, are actually the most noteworthy items in that particular project, given the lack of an actual project.

The general procedure for compiling goes something like this:

```
nasm -f bin -o kernel.img root_file.asm
dd if=kernel.img of=/dev/sdb bs=4M
```

Where the 'root_file.asm' is the main file, that has all of the includes in it as well as trailing 0 space. Note that I did not use linkers in compilation (I used NASM itself for 'linking'), but it is quite possible with modifications to the code. I just found this much easier than actually learning linker script, at the time.

### A Small Note about Version Control

First off, I was around 14-16 when I wrote this, and I was also antisocial, so I worked alone on a large majority of my projects. I only started using git when I was 18. Because of this, the version control 'system' is really not a system and is very sporadic. I am sure I have even more versions on other old computers, these were just consolidated in one convenient place. 

That being said...

- 'safe' is a version of the 'original' applciation for which this project is known for, and also where all of the pictures (soon to be uploaded onto my website, which is being developed currently) come from. 
  - It is the last stable version.
- 'current_revised' is an extension of that. It attempts to actually preform standard operating system tasks, like for instance, managing memory with paging. I never got far with it and it is in an unstable state.
- 'new 32 bit os' looks (at a glance) to be an older version of 'safe.' I am uncertain whether it is stable or not, be my guest to try.
- 'NEW_OS' is a template for a project I never developed, mostly. I tried to make a UEFI/BIOS compatable bootloader and failed, then I gave up. The template is left.
- 'os_third_take' is a project for a 64 bit OS. In this version, I actually use GRUB and make a bootable ISO image. I succeeded into entering long mode, and I was going to attempt to make a memory handler using paging. I stopped there.

If you have gotten this far, enjoy looking through this repo, if for nothing else than to amuse yourself on a boring day.
