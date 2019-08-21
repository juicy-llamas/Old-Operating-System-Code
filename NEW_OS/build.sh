#!/bin/bash
#some variables for configuration
#for efi mode, you have to specify your gnu-efi installation paths (one for the include files, and one for the libraries). you specify these in compile.sh in the uefi bootloader directory.

#the mode we are in (bios or uefi)
export mode="bios"
#how to produce the image (iso or img). if you don't want to build an image, then simply say 'compile' as an argument
export export_mode="img"
#the directory of this folder (DO NOT CHANGE, or your log files will be screwed up)
export this_dir="$(pwd)"

#arguments:
	#clean: removes bin contents (except export.sh)
	#compile: compiles linked kernel and bootloader separately
	#export: exports the compiled files only; does not recompile
	#all: compiles and exports to an image at once.

shopt -s xpg_echo
rm -f log.txt
>> log.txt

echo "-------------------------------------------------------------------------------------"
echo "                                  NOT SO  CRINGY OS                                  "
echo "                           to be published  as YANN MARTEL                           "
echo "                                     build  tool                                     "
echo "-------------------------------------------------------------------------------------"
echo "\n"

if [ "$1" = "clean" ]; then
	echo "removing bin contents..." | tee -a log.txt
	mv bin/export.sh export.sh
	rm bin/*
	mv export.sh bin/export.sh
elif [ "$1" = "compile" ]; then
	cd kernel/
	./compile.sh
	if [ "$mode" = "uefi" ]; then
		cd ../uefi_bootloader/
        	./compile.sh
        	if [ $? = 1 ]; then
        		echo "compiling failed" | tee -a ../log.txt
        	        exit 1
        	fi
	elif [ "$mode" = "bios" ]; then
		cd ../bios_bootloader/
                ./compile.sh
                if [ $? = 1 ]; then
                        echo "compiling failed" | tee -a ../log.txt
                        exit 1
                fi
	else
                echo "error: 'mode' is not set properly. you can change it in 'build.sh.'" | tee -a log.txt
                exit 1
        fi
elif [ "$1" = "all" ]; then
	cd kernel/
	./compile.sh

	if [ "$mode" = "uefi" ]; then
		cd ../uefi_bootloader/
		./compile.sh
		if [ $? = 1 ]; then
                        echo "compiling failed" | tee -a ../log.txt
                        exit 1
                fi
                cd ../bin/
                ./export.sh
                if [ $? = 1 ]; then
                        echo "export to image failed" | tee -a ../log.txt
                        exit 1
                fi
	#bios is not set up yet, should be simple enough to do, but dont build for bios yet
	elif [ "$mode" = "bios" ]; then
		cd ../bios_bootloader/
		./compile.sh
		if [ $? = 1 ]; then
			echo "compiling failed" | tee -a ../log.txt
			exit 1
		fi
		cd ../bin/
		./export.sh
		if [ $? = 1 ]; then
			echo "export to image failed" | tee -a ../log.txt
			exit 1
		fi
	else
		echo "error: 'mode' is not set properly. you can change it in 'build.sh.'" | tee -a log.txt
		exit 1
	fi
elif [ "$1" = "export" ]; then
	cd ../bin/
	./export.sh
	if [ $? = 1 ]; then
		echo "export to image failed" | tee -a ../log.txt
		exit 1
	fi
elif [ "$1" = "help" ]; then
	echo "options are clean, compile, all, or export"
fi

cd $this_dir
echo "done" | tee -a log.txt

