[bits 16]
; Switch to protected mode
switch_to_pm:
    cli                     ; We must switch off interupts until we have set -up the protected mode interupt vector
                            ; otherwise interupts will run riot
    lgdt [gdt_descriptor]   ; Load our global descriptor table, which defines the protected mode segments (e.g. for code and data)

    mov eax, cr0            ; To make the switch to protected mode, we set the first bit of cr0, a control register
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; Make a far jump (i.e. to a new segment) to our 32bit code. This also forces the CPU to flush its cache
                            ; pre-fetched and real-mode decoded instructions, which can cause problems 

[bits 32]
init_pm:
; Initialise registers and the stack once in PM
    mov ax, DATA_SEG        ; Now in PM, our old segments are meaningless, so we point our segment registers to the data selector 
    mov ds, ax              ; we defined in our GDT
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; Update our stack position to it is right at the top of the free space
    mov esp, ebp

    call BEGIN_PM           ; Finally call some well-known label