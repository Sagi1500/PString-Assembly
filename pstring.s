#Sagi wilentzik
#pstring.s


      .text   # Creating formats for strings.
           .section .rodata
    format3:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    formatScanNumber:   .string "%d"
    formatScanChar:     .string "%s"
    format1:    .string "invalid option!\n"  # string for the case that the input in out of bound.
    format5:    .string "length: %d, string: %s\n"

 .text	#beginning of the code:


.global pstrlen  # The function receive 2 pstring and return thier length.
	.type pstrlen,@function
pstrlen:
    pushq   %rbp
    movq    %rsp, %rbp      
    movzbq  (%rdi), %rax    # save the  string length in rax register.
    movq    %rbp,%rsp
    popq    %rbp 
    ret


.global replaceChar # The function will replace the old char to the new char.
    .type replaceChar , @function
replaceChar:

    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %r12    # push r12 to stack
    pushq   %r13    # push r13 to stack.

    xorq    %r12, %r12  #make r12 zero.
    xorq    %r13, %r13  # make r13 zero.
    leaq    (%rdi), %r13    # save first string in r13.
    inc     %r13    # move r13 to the first letter of the string.
    jmp     .replaceCharString

.replaceCharString:  # The lable will use as a loop and scan all the letter. 
    movzbq  (%r13), %r12     # insert the next letter to r12
    cmpb    (%rsi), %r12b      # check if the letter is equal to old char
    je      .switchLetter
    cmp     $0, %r12b       # if the letter is '\0'
    je      .DoneReplaceChar
    inc     %r13 
    jmp     .replaceCharString #back to the beginning of the loop


.switchLetter:  # swiching the character to new char.
    movb    (%rdx), %r12b   # insert the next letter  to r12b
    movb    %r12b,(%r13)    # insert the new letter to string.
    jmp     .replaceCharString # go back to the loop.
     

.DoneReplaceChar: # This lable will take place when the function ends to scan all the letter and replace the char.
   
    leaq    (%rdi), %rax # save the new string in return value rax register.
    popq    %r13    # insert to r13 his original value.
    popq    %r12    # insert to r12 his original value.  
    movq    %rbp, %rsp 
    popq    %rbp 
    ret


.global pstrijcpy
	.type pstrijcpy,@function       
    # The function receives 4 arguments
    # in rdi, dst pstring
    # in rsi, src pstring
    # in rdx, the starting index
    # in rcx,  the end index
    # The function will copy from index  i to j from the second pstring to the other
pstrijcpy: # The function will copy the value in indexes i to g from source pstring to des pstring.

    pushq   %rbp
    movq    %rsp, %rbp
    pushq    %r12    # push r12 to stack.
    pushq    %r13  # push r13 to stack.
    pushq    %r14     # push r14 to stack.

    leaq    (%rdi), %r12    # save the des string in r12
    leaq    (%rsi), %r13    #save the src string in r13
    xorq    %r14, %r14  # make r14 zero.  
    movq    (%rdx), %r14
    subq    %r14, (%rcx)    # find how many steps need to move from the beginning.
    add     $1, (%rcx)
    xorq    %r14, %r14
    add     $1, (%rdx)  
     # add 1 to value of rdx, later we skipp all the unnessesery notes in the string.
     #need to skip also the first one which is the number.
    jmp     .moveToStartIndex

.moveToStartIndex:  # This lable will move the string until it reaches to the starting cpy index.
    cmpb     $0, (%rdx)     # checking if the value of rdx is zero (48 is zeto in ascii)
    je      .copyString 
    inc     %r12    # move the pointer for the first word.
    inc     %r13    # move the pointer for the second word.
    sub     $1, (%rdx)
    jmp     .moveToStartIndex

.copyString:    # This lable will copy the letters.
    cmpb     $0, (%rcx)      # checking if needed to copy more notes. 
    je      .finishCopy  
    xorb    %r14b, %r14b    # make r14b zero before inserting the letter.
    movb    (%r13),%r14b   # save the next letter in r14 register.
    movb    %r14b, (%r12)    # replace the character.
    inc     %r12    # move the pointer for the first word.
    inc     %r13    # move the pointer for the second word.
    sub      $1, (%rcx)
    jmp     .copyString     # jump to the beginning of the loop.

.finishCopy:    # after finishing the copy lable, need to print the values and return.
    leaq    (%rsi), %r13    # save the second string in r13.
    leaq    (%rdi), %r12    # save the first string in r12.

    leaq    1(%r12), %rdx    # save the first string in rdx.
    movzbq  (%r12), %rsi    # save the first string length in rsi
    movq    $format5,%rdi   # save printf format in rdi register.
    xorq    %rax, %rax      # make rax register zero.
    call    printf  

    leaq    1(%r13), %rdx    # save the second string in rdx.
    movzbq  (%r13), %rsi    # save the second string length in rsi
    movq    $format5,%rdi   # save printf format in rdi register.
    xorq    %rax, %rax      # make rax register zero.
    call    printf


    popq     %r14   # return value of r14 from stack.
    popq     %r13   # return value of r13 from stack.
    popq     %r12   # retrun value of r12 from stack.
    movq     %rbp, %rsp     # restoring the old stack pointer. 
    popq     %rbp   # restoring the old frame pointer.
    ret


.global swapCase 
    .type swapCase , @function 
swapCase:

    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %r12    # push r12 to stack.
    pushq   %r13    # push r13 to stack.

    xorq    %r12, %r12  #make r12 zero.
    xorq    %r13, %r13  #make r13 zero.
    
    leaq    (%rdi), %r12    # save the string in rdi. 
    jmp     .swapCaseLoop

.swapCaseLoop:
    inc     %r12  
    movzbq  (%r12), %r13    # save the next letter in r13
    cmpb     $0, %r13b        # if the letter is zero, we are at the end of the string.
    je      .DoneSwap
    cmpb     $90, %r13b      # checking if the char is smaller than 90 (ascii value of capital Z).
    jle     .checkCapitalLetter 
    cmpb     $97, %r13b      # checking if the char is bigger than 97 (ascii value for small a)
    jge      .checkSmallLetter 
    jmp     .swapCaseLoop 



.checkCapitalLetter: # This lable will checl if the letter is capital letter and change if nesessery.
    cmpb     $65, %r13b       # checking if the char is smaller than 65
    jl      .swapCaseLoop
    addb    $32, %r13b       # add 32 to get the small letter version.
    movb    %r13b, (%r12)    # insert the new letter to the string
    jmp     .swapCaseLoop

.checkSmallLetter: # This lable will check if the letter is small  letter and change if nesessery.
    cmpb     $122, %r13b       # checking if the char is bigger than 122
    jg       .swapCaseLoop
    subb    $32, %r13b       # substract  32 to get the Capital letter version in ascii.
    movb    %r13b, (%r12)    # insert the new letter to the string.
    jmp     .swapCaseLoop



.DoneSwap:
    leaq    1(%rdi), %rdx # save the new string in return value rdx register.
    movzbq  (%rdi), %rsi  # save the string length in rsi register.
    movq    $format5, %rdi  # save the print format in rdi 
    xorq    %rax, %rax 
    call    printf
    popq    %r13    # insert to r13 his original value.
    popq    %r12    # insert to r12 his original value.  
    movq    %rbp, %rsp 
    popq    %rbp 
    ret


.global pstrijcmp
	.type pstrijcmp,@function
pstrijcmp: # The function will compare the indexes from i to j and retun the output.

    pushq   %rbp
    movq    %rsp, %rbp
    pushq    %r12    # push r12 to stack.
    pushq    %r13  # push r13 to stack.
    pushq    %r14     # push r14 to stack.

    leaq    (%rdi), %r12    #save the first in r12
    leaq    (%rsi), %r13    #save the second in r13
    xorq    %r14, %r14  # make r14 zero.  
    movq    (%rdx), %r14
    subq    %r14, (%rcx)    # find how many steps need to move from the beginning.
    add     $1, (%rcx)
    xorq    %r14, %r14
    add     $1, (%rdx)  
     # add 1 to value of rdx, later we skipp all the unnessesery notes in the string.
     #need to skip also the first one which is the number.
    jmp     .moveToStartIndexCmp 

.moveToStartIndexCmp: # moving both string to the starting index
    cmpb     $0, (%rdx)     # checking if the value of rdx is zero (48 is zeto in ascii)
    je      .compareStrings
    inc     %r12    # move the pointer for the first word.
    inc     %r13    # move the pointer for the second word.
    sub     $1, (%rdx)
    jmp     .moveToStartIndexCmp 

.compareStrings: # The lable will compare the two strings. return 1 if if the first pstring in bigger, 0 if equals,
    #otherwise returns -1 
    cmpb     $0, (%rcx)      # checking if needed to copy more notes. 
    je      .equals  
    xorb    %r14b, %r14b    # make r14b zero before inserting the letter.
    movb    (%r13),%r14b    # save the next letter in r14 register.
    cmpb    %r14b, (%r12)   # compare the character.
    jg      .firstIsBigger  # first string is biggger
    jl      .secondIsBigger # second string is bigger.
    inc     %r12    # move the pointer for the first word.
    inc     %r13    # move the pointer for the second word.
    sub      $1, (%rcx)
    jmp     .compareStrings  
 
.equals: # This lable is for the case when the two strings are equal from i to j
    movq    $0, %rax  # save the return value in rax
    jmp     .finishCompare 

.firstIsBigger:
    movq    $1, %rax # save the return value in rax
    jmp     .finishCompare 

.secondIsBigger:
    movq    $-1, %rax # save the return value in rax
    jmp     .finishCompare 

.finishCompare: 
    popq     %r14   # return value of r14 from stack.
    popq     %r13   # return value of r13 from stack.
    popq     %r12   # retrun value of r12 from stack.
    movq     %rbp, %rsp     # restoring the old stack pointer. 
    popq     %rbp   # restoring the old frame pointer.
    ret

