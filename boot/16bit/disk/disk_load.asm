disk_load:
    push dx ; Store dx on the stack so later we can recall how many sectors were requested to be read
    mov ah, 0x02 ; BIOS read sector function
    mov al, dh ; Read DH sectors
    mov ch, 0x00 ; Select cylinder 0
    mov dh, 0x00 ; Select head 0
    mov cl, 0x02 ; Start reading from the second sector (i.e after the boot sector)

    int 13h ; BIOS Interupt
    jc disk_error ; Jump is error (i.e if carry flag is set)
    
    

    pop dx ; Restor dx from the stack
    cmp dh, al ; IF AL (sectors read) != DH (Sectors expected) Display error
    jne disk_error
    ret
    jmp $ 
disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG: db "Disk Read Error!", 0
