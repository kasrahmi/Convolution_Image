%include "asm_io.inc"

segment .data
    n                              dq 0
    number                         dq 0
    numberSquare                   dq 0
    numberConv                     dq 0
    numberConvSquare               dq 0
    left_up_corner                 dq 0
    right_up_corner                dq 0
    left_bottom_corner             dq 0
    right_bottom_corner            dq 0
    left_up_corner_conv            dq 0
    right_up_corner_conv           dq 0
    left_bottom_corner_conv        dq 0
    right_bottom_corner_conv       dq 0
    numberConv5                    dq 0
    numberConvSquare5              dq 0
    left_up_corner5                dq 0
    right_up_corner5               dq 0
    left_bottom_corner5            dq 0
    right_bottom_corner5           dq 0
    left_up_corner_conv5           dq 0
    right_up_corner_conv5          dq 0
    left_bottom_corner_conv5       dq 0
    right_bottom_corner_conv5      dq 0
    matrix1                        dd 100 DUP(0)
    kernel                         dd 100 DUP(0)
    result_matrix                  dd 100 DUP(0)
    convolution_matrix             dd 144 DUP(0)
    new_matrix                     dd 144 DUP(0)
    dot_product_result             dq 0
    parallel_dot_product_result    dq 0 
    vector1                        dd 16  DUP(0) 
    vector2                        dd 16  DUP(0) 
    vector3                        dd 16  DUP(0)
    matrix_dot                     dd 100 DUP(0) 
    start_time_normal              dq 0 
    end_time_normal                dq 0
    start_time_parallel            dq 0
    end_time_parallel              dq 0 
    ii                             dq 0
    print_result_cross_product:    db "result cross product :", 0
    print_result_normal_product:   db "result normal dot product :", 0
    print_result_parallel_product: db "result parallel dot product :", 0
    

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

    call read_int                                   ; get the number of rows and columns of matrix
    mov [number], eax                               ; store the number in memory
    mov [n], rax                                    ; store the number in another memory because we change the other

    ; mov edi, [number]
    ; call print_float
    ; call print_nl

    imul eax, eax                                   ; square the number and store it in eax
    mov [numberSquare], eax                         ; store the numberSquare from eax to memory

    mov eax, [number]                               ; calculate n + 2 which is the size of our new matrix
    add eax, 2
    mov [numberConv], eax

    imul eax, eax                                   ; calculate (n + 2)^2 which is for our new matrix
    mov [numberConvSquare], eax

    mov eax, [number]                               ; index for main matrix right_up_corner is n
    dec eax
    mov [right_up_corner], eax

    mov eax, [numberSquare]                         ; index for main matrix left_bottom_corner is n^2 - n
    mov ebx, [number]
    sub eax, ebx
    mov [left_bottom_corner], eax

    mov eax, [numberSquare]                         ; index for main matrix right_bottom_corner is n^2 - 1
    dec eax
    mov [right_bottom_corner], eax

    mov rcx, [numberConv]                           ; index for new matrix right_up_corner_conv is nConv
    dec rcx
    mov [right_up_corner_conv], rcx

    mov rcx, [numberConvSquare]                     ; index for new matrix left_bottom_corner_conv is nConv^2 - nConv
    mov rbx, [numberConv]
    sub rcx, rbx
    mov [left_bottom_corner_conv], rcx

    mov rcx, [numberConvSquare]                     ; index for new matrix right_bottom_corner_conv is nConv^2 - 1
    dec rcx
    mov [right_bottom_corner_conv], rcx

    mov ebx, 0                                      ; counter for n^2
    mov r12, 0                                      ; counter for col main matrix
    mov r13, 0                                      ; counter for nConv^2
    mov r14, 0                                      ; counter for row main matrix

    mov r13, [numberConv]                           ; r13 = nConv + 1
    inc r13

    jmp get_matrix                                  ; jump to get_matrix method for get input and making new matrix

    matrix1_end:

        mov rax, [number]                               ; get the number and update it to new value which is 2 more
        add rax, 2
        mov [number], rax

        imul rax, rax                                   ; calculate the square number of the matrix with new n value
        mov [numberSquare], rax

        mov rax, [number]                               ; calculate n + 2 which is the size of our new matrix with new n value
        add rax, 2
        mov [numberConv], rax

        imul rax, rax                                   ; calculate (n + 2)^2 which is for our new matrix with new n value
        mov [numberConvSquare], rax

        mov rax, [number]                               ; index for new main matrix right_up_corner is n
        dec rax
        mov [right_up_corner], rax

        mov rax, [numberSquare]                         ; index for new main matrix left_bottom_corner is n^2 - n
        mov rbx, [number]
        sub rax, rbx
        mov [left_bottom_corner], rax

        mov rax, [numberSquare]                         ; index for new main matrix right_bottom_corner is n^2 - 1
        dec rax
        mov [right_bottom_corner], rax

        mov rcx, [numberConv]                           ; index for new matrix right_up_corner_conv is nConv
        dec rcx
        mov [right_up_corner_conv], rcx

        mov rcx, [numberConvSquare]                     ; index for new matrix left_bottom_corner_conv is nConv^2 - nConv
        mov rbx, [numberConv]
        sub rcx, rbx
        mov [left_bottom_corner_conv], rcx

        mov rcx, [numberConvSquare]                     ; index for new matrix right_bottom_corner_conv is nConv^2 - 1
        dec rcx
        mov [right_bottom_corner_conv], rcx

        mov rbx, 0                                      ; counter for n^2
        mov r12, 0                                      ; counter for col main matrix
        mov r13, 0                                      ; counter for nConv^2
        mov r14, 0                                      ; counter for row main matrix

        mov r13, [numberConv]                           ; r13 = nConv + 1
        inc r13

        jmp get_matrix_new

        end_matrix:

        mov ebx, 0                                          ; counter for getting kernel matrix

        jmp get_kernel                                      ; jump to method get_kernel

    kernel_end:

        mov rax, [n]                                        ; reset the value number for calculating its convloution
        mov [number], rax

        imul rax, rax                                       ; reset the value numberSquare
        mov [numberSquare], rax

        mov eax, 0                                          ; use ii in memory as a counter
        mov [ii], eax


        mov ebx, 0                                          ; counter for n^2
        mov r12, 0                                          ; counter for col main matrix
        mov r13, 0                                          ; counter for nConv^2
        mov r14, 0                                          ; counter for row main matrix
        mov r15, 0                                          ; counter for adding elements to matrix_dot matrix to multiply to kernel
        mov r13, [numberConv]
        add r13, r13
        inc r13
        inc r13                                             ; r13 = 2numberConv + 2 which is the first element of the main matrix
       
        jmp conv

    conv_end:   

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
        mov edi, result_matrix[ebx*4]                       ; move element from our matrix to edi for printing
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


get_matrix:                                                 ; method for getting our matrix and expanding it
    mov ecx, [numberSquare]                                 ; compare our counter with n^2 to finish our loop and get back to main part of program
    cmp ebx, ecx
    jge matrix1_end

    call read_float                                         ; get input element
    mov matrix1[ebx*4], eax                                 ; move input to our main matrix
    mov convolution_matrix[r13*4], eax                      ; move input to auxiliary matrix 

    cmp r12, 0                                              ; check if we are in the first col of main matrix put our input in first col auxiliary matrix
    jne r12_not_zero
    dec r13                                                 ; decrease our counter initialize our matrix then increase it again
    mov convolution_matrix[r13*4], eax
    inc r13
    r12_not_zero :

    mov rcx, [number]                                       
    dec rcx                                                 ; rcx = n - 1
    cmp r12, rcx                                            ; check if we are in the last col of main matrix put our input in last col auxiliary matrix
    jne r12_not_n_minus                                     
    inc r13                                                 ; increase our counter initialize our matrix then decrease it again
    mov convolution_matrix[r13*4], eax
    dec r13
    r12_not_n_minus :

    cmp ebx, [left_up_corner]                               ; compare if our counter is on the left_up_corner main matrix
    jne after_left_up 

    mov convolution_matrix[0], eax                          ; initialize the first element of our auxiliary matrix with first element of main matrix


    after_left_up :

    cmp ebx, [right_up_corner]                              ; compare if our counter is on the right_up_corner main matrix    
    jne after_right_up

    mov rcx, [right_up_corner_conv]                         ; initialize the right up corner element of our auxiliary matrix with right up corner element of main matrix
    mov convolution_matrix[rcx*4], eax

    after_right_up :

    cmp ebx, [left_bottom_corner]                           ; compare if our counter is on the left_bottom_corner main matrix
    jne after_left_bottom

    mov rcx, [left_bottom_corner_conv]                      ; initialize the left bottom corner element of our auxiliary matrix with left bottom corner element of main matrix
    mov convolution_matrix[rcx*4], eax

    after_left_bottom :

    cmp ebx, [right_bottom_corner]                          ; compare if our counter is on the right_bottom_corner main matrix
    jne after_right_bottom

    mov rcx, [right_bottom_corner_conv]                     ; initialize the right bottom corner element of our auxiliary matrix with right bottom corner element of main matrix
    mov convolution_matrix[rcx*4], eax

    after_right_bottom :

    cmp r14, 0                                              ; check if we are in the first row of main matrix put our input in first row auxiliary matrix
    jne not_in_first_row
    mov rcx, [numberConv]
    sub r13, rcx                                            ; first we sub nConv from our counter and initialize first row of our auxiliary matrix then resrt our counter again
    mov convolution_matrix[r13*4], eax
    add r13, rcx

    not_in_first_row:

    mov rcx, [number]                                       
    dec rcx                                                 ; rcx = n - 1
    cmp r14, rcx                                            ; check if we are in the last row of main matrix put our input in last row auxiliary matrix

    jne not_in_last_row
    mov rcx, [numberConv]
    add r13, rcx                                            ; first we add nConv from our counter and initialize first row of our auxiliary matrix then resrt our counter again
    mov convolution_matrix[r13*4], eax
    sub r13, rcx


    not_in_last_row :

    inc r12
    mov rcx, [number]
    cmp r12, rcx                                            ; compare our col counter with number of col main matirx
    jne loop_not_finished
    mov r12, 0                                              ; if col counter is equal to number reset col counter
    add r13, 2                                              ; if col counter is equal to number add 2 to counter numberConv^2 counter and 1 to row of the main matrix counter
    inc r14
    loop_not_finished :
    inc r13                                                 ; increament both of our counter
    add ebx, 1
    jmp get_matrix                                          ; jump to first part of the loop


get_matrix_new:                                             ; method for expanding our matrix and make our convolution_matrix which is bigger than normal one
    mov rcx, [numberSquare]                                 ; compare our counter with n^2 to finish our loop and get back to main part of program
    cmp rbx, rcx
    jge end_matrix

    mov eax, convolution_matrix[rbx*4]                      ; get element from our main matrix
    mov new_matrix[r13*4], eax                              ; move input to auxiliary matrix 

    cmp r12, 0                                              ; check if we are in the first col of main matrix put our input in first col auxiliary matrix
    jne r12_not_zero_new
    dec r13                                                 ; decrease our counter initialize our matrix then increase it again
    mov new_matrix[r13*4], eax
    inc r13
    r12_not_zero_new :

    mov rcx, [number]                                       
    dec rcx                                                 ; rcx = n - 1
    cmp r12, rcx                                            ; check if we are in the last col of main matrix put our input in last col auxiliary matrix
    jne r12_not_n_minus_new                                     
    inc r13                                                 ; increase our counter initialize our matrix then decrease it again
    mov new_matrix[r13*4], eax
    dec r13
    r12_not_n_minus_new :

    cmp rbx, [left_up_corner]                               ; compare if our counter is on the left_up_corner main matrix
    jne after_left_up_new 

    mov new_matrix[0], eax                                  ; initialize the first element of our auxiliary matrix with first element of main matrix


    after_left_up_new :

    cmp rbx, [right_up_corner]                              ; compare if our counter is on the right_up_corner main matrix    
    jne after_right_up_new

    mov rcx, [right_up_corner_conv]                         ; initialize the right up corner element of our auxiliary matrix with right up corner element of main matrix
    mov new_matrix[rcx*4], eax

    after_right_up_new :

    cmp rbx, [left_bottom_corner]                           ; compare if our counter is on the left_bottom_corner main matrix
    jne after_left_bottom_new

    mov rcx, [left_bottom_corner_conv]                      ; initialize the left bottom corner element of our auxiliary matrix with left bottom corner element of main matrix
    mov new_matrix[rcx*4], eax

    after_left_bottom_new :

    cmp rbx, [right_bottom_corner]                          ; compare if our counter is on the right_bottom_corner main matrix
    jne after_right_bottom_new

    mov rcx, [right_bottom_corner_conv]                     ; initialize the right bottom corner element of our auxiliary matrix with right bottom corner element of main matrix
    mov new_matrix[rcx*4], eax

    after_right_bottom_new :

    cmp r14, 0                                              ; check if we are in the first row of main matrix put our input in first row auxiliary matrix
    jne not_in_first_row_new
    mov rcx, [numberConv]
    sub r13, rcx                                            ; first we sub nConv from our counter and initialize first row of our auxiliary matrix then resrt our counter again
    mov new_matrix[r13*4], eax
    add r13, rcx

    not_in_first_row_new:

    mov rcx, [number]                                       
    dec rcx                                                 ; rcx = n - 1
    cmp r14, rcx                                            ; check if we are in the last row of main matrix put our input in last row auxiliary matrix

    jne not_in_last_row_new
    mov rcx, [numberConv]
    add r13, rcx                                            ; first we add nConv from our counter and initialize first row of our auxiliary matrix then resrt our counter again
    mov new_matrix[r13*4], eax
    sub r13, rcx


    not_in_last_row_new :

    inc r12
    mov rcx, [number]
    cmp r12, rcx                                            ; compare our col counter with number of col main matirx
    jne loop_not_finished_ne
    mov r12, 0                                              ; if col counter is equal to number reset col counter
    add r13, 2                                              ; if col counter is equal to number add 2 to counter numberConv^2 counter and 1 to row of the main matrix counter
    inc r14
    loop_not_finished_ne :
    inc r13                                                 ; increament both of our counter
    add rbx, 1
    jmp get_matrix_new                                      ; jump to first part of the loop

conv:
    mov ecx, [numberSquare]                                 ; get number^2 from memory
    mov ebx, [ii]                                           ; load counter from memory
    cmp ebx, ecx                                            ; compare counter (i) with number^2
    jge conv_end                                            ; jump to conv_end if i >= number^2


    ; r15 is our counter for filling the 5x5 matrix with center new_matrix[r13*4]
    ; r13 is the counter for iterating on the main matrix

    mov r15, 0                                              ; use new register as counter to fill matrix_dot

    sub r13, [numberConv]
    sub r13, [numberConv]
    dec r13
    dec r13                                                 ; r13' = r13 - 2nConv - 2
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax                               
    inc r13                                                 ; r13' = r13 - 2nConv - 1
    inc r15                                                 ; r15 = 1
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 - 2nConv
    inc r15                                                 ; r15 = 2
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 - 2nConv + 1
    inc r15                                                 ; r15 = 3
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 - 2nConv + 2
    inc r15                                                 ; r15 = 4
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    dec r13
    dec r13

    add r13, [numberConv]                                   ; r13' = r13 - nConv

    inc r15                                                 ; r15 = 5
    dec r13
    dec r13                                                 ; r13' = r13 - nConv - 2
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 - nConv - 1
    inc r15                                                 ; r15 = 6
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 - nConv
    inc r15                                                 ; r15 = 7
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 - nConv + 1
    inc r15                                                 ; r15 = 8
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 - nConv + 2
    inc r15                                                 ; r15 = 9
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    dec r13
    dec r13

    add r13, [numberConv]                                   ; r13' = r13

    inc r15                                                 ; r15 = 10
    dec r13
    dec r13                                                 ; r13' = r13 - 2
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 - 1
    inc r15                                                 ; r15 = 11
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13
    inc r15                                                 ; r15 = 12
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 + 1
    inc r15                                                 ; r15 = 13
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 + 2
    inc r15                                                 ; r15 = 14
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    dec r13
    dec r13

    add r13, [numberConv]                                   ; r13' = r13 + nConv

    inc r15                                                 ; r15 = 15
    dec r13
    dec r13                                                 ; r13' = r13 + nConv - 2
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 + nConv - 1
    inc r15                                                 ; r15 = 16
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 + nConv
    inc r15                                                 ; r15 = 17
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 + nConv + 1
    inc r15                                                 ; r15 = 18
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 + nConv + 2
    inc r15                                                 ; r15 = 19
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    dec r13
    dec r13

    add r13, [numberConv]                                   ; r13' = r13 + 2nConv

    inc r15                                                 ; r15 = 20
    dec r13
    dec r13                                                 ; r13' = r13 + 2nConv - 2
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 + 2nConv - 1
    inc r15                                                 ; r15 = 21
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 + 2nConv
    inc r15                                                 ; r15 = 22
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax 
    inc r13                                                 ; r13' = r13 + 2nConv + 1
    inc r15                                                 ; r15 = 23
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    inc r13                                                 ; r13' = r13 + 2nConv + 2
    inc r15                                                 ; r15 = 24
    mov eax, new_matrix[r13*4]                              ; load element with index r13 from convolution matrix in index r15 matrix_dot 
    mov matrix_dot[r15*4], eax
    dec r13
    dec r13

    sub r13, [numberConv]
    sub r13, [numberConv]                                   ; reset r13 to its previous value

     push r12
    push r13
    push r14
    push r15

    mov r12, 25                                             ; use r12 as number for the loop
    mov r13, 0                                              ; use r13, r14, r15 as counters
    mov r14, 0
    mov r15, 0

    mov eax, 0                                              ; reset the value of parallel_dot_product_result to zero
    mov [parallel_dot_product_result], eax

    jmp parallel_dot_product                                ; jump to the method for calculating the dot product matrix_dot and kernel

    finish_parallel_dot_product:

    mov eax, [parallel_dot_product_result]                  ; move the value we calculated to our final matrix
    mov result_matrix[ebx*4], eax

    pop r15
    pop r14
    pop r13
    pop r12

    inc r12                                                 ; add our counter for the col
    mov rcx, [number]                                       ; load value number from memory to rcx
    cmp r12, rcx                                            ; if we are in the last col reset the col counter
    jne loop_not_finished_new
    mov r12, 0                                              ; reset col counter to 0
    add r13, 4                                              ; add 4 to our counter
    inc r14                                                 ; increase row counter
    loop_not_finished_new :
    inc r13
    mov ebx, [ii]                                           ; load counter to ebx and increase it
    add ebx, 1
    mov [ii], ebx
    jmp conv                                                ; jump to first part of the method


parallel_dot_product:
    mov eax, 0                                              ; load zero to eax to add values of dot product to it for calculating

    parallel_mul_dot:
        mov r14, 0
        mov r15, 0

        movups xmm0, matrix_dot[r13*4]
        movups xmm1, kernel[r13*4]


        mulps xmm0, xmm1                                    ; parallel dot product 4 numbers of matrix
        haddps xmm0, xmm0
        haddps xmm0, xmm0


        movups [vector3], xmm0                              ; store value of dot product in vector3

        mov ecx, vector3[0]                                 ; add the new calculated value with temp one that stored in memory

        movd xmm0, eax                                      ; load temp value to xmm0
        movd xmm1, ecx                                      ; load the new calculated value to xmm1
        addss xmm0, xmm1                                    ; calculate sum xmm0 and xmm1

        movd eax, xmm0                                      ; mov sum eax and ecx to eax
        
        add r13, 4                                          ; add counter 4 because we read four values from matrix

        cmp r12, r13                                        ; compare our counter with 9 if our counter is below it jump to the first part of the loop
        jg parallel_mul_dot

    mov [parallel_dot_product_result], eax                  ; load the value to parallel_dot_product_result in memory

    jmp finish_parallel_dot_product                         ; jump back to the main part of our program


get_kernel:                                                 ; get kernel 3x3
    mov ecx, 25                                              
    cmp ebx, ecx                                            ; compare ebx counter with 9
    jge kernel_end

    call read_float                                         ; read inputs and move to our kernel
    mov kernel[ebx*4], eax

    add ebx, 1                                              ; increament counter
    jmp get_kernel


