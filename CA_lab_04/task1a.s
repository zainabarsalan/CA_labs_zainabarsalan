.text
.globl main

main:
   addi x10,x0,5 #n=5
   jal x1,fact # fact function calling

   add x11,x10,x0 #copy result from x10 to x11
   li x10,1 
   ecall #for printing


fact:
    addi sp,sp,-8 #make stack space
    sw x1,4(sp) #save return address
    sw x10,0(sp) #save n

    addi x5,x10,-1 #x5=n-1
    bge x5,x0,L1 #if n-1>=0 go to L1

    addi x10,x0,1 #return 1 for base case
    addi sp,sp,8 #release stack space
    jalr x0,0(x1) #return

L1:
    addi x10,x10,-1 #n=n-1
    jal x1,fact #call fact again with n-1

    addi x6,x10,0 #save result of fact(n-1)
    lw x10,0(sp) #restore original n
    lw x1,4(sp) #restore return address
    addi sp,sp,8 #release stack space

    mul x10,x10,x6 #n*fact(n-1)
    jalr x0,0(x1) #return


end:
    j end 
