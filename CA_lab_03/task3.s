.text
.globl main
main:

    li x10,0x100 #base address of v
    li x11,2 #k=2

    li x15,15 #v[2]=15
    sw x15,8(x10) #store 15 in v[2]

    li x15,13 #v[3]=13
    sw x15,12(x10) #store 13 in v[3]

    jal x1,swap #call swap

    j exit #go to exit


swap:

    slli x12,x11,2 #k*4
    add x12,x10,x12 #address of v[k]

    lw x13,0(x12) #temp=v[k]
    lw x14,4(x12) #v[k+1]

    sw x14,0(x12) #v[k]=v[k+1]
    sw x13,4(x12) #v[k+1]=temp

    jalr x0,0(x1) #return


exit:
end:
    j end