.text
.globl main

main:
   li x10,10 #a=10
   li x11,12 #b=12

   jal x1,sum #call sum

   addi x11,x10,0 #result in x11
   li x10,1 
   ecall #for printing 

   j exit

sum:
   add x10,x10,x11 #a+b
   jalr x0,0(x1) #return to main function

exit:
end:
  j end 
