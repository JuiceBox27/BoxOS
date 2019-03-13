; detecting cpuid for long mode (64-bit)
checklm:
pusha

pushfd ; push (32-bit realmode) flags register to stack
pop eax
mov ecx, eax

xor eax, 1 << 21 ; check if 21st bit == bit 1 and flip to 1 if 0

push eax
popfd

pushfd
pop eax

xor eax, ecx ; check if different (64-bit mode)
			; if equal (no 64-bit mode)
jz .done

mov eax, 0x80000000
cpuid
cmp eax, 0x80000001 ; check if eax is less than
jb .done

mov eax, 0x80000001
cpuid
test edx, 1 << 29 ; if bit 29 is 1, 64-bit long mode is supported
jz .done

mov si, LM_SUPPORTED
call printf

popa 
ret

.done:
popa
mov si, LM_NOT_SUPPORTED
call printf
jmp $ ; because it is an error

LM_NOT_SUPPORTED: db "long mode is not supported", 0x0a, 0x0d, 0
LM_SUPPORTED: db "long mode is supported", 0x0a, 0x0d, 0