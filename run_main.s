#Sagi Wilentzik
#run_main.s

    .text # run_main.s file will contain the run_main-test code in assembly.

    format_scan_for_length: .string "%d"
    format_scan_for_string: .string "%s"

.global run_main
    .type run_main, @function # run_main function will ask the user to enter a length of string and a string
    #on the same length. The function will do this twice and than ask for number for the rigth
    #fucntion in the switch case. The function will send the informain to the run_func function.
run_main:

    # create space on the stack by substract 512 byes. Each string can be with maximum 255 character.
    # In addition, we need one more byte for the length.
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $544, %rsp

    # read the first string legth.
    movq    $format_scan_for_length, %rdi   # insert the format for scanf function.
    leaq    (%rsp),%rsi #save the rsp adrress in rsi register.
    xorq    %rax, %rax # make rax register zero.
    call    scanf   # call scanf function.

    # read the first string
    movq    $format_scan_for_string, %rdi   # insert the format for scanf function.
    leaq    1(%rsp), %rsi   # save the rsp address in rsi register.
    xorq    %rax, %rax    #make rax register zero.
    call    scanf   #call for scanf function.
    movzbq  (%rsp), %r12  # save the first string length in r12 register.
    movb    $0,1(%rsp, %r12)    # End the string with '/0'.


    # read the second string length.
    movq    $format_scan_for_length, %rdi # insert string format to rdi register.
    leaq    256(%rsp), %rsi # save the second string length address in rsi register.
    xorq    %rax, %rax    # make rax register zero.     
    call    scanf   # call scanf function
    

    # read the second string. 
    movq    $format_scan_for_string, %rdi   # insert the format for scanf function.
    leaq    257(%rsp), %rsi    # insert the address for the second string to rsi register.
    xorq    %rax, %rax  # make rax zero.
    call    scanf   # call scanf function.
    movzbq  256(%rsp), %r13    # save the second string length in r13 register.
    movb    $0, 257(%rsp, %r13) # End the second string with '/0'.

    # ask for option number and call to select_func function
    movq    $format_scan_for_length, %rdi   # insert the format for scanf function.
    leaq    528(%rsp), %rsi  #save the function number.
    xorq    %rax, %rax  # make rax register zero.
    call    scanf   # call scanf function.
    movzbq  528(%rsp), %r14 # save the number in r14 register.

    # save the arguemts for select_func function
    movq    %r14, %rdi
    # leaq    528(%rsp), %rdi  # the option argument.
    leaq    (%rsp), %rsi  # index to the first string length.
    leaq    256(%rsp), %rdx  # index to the second string length.
    xorq    %rax, %rax  # make arx register zero.
    call    run_func
    
    # return 
    movq    %rbp,%rsp
    popq    %rbp
    xorq    %rax,%rax
    ret
