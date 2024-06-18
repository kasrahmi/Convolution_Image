#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c driver.c
nasm -f elf64 convolution5.asm &&
gcc -m64 -no-pie -std=c17 -o convolution5 driver.c convolution5.o asm_io.o &&
./convolution5 > convolution5_output.txt
