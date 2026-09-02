.text
.globl main

main:
   li x5, 5 #a=5
   li x6, 0 # b=0
   
   addi x5,x6, 32 #a=b+32
   add x7,x5,x6  #x7=d d=a+b
   addi x7,x7,-5 #x7=d d-5
   sub x8,x5,x7 #temp x8=e e=a-d
   sub x10,x6,x5 #temp x10 = b-a
   add x8,x8,x10 #x8=e e=e+x10
   add x8,x8,x7 #e=e+d

   add x20,x5,x6 #temp x20=a+b
   add x21,x7,x8 #temp x21= d+e
   add x8,x20,x21 #e=tempx21+tempx20

end:
    j end   
