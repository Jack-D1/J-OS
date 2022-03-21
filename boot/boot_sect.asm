; A boot sector that enters 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ; This is the memory offset to which we will load our kernel

    mov [BOOT_DRIVE], dl    ; BIOS Stores boot drive in DL so best to save for later

    mov bp, 0x9000          ; Set the stack 
    mov sp, bp



    mov bx, MSG_REAL_MODE
    call print_string


    call load_kernel        ; Load our kernel

    call switch_to_pm       ; Note that we never return from here
    jmp $

;Include prewritten routines
%include "print/print_string.asm"
%include "print/print_hex.asm"
%include "disk/disk_load.asm"
%include "pm/gdt.asm"
%include "pm/print_string_pm.asm"
%include "pm/switch_to_pm.asm"

[bits 16]
; Load Kernel
load_kernel:
    mov bx, MSG_LOAD_KERNEL ; Print a message to say we are loading the kernel
    call print_string

    mov bx, KERNEL_OFFSET   ; Set-up parameters for our disk-load routine, so that we load the first 15 sectors (excluding boot sector)
    mov dh, 31              ; from the boot disk (i.e. our kernel code) to address KERNEL_OFFSET 
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret
[bits 32]
; This is where we arrive after switching to and initialising protected mode
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm    ; Use our 32-bit routine

    call KERNEL_OFFSET      ; Jump to the address of our loaded kernel code, assume the brace position and cross your giners 

    jmp $                   ; Hang

; Global Variables 
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Sucessfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

;Boot sector padding
times 510-($-$$) db 0
dw 0xaa55

