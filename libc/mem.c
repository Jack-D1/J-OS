#include "mem.h"

// Copy bytes from ine place to another
void memory_copy(u8* source, u8* dest, int no_bytes){
    for(int i = 0; i<no_bytes; i++){
        *(dest + i) = *(source + i);
    }
}

void memory_set(u8* dest, u8 val, u32 len){
    u8* temp = (u8 *)dest;
    for( ; len !=0; len--) *temp++ = val;
}

//This should be computed at link time, but a hardcoded value is fine for now 
// Remember our kernel starts at 0x1000 as defined in the Makefile 
u32 free_mem_addr = 0x10000;

// Implementation is just a pointer to some free memory which keeps growing 
u32 malloc(u32 size, int align, u32* phys_addr){
    //Pages are aligned to 4K or 0x1000
    if(align == 1 && (free_mem_addr & 0xFFFFF000)){
        free_mem_addr &= 0xFFFFF000;
        free_mem_addr += 0x1000;
    }

    //Also save the physical address 
    if(phys_addr) *phys_addr = free_mem_addr;
    u32 ret = free_mem_addr;
    free_mem_addr += size; // Remember to increment the pointer 
    return ret;
}