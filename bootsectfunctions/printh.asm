printh:
push cx
push di
push bx

mov si, HEX_PATTERN ; load HEX_PATTERN to si
mov cl, 12
mov di, 2

.hexloop:
	mov bx, dx ; copy so original value is preserved
	shr bx, cl ; shift value in bx by 12 bits to the right
	and bx, 0x000f ; masking the first three digits
	mov bx, [bx + HEX_TABLE] ; load ascii character from HEX_TABLE into bx
	mov [HEX_PATTERN + di], bl ; inserting byte bl into HEX_PATTERN
	sub cl, 4 ; subtracting 4 to cl
	inc di ; increment di (by 1)

	cmp di, 6 ; compare to 6 because the HEX_PATTERN.length = 5
	je .exit

jmp .hexloop

.exit:
call printf

pop bx
pop di
pop cx
ret


HEX_PATTERN: db "0x****", 0x0a, 0x0d, 0 ; template for hex values
HEX_TABLE: db "0123456789abcdf" ; array of all hex values