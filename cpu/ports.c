#include "ports.h"

u8 port_byte_in(u16 port){
    /*
    A handy c wrapper function that reads a byte from the specified port
    "=a" (result) means: put AL register in variable RESULT when finished
    "d" (port) means: load EDX with port
    */
    u8 result;
    __asm__ ("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void port_byte_out(u16 port, u8 data){
    // "a" (data) means: load EAX with data
    // "d" (port) means: load EDX with port
    __asm__ __volatile__("out %%al, %%dx" : :"a" (data), "d" (port));
}
u16 port_word_in(u16 port){
    u16 result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

void port_word_out(u16 port, u16 data){
    __asm__ __volatile__("out %%ax, %%dx" : :"a" (data), "d" (port));
}