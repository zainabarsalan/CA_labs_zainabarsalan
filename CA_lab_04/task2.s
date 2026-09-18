.text
.globl main
main:
    addi x10,x0,5 #num=5
    jal x1, ntri

    addi x11, x10, 0
    addi x10, x0, 1 
    ecall #for printing 
    


ntri:
    addi sp, sp, -8 #stack space
    sw x1, 4(sp)
    sw x10, 0(sp)
    addi x5, x10, -1
    bge x0, x5, return

    addi x10, x10, -1
    jal x1, ntri

    addi x6, x10, 0

    lw x10, 0(sp)
    lw x1, 4(sp)
    addi sp, sp, 8 #pop from stack
    add x10, x10, x6
    jalr x0, 0(x1)


return:
    addi x10, x0, 1
    lw x1, 4(sp)
    addi sp, sp, 8

    jalr x0, 0(x1)


end:
  j end 