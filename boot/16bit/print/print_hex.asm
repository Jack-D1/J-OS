
print_hex:
    pusha
    mov cx, 4 ; 4 characters, use as loop counter
hex_start:
    dec cx
    mov ax, dx ; Get Hex we want to print and put it into ax
    shr dx, 4 ; shift dx 4 bits to the right
    and ax,0xf ; and to get the last 4 bits 
    mov bx, HEX_OUT ; Get memeonry address of our string 
    add bx,2 ; skip 0x
    add bx,cx ; Add counter to the address
    cmp ax, 0xa ; check if letter or number
    jl set_letter ; if its a number jump
    add al,0x27 ;If its a letter ad 0x27 and 0x30 for ASCII offset
set_letter:
    add al,0x30 ; For ASCII nmumber add 30
    mov byte [bx],al
    cmp cx, 0 ; check if we've looped over all characters
    jne hex_start
    mov bx, HEX_OUT
    call print_string
    popa
    ret
HEX_OUT:
db '0x0000',0