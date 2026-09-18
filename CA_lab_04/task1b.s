.text
.globl main

main:
    addi x10,x0,5
    jal x1,factorial
    addi x11,x10,0
    addi x10,x0,1
    ecall

factorial:
   addi x7,x0,1#acc=1
   
loop: 
  bge x0,x10,return
  mul x7,x7,x10#acc=acc*n
  addi x10,x10,-1 #n=n-1
  jal x0,loop

  
return:
   addi x10,x7,0 
   jalr x0,0(x1)
  

end:
  j end 