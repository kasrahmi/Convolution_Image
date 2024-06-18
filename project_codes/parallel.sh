#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c driver.c
nasm -f elf64 cross_parallel.asm &&
gcc -m64 -no-pie -std=c17 -o cross_parallel driver.c cross_parallel.o asm_io.o &&
./cross_parallel > cross_parallel_output.txt
