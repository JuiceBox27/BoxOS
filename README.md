# BoxOS
64-bit OS

best practice would be to use ubuntu or another distro of linux

add qemu virtual machine to your system to be able to run binaries as an operating system. Oracle VirtualBox is a good choice too but you have to make an iso everytime you want to run it and i just prefer qemu, it is much simpler.

add nasm compiler to your system to compile the assembly files

add gcc, gpp compilers to your system

bootsect.asm is the main file containing the bootloader, all the other functions of the bootloader are held in the bootsectfunctions folder.
