.text
.globl main

main:

li x7,0#i
li x5,5 #a=5
li x6,5 #b=5

loop1:
    
    bge x7,x5, exit:
    li x29,0 #j
    loop2:
        bge x29,x6,exitif
        slli x11,x29,4
        add x11,x11,x10
        add x30,x7,x29
        sw x30,0(x11)
        addi x29,x29,1
        beq x0,x0,loop2
    exitif:
        add x7,x7,1
        beq x0,x0,loop1
        
exit:

end:
  j end