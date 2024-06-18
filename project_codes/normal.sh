#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c driver.c
nasm -f elf64 cross_normal.asm &&
gcc -m64 -no-pie -std=c17 -o cross_normal driver.c cross_normal.o asm_io.o &&
./cross_normal > cross_normal_output.txt
