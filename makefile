# Automatically Expand to a list of existing files that match the patterns 
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h libc/*.h)

#Convert the *.c filenames to *.o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o} 

CFLAGS = -g -fno-pie -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs \
			-Wall -Wextra -Werror

# Default make target
all: os-image

# Run qemu to simulate the botting of our code
run: all
	qemu-system-i386.exe -drive format=raw,file=os-image,if=floppy

# Actual OS Image that the computer loads which is a combination of the 
# compiled bootsector and kernel 
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of the kernel from two object files:
#  - The kernel_entry which jumps to main() in our kernel
#  - The compiled C kernel
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to an object file
# For simplicity C files depend on all header files 
%.o : %.c ${HEADERS}
	gcc ${CFLAGS} -ffreestanding -c $< -o $@

# Build the kernel entry object file
%.o : %.asm
	nasm $< -f elf -o $@ 


%.bin : %.asm
	nasm $< -f bin -I 'boot/16bit/' -o $@

# Clear away generated files 
clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o cpu/*.o libc/*.o

# Dissassemble our kernel - might be useful for debugging
kernel.dis : kernel.bin	
	ndisasm -b 32 $< > $@