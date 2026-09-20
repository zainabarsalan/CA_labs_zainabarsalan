.text
.globl main

main:
    li x10,18 #first value x
    li x11,12 #second value y
    jal x1,hcf #calling hcf function

    add x11,x10,x0 
    li x10,1
    ecall #for printing


hcf:
    addi sp,sp,-8 #make stack space
    sw x1,4(sp) #save return address

    beq x11,x0,base #if y==0 go to base case

    div x12,x10,x11 #x12=x/y
    mul x13,x12,x11 #x13=(x/y)*y
    sub x14,x10,x13 #x14=x-(x/y)*y = remainder

    add x10,x11,x0 #x=y
    add x11,x14,x0 #y=remainder

    jal x1,hcf #call hcf again

    lw x1,4(sp) #restore return address
    addi sp,sp,8 #release stack space
    jalr x0,0(x1) #return


base:
    lw x1,4(sp) #restore return address
    addi sp,sp,8 #release stack space
    jalr x0,0(x1) #return

end:
    j end