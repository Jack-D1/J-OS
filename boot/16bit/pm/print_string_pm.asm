[bits 32]
; Define some constants 
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by EDX 
print_string_pm:
    pusha 
    mov edx, VIDEO_MEMORY ; Set EDX to start of video memory 

print_string_pm_loop:
    mov al, [ebx] ; Store the char at EBX in AL 
    mov ah, WHITE_ON_BLACK ; Store the attributes in AH 

    cmp al, 0 ; if (al == 0), we've hit null terminator so jump to done 
    je print_string_pm_done 

    mov [edx], ax ; Store char and attributes at current character cell 
    inc ebx ; Increment EBX to the next char in the string 
    add edx, 2 ; Move to the next char in video memory 

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret ; return from the function