.text 
.globl main
main:
   li x5,0x100 #a
   li x6,0x200 #b
   li x7,0x300 #c

   #i=0
   lb x8,0(x5) #a[0]
   lh x9,0(x6) #b[0]
   add x10,x9,x8 #a[0]+b[0]
   sw x10,0(x7)#c[0]
    
   
   lb x11,1(x5) #a[1]
   lh x12,2(x6) #b[1]
   add x13,x11,x12 #a[1]+b[1]
   sw x13,4(x7)#c[1]

   lb x15,2(x5) #a[2]
   lh x16,4(x6) #b[2]
   add x17,x15,x16 #a[2]+b[2]
   sw x17,8(x7)#c[2]

   lb x20,3(x5) #a[3]
   lh x21,6(x6) #b[3]
   add x22,x20,x21 #a[3]+b[3]
   sw x22,12(x7)#c[3]

end:
  j end 