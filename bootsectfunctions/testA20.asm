; test truncation (wrapping) of addresses
; when passing 0xffff w/out A20 line,
; it goes back to 0x0000 

testA20:

pusha

mov ax, [0x7dfe]

push bx
mov bx, 0xffff
mov es, bx
pop bx

mov bx, 0x7e0e

mov dx, [es:bx]

cmp ax, dx
je .cont

popa
mov ax, 1
ret

.cont:
mov ax, [0x7dff]
mov dx, ax
call printh

push bx
mov bx, 0xffff
mov es, bx
pop bx

mov bx, 0x7e0f
mov dx, [es:bx]

cmp ax, dx
je .exit


popa
mov ax, 1
ret

.exit:
popa
xor ax, ax
ret