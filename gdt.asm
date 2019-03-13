GDT:
    .Null: equ $ - GDT
        dw 0
        dw 0
        dw 0
        dw 0
        dw 0
        dw 0

    .Code: equ $ - GDT
        dw 0
        dw 0
        dw 0
        dw 10011000b
        dw 00100000b
        dw 0

    .Data: equ $ - GDT
        dw 0
        dw 0
        dw 0
        dw 10000000b
        dw 0
        dw 0

    .Pointer:
        dw $ - GDT - 1
        dq GDT