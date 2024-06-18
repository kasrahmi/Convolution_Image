%include "asm_io.inc"

segment .data
    temp                           dq 0
    numberExpanded                 dq 0
    numberExpandedSquare           dq 0
    number                         dq 0
    numberSquare                   dq 0
    matrix1                        dd 4000000 DUP(0)
    matrix2                        dd 4000000 DUP(0)
    result_matrix                  dd 4000000 DUP(0)
    ; convolution_matrix             dd 4000000 DUP(0)
    dot_product_result             dq 0
    parallel_dot_product_result    dq 0 
    vector1                        dd 16  DUP(0) 
    vector2                        dd 16  DUP(0) 
    vector3                        dd 16  DUP(0) 
    ; cross_product_parallel_result  dd 1000000 DUP(0)
    ; new_matrix1                    dd 1000000 DUP(0)
    ; new_matrix2                    dd 1000000 DUP(0)
    start_time_normal              dq 0 
    end_time_normal                dq 0
    start_time_parallel            dq 0
    end_time_parallel              dq 0
    time                           dq 1
    print_result_cross_product:    db "result cross product normal :", 0
    print_result_normal_product:   db "result normal dot product :", 0
    print_result_parallel_product: db "result parallel dot product :", 0
    time_normal                    db "Time calculating normal cross in ms :", 0
    

segment .text

global asm_main

asm_main:

	push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15

    sub rsp, 8

    call read_int           ; get the number of rows and columns of matrix
    mov [number], eax       ; store the number in memory

    imul eax, eax           ; square the number and store it in eax
    mov [numberSquare], eax ; store the numberSquare from eax to memory

    mov ebx, 0              ; ebx is counter for getting matrix

    jmp get_matrix1         ; jump to the function for getting first matrix

    matrix1_end:            ; label for program to get back from get_matrix1

    mov ebx, 0              ; ebx is counter for getting matrix

    jmp get_kernel         ; jump to the function for getting second matrix

    matrix2_end:            ; label for program to get back from get_matrix2
    
    call sys_gettimeofday_ms
    mov [start_time_normal], rax

    million_loop :

    mov eax, 0              ; elements from matrix1 store in eax in multiplying
    mov ebx, 0              ; elements from matrix2 store in ebx in multiplying
    mov r13, 0              ; counter first loop in multiplying
    mov r14, 0              ; counter second loop in multiplying
    mov r15, 0              ; counter third loop in multiplying


    jmp mul_matrix          ; jump to the function mul_matrix

    finish_multiply:                        ; label for program to get back from mul_matrix

    mov rcx, [time]
    dec rcx
    mov [time], rcx

    cmp rcx, 0
    jg million_loop

    mov rdi, time_normal                                ; move string time_normal to rdi for printing
    call print_string                                   ; print the string which is in rdi

    call sys_gettimeofday_ms
    mov rdi, rax
    sub rdi, [start_time_normal]
    call print_int
    call print_nl

        mov rdi, print_result_cross_product ; move string result_cross_product to rdi for printing
        call print_string                   ; print the string which is in rdi
        mov ebx, 0                          ; counter for printing matrix which compare with n^2
        mov r12, 0                          ; counter for printing matrix which compare with n
    print_result:                           ; label for using as loop
        mov ecx, [numberSquare]             ; mov n^2 in ecx
        cmp ebx, ecx                        ; compare ebx counter with n^2
        jge print_result_end                ; if ebx is greater than or equal to n^2
        mov r13, [number]                   ; mov number in r13
        cmp r13, r12                        ; compare r12 counter with number
        jg continue                         ; if r12 is lower than number it jumps to continue label
        mov r12, 0                          ; reset r12 to 0 again
        call print_nl                       ; print new line when we print n elements
    continue:                               ; label for not printing new line 
        mov edi, result_matrix[ebx*4]       ; move element from our matrix to edi for printing
        call print_float                    ; print our element which is in edi
        mov rdi, 32                         ; mov space using its ascci to rdi
        call print_char                     ; call print_char for printing space which is in rdi

        add ebx, 1                          ; increase counters
        add r12, 1
        jmp print_result                    ; jump to first of the loop for printing other elements

    print_result_end:                       ; label for finishing our printing
        call print_nl                       ; print new line for clarify our output


    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret


get_matrix1:                ; method getting first matrix
    mov ecx, [numberSquare] ; move n^2 to ecx for comparing to our counter
    cmp ebx, ecx            ; compare counter with n^2
    jge matrix1_end         ; if counter get to n^2 it jump out from method

    call read_float         ; read element from user input
    mov matrix1[ebx*4], eax ; move the input element in our matrix

    add ebx, 1              ; increase counter
    jmp get_matrix1         ; jump to first point of the loop

get_kernel:                ; method getting second matrix
    mov ecx, [numberSquare] ; move n^2 to ecx for comparing to our counter
    cmp ebx, ecx            ; compare counter with n^2
    jge matrix2_end         ; if counter get to n^2 it jump out from method

    call read_float         ; read element from user input
    mov matrix2[ebx*4], eax ; move the input element in our matrix

    add ebx, 1              ; increase counter
    jmp get_kernel         ; jump to first point of the loop

mul_matrix:                 ; method multiply matrix
    multiply_loop1:         ; label for the first loop
        mov r14, 0          ; reset counter for the second loop
        multiply_loop2:     ; label for the scond loop
            mov r15, 0      ; reset counter for the third loop
            multiply_loop3: ; label for the third loop
                mov r12, [number]   ; move number to r12 register
                mov rcx, r12        ; move n from r12 to rcx
                imul rcx, r13       ; multiply rcx in counter of the first loop
                add rcx, r15        ; add counter of the third loop in rcx -> rcx = i * n + k
                mov eax, matrix1[rcx*4] ; move element from matrix1 with index rcx to eax

                mov rcx, r12        ; move n from r12 to rcx
                imul rcx, r15       ; multiply rcx in counter of the third loop
                add rcx, r14        ; add counter of the second loop in rcx -> rcx = k * n + j
                mov ebx, matrix2[rcx*4] ; move element from matrix1 with index rcx to eax

                mov rcx, r12        ; move n from r12 to rcx
                imul rcx, r13       ; multiply rcx in counter of the first loop
                add rcx, r14        ; add counter of the second loop in rcx -> rcx = i * n + j
                movd xmm0, eax      ; move element from eax to xmm0
                movd xmm1, ebx      ; move element from ebx to xmm1
                mulss xmm0, xmm1    ; multiply elements and store them in xmm0
                movd eax, xmm0      ; move the value from xmm0 to eax

                
                
                mov ebx, result_matrix[rcx*4]   ; get the element which is now in result_matrix with index rcx

                movd xmm0, eax      ; move eax which is the multiply of elements to xmm0
                movd xmm1, ebx      ; move ebx which is now in result_matrix to xmm1
                addss xmm0, xmm1    ; add value of xmm1 to xmm0
                movd eax, xmm0      ; move xmm0 to eax

                ;add eax, ebx
            
                mov result_matrix[rcx*4], eax   ; store eax in result_matrix

                

                inc r15              ; increase r15
                cmp r12, r15         ; compare our third counter with n
                jg multiply_loop3    ; jump to first of the third loop

            inc r14                  ; increase r14
            cmp r12, r14             ; compare our second counter with n
            jg multiply_loop2        ; jump to first of the second loop
        
        inc r13                      ; increase r13
        cmp r12, r13                 ; compare our first counter with n
        jg multiply_loop1            ; jump to first of the first loop
    jmp finish_multiply              ; jump from our method to our main part of the program



sys_gettimeofday_ms:

  push rbp                                         
    push rbx                                         
    push r12                                         
    push r13                                       
    push r14                                        
    push r15 

    sub rsp, 8

    mov rax, 96
    lea rdi, [rsp - 16]
    xor esi, esi
    syscall
    mov ecx, 1000
    mov rax, [rdi + 8]
    xor edx, edx
    div rcx
    mov rdx, [rdi]
    imul rdx, rcx
    add rax, rdx

    add rsp, 8

    pop r15  
    pop r14  
    pop r13  
    pop r12  
    pop rbx  
    pop rbp  

    ret