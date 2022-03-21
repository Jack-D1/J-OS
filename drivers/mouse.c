#include "mouse.h"
#include "../libc/function.h"
#include "../cpu/isr.h"
#include "../cpu/ports.h"
#include "screen.h"
#include "../libc/string.h"

static void mouse_callback(registers_t regs){
    // We need to check if there is any data available from the mouse to be read
    // This is achieved by recieving a byte from port 0x64 
    u8 scancode = port_byte_in(0x64);
    char scancode_str[8];
    int_to_ascii(scancode, scancode_str);
    print(scancode_str);
    // If bit 0 has value of 1, there is data from the mouse 
    if(scancode & 0x1){
        // Byte 1 from mouse packet has following bit layout 
        // Y Overflow || X Overflow || Y Sign Bit || X Sign Bit || Always 1 || Middle Btn || Right Btn || Left Btn
        u8 mouse_data = port_byte_in(0x60);
        // Byte 2 from the mouse packet is the delta of the mouse's X position
        // With left being negative and right being positive the values it can take are 
        // -256 to +255
        //u8 mouse_delta_x = port_byte_in(0x60);
        //Byte 3 from the mouse packet is the delta of the mouse's Y position
        // With down(towards user) being negative and up(away from user) being positive 
        //The values it can can take are -256 to +255
        //u8 mouse_delta_y = port_byte_in(0x60); 
        
        if(mouse_data & 0x1){
            print("Left Mouse Button clicked!");
        }else if (mouse_data & 0x10){
            print("Right mouse button clicked!");
        }

    }
    UNUSED(regs);
}

void init_mouse(){
    register_interrupt_handler(IRQ12, mouse_callback);
}