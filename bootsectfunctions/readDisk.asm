read_disk:
	pusha
	mov ah, 0x02
	;mov dl, 0x00 ; hard-disk 0x80, other 0x00
	mov ch, 0
	mov dh, 0

	int 0x13

	jc disk_err
	popa
	ret

	disk_err:
		mov si, DISK_ERR_MSG
		call printf
		jmp $

DISK_ERR_MSG: db 'Error Loading Disk.', 0x0a, 0x0d, 0