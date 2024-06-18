%include "asm_io.inc"

segment .data
    temporary                            dq 0
    numberExpanded                       dq 0
    numberExpandedSquare                 dq 0
    number                               dq 0
    numberSquare                         dq 0
    matrix1                              dd 4000000 DUP(0)
    matrix2                              dd 4000000 DUP(0)
    ; result_matrix                        dd 4000000 DUP(0)
    ; convolution_matrix                   dd 1000000 DUP(0)
    dot_product_result                   dq 0
    parallel_dot_product_result          dq 0 
    vector1                              dd 16  DUP(0) 
    vector2                              dd 16  DUP(0) 
    vector3                              dd 16  DUP(0) 
    cross_product_parallel_result        dd 4000000 DUP(0)
    new_matrix1                          dd 4000000 DUP(0)
    new_matrix2                          dd 4000000 DUP(0)
    start_time_normal                    dq 0 
    end_time_normal                      dq 0
    start_time_parallel                  dq 0
    end_time_parallel                    dq 0 
    time                                 dq 1
    print_result_cross_product:          db "result cross product normal :", 0
    print_result_cross_product_parallel: db "result cross product parallel :", 0
    print_result_normal_product:         db "result normal dot product :", 0
    print_result_parallel_product:       db "result parallel dot product :", 0
    time_parallel                        db "Time calculating parallel cross in ms :", 0

    

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

    call read_int                                           ; get the number of rows and columns of matrix
    mov [number], eax                                       ; store the number in memory

    imul eax, eax                                           ; square the number and store it in eax
    mov [numberSquare], eax                                 ; store the numberSquare from eax to memory

    mov ebx, 0                                              ; ebx is counter for getting matrix

    jmp get_matrix1                                         ; jump to the function for getting first matrix

    matrix1_end:                                            ; label for program to get back from get_matrix1

    mov ebx, 0                                              ; ebx is counter for getting matrix

    jmp get_matrix2                                         ; jump to the function for getting second matrix

    matrix2_end:                                            ; label for program to get back from get_matrix2


        mov r13, 3                                          ; initialize r13
        mov r14, 4                                          ; initialize r14

        mov rax, [number]                                   ; move number to our rax
        mov [numberExpanded], rax                           ; move number from rax to the numberExpanded 
        and rax, r13                                        ; and rax and r13

        jz end_expansion                                    ; end the expansion if and rax and r13 set flag zero

        sub rax, r14                                        ; sub r14 from rax
        neg rax                                             ; Replaces the value of rax with its two's complement
        add [numberExpanded], rax                           ; add rax to numberExpanded

        mov r12, [numberExpanded]                           ; move numberExpanded to r12
        imul r12, r12                                       ; square r12
        mov [numberExpandedSquare], r12                     ; move the value we calculate to numberExpandedSquare

        end_expansion:                                      ; label for finishing end_expansion if and number and numberExpanded set flag zero

        jmp make_new_matrix1                                ; jump to make_new_matrix1 method 

        end_first_loop_matrix1:                             ; label for getting back from make_new_matrix1 method

        jmp make_new_matrix2                                ; jump to make_new_matrix2 method 

        end_first_loop_matrix2:                             ; label for getting back from make_new_matrix2 method

        call sys_gettimeofday_ms
        mov [start_time_normal], rax

        loop_million :

        jmp cross_product_parallel                          ; jump to cross_product_parallel

        end_cross_loop_parallel:                            ; label for getting back from cross_product_parallel method



    finish_multiply:                                        ; label for program to get back from mul_matrix

        mov rcx, [time]
        dec rcx
        mov [time], rcx

        cmp rcx, 0
        jge loop_million

        mov rdi, time_parallel                              ; move string time_parallel to rdi for printing
        call print_string                                   ; print the string which is in rdi

        call sys_gettimeofday_ms
        mov rdi, rax
        sub rdi, [start_time_normal]
        call print_int
        call print_nl

        mov rdi, print_result_cross_product_parallel        ; move string result_cross_product to rdi for printing
        call print_string                                   ; print the string which is in rdi
        mov ebx, 0                                          ; counter for printing matrix which compare with n^2
        mov r12, 0                                          ; counter for printing matrix which compare with n
    print_result:                                           ; label for using as loop
        mov ecx, [numberSquare]                             ; mov n^2 in ecx
        cmp ebx, ecx                                        ; compare ebx counter with n^2
        jge print_result_end                                ; if ebx is greater than or equal to n^2
        mov r13, [number]                                   ; mov number in r13
        cmp r13, r12                                        ; compare r12 counter with number
        jg continue                                         ; if r12 is lower than number it jumps to continue label
        mov r12, 0                                          ; reset r12 to 0 again
        call print_nl                                       ; print new line when we print n elements
    continue:                                               ; label for not printing new line 
        mov edi, cross_product_parallel_result[ebx*4]       ; move element from our matrix to edi for printing
        call print_float                                    ; print our element which is in edi
        mov rdi, 32                                         ; mov space using its ascci to rdi
        call print_char                                     ; call print_char for printing space which is in rdi

        add ebx, 1                                          ; increase counters
        add r12, 1
        jmp print_result                                    ; jump to first of the loop for printing other elements

    print_result_end:                                       ; label for finishing our printing
        call print_nl                                       ; print new line for clarify our output



    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret


get_matrix1:                                                            ; method getting first matrix
    mov ecx, [numberSquare]                                             ; move n^2 to ecx for comparing to our counter
    cmp ebx, ecx                                                        ; compare counter with n^2
    jge matrix1_end                                                     ; if counter get to n^2 it jump out from method

    call read_float                                                     ; read element from user input
    mov matrix1[ebx*4], eax                                             ; move the input element in our matrix

    add ebx, 1                                                          ; increase counter
    jmp get_matrix1                                                     ; jump to first point of the loop

get_matrix2:                                                            ; method getting second matrix
    mov ecx, [numberSquare]                                             ; move n^2 to ecx for comparing to our counter
    cmp ebx, ecx                                                        ; compare counter with n^2
    jge matrix2_end                                                     ; if counter get to n^2 it jump out from method

    call read_float                                                     ; read element from user input
    mov matrix2[ebx*4], eax                                             ; move the input element in our matrix

    add ebx, 1                                                          ; increase counter
    jmp get_matrix2                                                     ; jump to first point of the loop



make_new_matrix1:
    
    mov r12, 0                                                          ; Initialize first loop counter (i)
    first_loop_matrix1:
        
        mov rax, [number]                                               ; Check if first counter has reached n
        cmp r12, rax
        je end_first_loop_matrix1
        
        mov r13, 0                                                      ; Initialize second loop counter (j)
        second_loop_matrix1:
        
            mov rax, [number]                                           ; Check if second counter has reached n
            cmp r13, rax
            je continue_first_loop_matrix1

            mov r14, [number]                                           ; Calculate indices for the prior and expanded matrices
            imul r14, r12
            add r14, r13

            mov r15, [numberExpanded]
            imul r15, r12
            add r15, r13

            mov ebx, matrix1[r14*4]                                     ; Initialize the expanded matrix
            mov new_matrix1[r15*4], ebx

            
            add r13, 1                                                  ; Increment second counter
            jmp second_loop_matrix1

        continue_first_loop_matrix1:

        add r12, 1                                                      ; Increment first counter
        jmp first_loop_matrix1

make_new_matrix2:
    
    mov r12, 0                                                          ; Initialize first loop counter (i)
    first_loop_new_matrix2:
        
        mov rax, [number]                                               ; Check if first counter has reached n
        cmp r12, rax
        je end_first_loop_matrix2

        mov r13, 0                                                      ; Initialize second loop counter (j)
        second_loop_new_matrix2:
            
            mov rax, [number]                                           ; Check if second counter has reached n
            cmp r13, rax
            je continue_first_loop_new_matrix2

            mov r14, [number]                                           ; Calculate indices for the prior and expanded matrices
            imul r14, r13
            add r14, r12

            mov r15, [numberExpanded]
            imul r15, r12
            add r15, r13

            mov ebx, matrix2[r14*4]                                     ; Initialize the expanded matrix
            mov new_matrix2[r15*4], ebx

            add r13, 1                                                  ; Increment second counter
            jmp second_loop_new_matrix2

        continue_first_loop_new_matrix2:

        add r12, 1                                                      ; Increment first counter
        jmp first_loop_new_matrix2

cross_product_parallel:

    mov rax, [number]                                                   ; Initialize first loop counter (i), second loop counter (j), and third loop counter (k)
    mov rdx, [numberExpanded]
    mov r12, 0
    first_cross_loop_parallel:

        mov r13, 0                                                      ; Initialize second loop counter (j)
        second_cross_loop_parallel:

            mov qword [temporary], 0                                    ; Initialize temporary variable for cross product calculation
            
            mov r14, 0                                                  ; Initialize third loop counter (k)
            third_cross_loop:

                mov rbx, r12                                            ; Generate indices for the expanded matrices
                imul rbx, rdx   
                add rbx, r14

                mov rcx, r13
                imul rcx, rdx
                add rcx, r14

                movups xmm0, new_matrix1[rbx*4]                         ; Load four elements of the matrix1 and matrix2 to xmm0 and xmm1
                movups xmm1, new_matrix2[rcx*4]

                ; dpps xmm0, xmm1, 0xF1                                 ; Multiply the four elements in parallel

                mulps xmm0, xmm1                                        ; Multiply the four elements in parallel
                haddps xmm0, xmm0
                haddps xmm0, xmm0

                addss xmm0, [temporary]                                 ; Add the result to the temporary variable
                movss [temporary], xmm0

                add r14, 4                                              ; Increment third counter

                cmp r14, rdx                                            ; Check if third counter has reached the expanded size
                jge continue_cross_second_loop

                jmp third_cross_loop

            continue_cross_second_loop:
            
            mov rbx, r12                                                ; Generate index for storing the result in the cross_product_parallel_result matrix
            imul rbx, rax
            add rbx, r13

            movss xmm1, [temporary]                                     ; Store the result in the cross_product_parallel_result matrix
            movss cross_product_parallel_result[rbx*4], xmm0

            add r13, 1                                                  ; Increment second counter

            cmp r13, rax                                                ; Check if second counter has reached n
            jge continue_cross_first_loop

            jmp second_cross_loop_parallel

        continue_cross_first_loop:
        add r12, 1                                                      ; Increment first counter

        cmp r12, rax                                                    ; Check if first counter has reached n
        jge end_cross_loop_parallel

        jmp first_cross_loop_parallel

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