enableA20:
pusha

; enable through BIOS
mov ax, 0x2401
int 0x15

call testA20
cmp ax, 1
je .done

; enable through keyboard
sti

call waitC
mov al, 0xad ; disable keyboard
out 0x64, al ; send data to port from register (disable command)

call waitC
mov al, 0xd0
out 0x64, al ; tell keyboard that it's data will be read

call waitD
in al, 0x60 ; input (read) port
push ax

call waitC
mov al, 0xd1
out 0x64, al ; tell keyboard that data will be sent

call waitC
pop ax
or al, 2
out 0x60, al ; send data

call waitC
mov al, 0xae
out 0x64, al ; re-enable keyboard

call waitC

sti

call testA20
cmp ax, 1
je .done


; enable through FastA20 (communicates with chipset & unstable)
in al, 0x92 ; port for chipset
or al, 2
out 0x92, al

call testA20
cmp al, 1
je .done

mov si, NO_A20
call printf
jmp $


.done:
	mov si, A20_DONE
	call printf
	popa
	ret

waitC: ; wait for keyboard to be ready
	in al, 0x64 ; input stream from port 64 (keyboard)
	test al, 2 ; compare bit 2

	jnz waitC ; jump-not-zero to waitC
	ret

waitD:	; wait for data to be ready
	in al, 0x64
	test al, 1
	
	jz waitD
	ret

A20_DONE: db "The A20-line is present and active", 0x0a, 0x0d, 0
NO_A20: db "The A20-line is not existent.", 0x0a, 0x0d, 0