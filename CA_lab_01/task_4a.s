.text
.globl main

main:
   li x10, 0x78786464
   li x11, 0xA8A81919
   li x5, 0x100 
   li x6, 0x1F0

   sw x10, 0(x5) #store x10 at 0x100
   
   sw x11, 0(x6) #store x11 at 0x1F0

   lhu x12, 0(x5) #load halfword(2 bytes) unsigned 

   lh x13, 0(x6) #load halfword 2 bytes 
   lb x14, 0(x6) #load char (1 byte) so load byte 

  
end:
    j end   
