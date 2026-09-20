.text
.globl main
main:
    addi x10,x0,5 #num=5
    jal x1, ntri #function calling

    addi x11, x10, 0 #copy result from x10 to x11
    addi x10, x0, 1 
    ecall #for printing 
    
ntri:
    addi sp, sp, -8 #stack space
    sw x1, 4(sp) #save return address
    sw x10, 0(sp) #save num
    addi x5, x10, -1 #x5=num-1
    bge x0, x5, return # if num-1<=0 go to return

    addi x10, x10, -1 #num=num-1
    jal x1, ntri

    addi x6, x10, 0 #save result of ntri(num-1)

    lw x10, 0(sp) #restore original num
    lw x1, 4(sp) #restore return address
    addi sp, sp, 8 # release stack space 
    add x10, x10, x6 #num+ntri(num-1)
    jalr x0, 0(x1)


return:
    addi x10, x0, 1 #return 1 for base case 
    lw x1, 4(sp) #restore return address
    addi sp, sp, 8 #release stack space/ pop
    jalr x0, 0(x1) #return

end:
  j end 