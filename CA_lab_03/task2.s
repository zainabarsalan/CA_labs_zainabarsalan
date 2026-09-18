.text
.globl main 

main:
    li x10,10 #g=10
    li x11,2 #h=2
    li x12,3 #i=3
    li x13,4 #j=4

    jal x1,leaf# function call leaf

    j exit #go to exit


leaf:

    addi x2,x2,-16 #make stack space 

    sw x18,0(x2) #save x18
    sw x19,4(x2) #save x19
    sw x20,8(x2) #save x20

    add x18,x10,x11 #g+h
    add x19,x12,x13 #i+j
    sub x20,x18,x19 #(g+h)-(i+j)

    sw x20,12(x2) #save result

    lw x18,0(x2) #restore x18
    lw x19,4(x2) #restore x19
    lw x20,8(x2) #restore old x20

    lw x20,12(x2) #put result in x20

    addi x2,x2,16 #release stack space
    jalr x0,0(x1) #return


exit:

end:
    j end
