print_string:
    pusha
    mov ah, 0x0e ; Set BIOS to tele-type mode
string_start:
    mov al, [bx] ; Get current character in bx and move it into al 
    cmp al, 0 ; Check if current character is the null terminating character
    je string_end ; If we have reached the null terminating character jump to the end
    int 0x10 ; Interupt for printing character
    inc bx ; Increment bx to get to the next character
    jmp string_start ; Jump back to the beggining
string_end:
    mov al, 0x0d ; 0x0d is \cr character, move it into al for printing
    int 0x10 ; Print
    mov al, 0x0a ; 0x0a is \lf character, move it into al for printing
    int 0x10 ; Print
    popa ; Return registers to original state
    ret ; Return 