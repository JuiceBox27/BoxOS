bootsect.bin:bootsect.asm ./bootsectfunctions/printf.asm ./bootsectfunctions/printh.asm ./bootsectfunctions/readDisk.asm ./bootsectfunctions/testA20.asm ./bootsectfunctions/enableA20.asm ./bootsectfunctions/checklm.asm
	nasm -fbin bootsect.asm -o bootsect.bin

clean:
	rm bootsect.bin

run:bootsect.bin
	qemu-system-x86_64 bootsect.bin

iso:
	rm -rf ./iso
	mkdir iso
	truncate bootsect.bin -s 1200k
	cp bootsect.bin ./iso
	mkisofs -b bootsect.bin -o ./iso/os.iso ./iso