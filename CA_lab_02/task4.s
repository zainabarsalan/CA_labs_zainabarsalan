.text
.globl main

main:

li x7,0#i
li x5,5 #a=5
li x6,5 #b=5

loop1:
    
    bge x7,x5, exit #if i>=a go to exit end loop1
    li x29,0 #j
    loop2:
        bge x29,x6,exitif ##if j>=b go to exitif 
        slli x11,x29,4 #j*16
        add x11,x11,x10#add base address of D
        add x30,x7,x29 #i+j
        sw x30,0(x11)#store i+j in D[4*j]
        addi x29,x29,1 #j++
        beq x0,x0,loop2 #back to loop2 
    exitif:
        addi x7,x7,1 #i++
        beq x0,x0,loop1 #back to loop1
        
exit:

end:
  j end