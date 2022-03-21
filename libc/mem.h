#ifndef MEM_H
#define MEM_H

#include "../cpu/types.h"

void memory_copy(u8* source, u8* dest, int no_bytes);
void memory_Set(u8* dest, u8 val, u32 len);

//At this stage there is no 'free' implemented 
u32 malloc(u32 size, int align, u32* phys_addr);

#endif