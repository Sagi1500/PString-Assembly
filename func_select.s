# Sagi Wilentzik
#func_select.s

    .text # Creating formats for strings.
    format1:    .string "invalid option!\n"  # string for the case that the input in out of bound.
    format11:   .string "invalid input!\n" 
    formatScanChar:     .string "%s"
    formatScanNumber:   .string "%d"
    format3:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n" 
    format2:    .string "first pstring length: %d, second pstring length: %d\n" # string for pstrlen. 
    format6:    .string "compare result: %d\n"
    format5:    .string "length: %d, string: %s\n"
    
        # Building the jump table
    .align 8 # Align address to multiple of 8.
.L10:
    .quad   .L5060 # case 50 or 60
    .quad   .Ld  # Csase 51 - go to defult.
    .quad   .L52   # Case 52.
    .quad   .L53    # Case 53.
    .quad   .L54    # Case 54.
    .quad   .L55    # Case 55.
    .quad   .Ld    # Case 56 - go to defult.
    .quad   .Ld    # Case 57 - go to defult
    .quad   .Ld    # Case 58 - go to defult
    .quad   .Ld    # Case 59 - go to defult.
    .quad   .L5060 # case 50 or 60

.L5060:  # lable for input 50 or 60. 
    
    leaq   (%rsi), %r12    #save first string in r12
    leaq   (%rdx), %r13    #save second string in r13
    leaq    (%r12), %rdi 
    call    pstrlen # call to funciton pstrlen.

    leaq    (%rax), %r12  # save the first string length in r12

    leaq    (%r13), %rdi  
    call    pstrlen #call the function with the second string.


    movq    %r12, %rsi  #save first string length in rsi.
    leaq    (%rax), %r13  # save second string length in r13.
    movq    %r13, %rdx
    movq    $format2, %rdi # save format in rdi
    xorq    %rax, %rax
    call    printf 

    popq    %r13    # return r13 his original value.
    popq    %r12    # return r12 his original value.
    movq    %rbp,%rsp
    popq    %rbp
    ret   
    
.L52:    # lable for input 52.
    leaq   (%rsi), %r12    #save first string in r12
    leaq   (%rdx), %r13    #save second string in r13
    
    # read the first char from usem.
    movq    $formatScanChar, %rdi   # save string in rdi register.
    leaq    128(%rsp), %rsi # insert the address to rsi register.
    xorq    %rax, %rax  # make rax register 0.
    call    scanf

    # read the second char from user.
    movq    $formatScanChar, %rdi #insert the string format to rdi register.
    leaq    160(%rsp), %rsi # insert the address to rsi register.
    xorq    %rax, %rax  # make rax register 0.
    call    scanf

    leaq    (%r12), %rdi    # save first string in %rdi.
    leaq    (%r13), %rsi    # save second string in %rsi.
    leaq    128(%rsp), %rsi     # save the old char in rsi.
    leaq    160(%rsp), %rdx      # save the second number in rdx.

    call replaceChar    # call to replaceChar with first string.
    
    leaq    (%rax), %r12    # save the new string (for the first one) in r12.

    leaq    (%r13), %rdi        # save the second string in rdi.
    leaq    128(%rsp), %rsi     # save the old char in rsi.
    leaq    160(%rsp), %rdx      # save the second number in rdx.

    call    replaceChar    # call to replaceChar with second string.
    leaq    (%rax), %r13    # save the new string (for the second one) in r13

    movq    $format3, %rdi      # save the string format in rdi 
    leaq    128(%rsp), %rsi     # save the old char in rsi.
    movq    (%rsi), %rsi 
    leaq    160(%rsp), %rdx     # save the second number in rdx.
    movq    (%rdx), %rdx
    leaq    1(%r12), %rcx        # save the first string in rcx
    leaq    1(%r13), %r8         # save the second string in r8 

    xorq    %rax, %rax  #make rax zero
    call    printf 


    popq    %r13    # return r13 his original value.
    popq    %r12    # return r12 his original value.
    movq    %rbp,%rsp
    popq    %rbp
    ret  

.L53:    # lable for input 53.
    leaq   (%rsi), %r12    #save first string in r12
    leaq   (%rdx), %r13    #save second string in r13
    
    # read the first number from usem.
    movq    $formatScanNumber, %rdi   # save string in rdi register.
    leaq    128(%rsp), %rsi # insert the address to rsi register.
    xorq    %rax, %rax  # make rax register 0.
    call    scanf

    # read the second number from user.
    movq    $formatScanNumber, %rdi #insert the string format to rdi register.
    leaq    160(%rsp), %rsi # insert the address to rsi register.
    xorq    %rax, %rax  # make rax register 0.
    call    scanf

    leaq    (%r12), %rdi    # save first string in %rdi.
    leaq    (%r13), %rsi    # save second string in %rsi.
    leaq    128(%rsp), %rdx     # save the first number in rdx.
    leaq    160(%rsp), %rcx      # save the second number in rcx.

    movzbq  (%rdi), %r12 # save the first string length in r12.
    movzbq  (%rsi), %r13 # save the second string length in r13.
    
    xorq     %r8, %r8
    xorq     %r9, %r9 
    movb     (%rdx), %r8b   # save start index (i) in r8b
    movb     (%rcx), %r9b   # save end index (j) in r9b
    cmpb     %r12b, %r8b   # check if the starting index is bigger than length.
    jg      .L53invalidInput 
    cmpb     %r13b, %r9b    # checking if the end index  is bigger than length.
    jge      .L53invalidInput
    cmpb     %r12b, %r9b
    jg      .L53invalidInput 
    cmpb     %r13b, %r8b 
    jge       .L53invalidInput
    cmpb     $0, %r8b  # checking if starting index is negative.
    jl      .L53invalidInput 
    cmpb     $0, %r9b  # checking if the end index in negative.
    jl      .L53invalidInput 
    cmpb     %r8b, %r9b  #checking if i > j
    jl      .L53invalidInput 
    jmp     .L53Call
    
.L53invalidInput: # This lable will print the value when the input is invalid.
    leaq    (%rdi), %r12 # save first string in r12
    leaq     (%rsi), %r13   # save second string in r13

    movq    $format11, %rdi  # invalid input format
    xorq    %rax, %rax
    call    printf

    movq    $format5, %rdi  # save the format in rdi
    movzbq  (%r12), %rsi     #save the string length in rsi
    leaq    1(%r12), %rdx      #save the string in rdx
    xorq    %rax, %rax 
    call    printf  

    movq    $format5, %rdi  # save the format in rdi
    movzbq  (%r13) , %rsi     #save the string length in rsi
    leaq    1(%r13), %rdx      #save the string in rdx
    xorq    %rax, %rax 
    call    printf  
    
    jmp     .L1

.L53Call:    
    call pstrijcpy  # call to function pstrijcpy.
    popq    %r13    # return r13 his original value.
    popq    %r12    # return r12 his original value.
    movq    %rbp,%rsp
    popq    %rbp
    ret
  

.L54:    # lable for input 54.

    leaq   (%rsi), %r12    #save first string in r12
    leaq   (%rdx), %r13    #save second string in r13
    
    leaq    (%r12), %rdi    #save first string in rdi
    call swapCase    # call to function swapCase.

    leaq    (%r13), %rdi    # save the secons string in rdi
    call swapCase   # call to swapCase with second string.
    
    popq    %r13    # return r13 his original value.
    popq    %r12    # return r12 his original value.
    movq    %rbp,%rsp
    popq    %rbp 
    ret 
      
    
.L55:    # lable for input 55.

    leaq   (%rsi), %r12    #save first string in r12
    leaq   (%rdx), %r13    #save second string in r13
    
    # read the first number from usem.
    movq    $formatScanNumber, %rdi   # save string in rdi register.
    leaq    128(%rsp), %rsi # insert the address to rsi register.
    xorq    %rax, %rax  # make rax register 0.
    call    scanf

    # read the second number from user.
    movq    $formatScanNumber, %rdi #insert the string format to rdi register.
    leaq    160(%rsp), %rsi # insert the address to rsi register.
    xorq    %rax, %rax  # make rax register 0.
    call    scanf

    leaq    (%r12), %rdi    # save first string in %rdi.
    leaq    (%r13), %rsi    # save second string in %rsi.
    leaq    128(%rsp), %rdx     # save the first number in rdx.
    leaq    160(%rsp), %rcx      # save the second number in rcx.

    movzbq  (%rdi), %r12 # save the first string length in r12.
    movzbq  (%rsi), %r13 # save the second string length in r13.

    xorq     %r8, %r8   # make r8 zero.   
    xorq     %r9, %r9   # make r9 zero.
    movb     (%rdx), %r8b   # save start index (i) in r8b
    movb     (%rcx), %r9b   # save end index (j) in r9b
    cmpb     %r12b, %r8b   # check if the starting index is bigger than length.
    jg      .L55InvalidInput 
    cmpb     %r13b, %r9b    # checking if the end index  is bigger than length.
    jg      .L55InvalidInput 
    cmpb    %r12b, %r9b
    jg      .L55InvalidInput 
    cmpb    %r13b, %r8b
    jg      .L55InvalidInput 
    cmpb     $0, %r8b  # checking if starting index is negative.
    jl      .L55InvalidInput 
    cmpb     $0, %r9b  # checking if the end index in negative.
    jl      .L55InvalidInput 
    cmpb     %r8b, %r9b  #checking if i > j
    jl      .L55InvalidInput 
    

   
    call    pstrijcmp  # call to function pstrijcpy.
    movq    $format6, %rdi # insert the format to rdi
    movq    %rax, %rsi # insert the result to rsi.
    xorq    %rax, %rax  # make rax zero.
    call    printf 

    jmp    .L1 

.L55InvalidInput:    
    movq    $format11, %rdi  # invalid input format
    xorq    %rax, %rax
    call    printf

    movq    $format6, %rdi  # print the -2 value.
    movq    $-2, %rsi
    xorq    %rax, %rax
    call    printf 

    popq    %r13    # return r13 his original value.
    popq    %r12    # return r12 his original value.
    movq    %rbp,%rsp
    popq    %rbp
    ret

.Ld:    # lable for defult.
    movq    $format1,%rdi  # insert the string  "invalid option!\n" to rdi register.
    call    printf  # Call to printf function.
    jmp .L1  

.L1: # lable for exit from the switch case options.
    popq    %r13
    popq    %r12 
    movq    %rbp,%rsp
    popq    %rbp
    ret


      	.text	 # creating the run_func function.
.global run_func
    .type run_func, @function  #  The function will recieve the option from the switch case and returns
    # the rigth fucntion.   
run_func:
     pushq   %rbp    # push rbp to stack
     movq    %rsp, %rbp  # move rsp to rbs
     sub    $256, %rsp
     leaq   (%rsp), %r12 # save r12 register in stack
     leaq   64(%rsp), %r13 # save r13 register in stack
   
     leaq    -50(%rdi),%rcx  # reduce the address by 50 that we could find the correct adress for the functions.
     cmpq    $10,%rcx    # checking if the number if greater than 10, which means that the argument is greate than 60.
     ja      .Ld     # if True, go to defult.
     jmp     *.L10(,%rcx,8)  # if False (The number is between 50-60 jump to the correct adress in the array.


