[org 0x7c00]
[bits 16]

section .text

	global main ; define global main entry point

main:

cli ; assures there are no interrupts
jmp 0x0000:zero_segment
zero_segment:
	xor ax, ax ; set ax to 0 = mov ax, 0
	mov ss, ax ; set all values to 0
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, main ; move stack pointer to main
	cld ; clear direction flag (set direction flag to 0)
sti ; brings back interrupts from cli

mov si, BOOT_SECT1_MSG
call printf

; reset disk (set all vars for disk to 0 if they were not)
xor ax, ax
mov bx, second_sector
mov dl, 0x80
int 0x13

mov dl, 0x80
mov al, 1 ; sectors to read
mov cl, 2 ; start sector
mov bx, second_sector
call read_disk

call enableA20

jmp second_sector ; no need for second sector at the moment

jmp $ ; security hang

%include "./bootsectfunctions/readDisk.asm"
%include "./bootsectfunctions/printf.asm"
%include "./bootsectfunctions/printh.asm"
%include "./bootsectfunctions/testA20.asm"
%include "./bootsectfunctions/enableA20.asm"

BOOT_SECT1_MSG: db "First sector loaded", 0x0a, 0x0d, 0
BOOT_SECT2_MSG: db "Second sector loaded", 0x0a, 0x0d, 0


; padding and magic number
times 510-($-$$) db 0
dw 0xaa55

second_sector:
mov si, BOOT_SECT2_MSG
call printf

call checklm

cli

; PAGE-TABLES
mov edi, 0x1000 ; get to address 1000
mov cr3, edi
xor eax, eax ; nullify eax register
mov ecx, 4096 ; set count to 4096
rep stosd ; repeat the stored string
mov edi, 0x1000

mov dword [edi], 0x2003 ; first 2 bits in page table are set
add edi, 0x1000
mov dword [edi], 0x3003 ; dword = 32 bits
add edi, 0x1000
mov dword [edi], 0x4003
add edi, 0x1000

mov dword ebx, 3
mov ecx, 512

.setEntry:
	mov dword [edi], ebx
	add ebx, 0x1000 ; add 4KB
	add edi, 8 ; advance to next entry in page
	loop .setEntry

mov eax, cr4
or eax, 1 << 5
mov cr4, eax

; enabling long mode
mov ecx, 0xc0000080
rdmsr
or eax, 1 << 8 ; flip bit
wrmsr ; write bit

mov eax, cr0
or eax, 1 << 31
or eax, 1 << 0
mov cr0, eax

lgdt [GDT.Pointer] ; load the GDT at the pointer
jmp GDT.Code:LongMode ; jmp from the Code segment to long mode

%include "./bootsectfunctions/checklm.asm"
%include "./bootsectfunctions/gdt.asm"

[bits 64]
LongMode:

mov edi, VID_MEM
;mov rax, 0x0f54 ; hex for black background '0', white character 'f' and the character T '54'
mov rax, 0x1f201f201f201f20 ; blue background spacebar
mov [VID_MEM], rax
mov ecx, 500
rep stosq
mov rax, 0x1f741f731f651f54 ; prints test
mov [VID_MEM], rax


hlt
VID_MEM equ 0xb8000 ; video memory address

times 512 db 0 ; extra padding for Qemu so it knows there still is disk space
