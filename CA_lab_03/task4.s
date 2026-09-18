.text
.globl main
main:
    li x10,0x200 #base address of x
    li x11,0x300 #base address of y
    li x15,72 #H
    sb x15,0(x11) #store H
    li x15,69 #E
    sb x15,1(x11) #store E
    li x15,76 #L
    sb x15,2(x11) #store L
    li x15,76 #L
    sb x15,3(x11) #store L
    li x15,79 #O
    sb x15,4(x11) #store O 
    #HELLO/0
    li x15,0 #null character
    sb x15,5(x11) #store null character

    jal x1,strcpy #call strcpy
    j exit 


strcpy:
    addi x2,x2,-16 #make stack space
    sw x19,0(x2) #save x19
    li x19,0 #i=0

loop:
    add x12,x10,x19 #address of x[i]
    add x13,x11,x19 #address of y[i]

    lb x14,0(x13) #load y[i]
    sb x14,0(x12) #x[i]=y[i]

    beq x14,x0,done #if y[i]=='\0' we go to done
    addi x19,x19,1 #i++
    beq x0,x0,loop #back to loop

done:
    lw x19,0(x2) #restore x19
    addi x2,x2,16 #release stack space
    jalr x0,0(x1) #return


exit:
end:
    j end