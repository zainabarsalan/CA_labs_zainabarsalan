.text
.globl main

main:
   li x22,0 #i=0
   li x23, 0 #sum=0
   li x24, 0x200 #base address of array
   li x25, 10 #10 constant for comparing
   li x10,0 #temp
   li x9,0
loop1:
    bge x22,x25, endloop
    slli x10,x22,2 # i*4
    add x10,x10,x24#add base address 
    sw x22,0(x10) #store i at address a[i]
    addi x22,x22,1
    beq x0,x0,loop1

endloop:
   li x22,0 #i=0
   
loop2:
    bge x22,x25, exit
    slli x10,x22,2
    add x10,x10,x24
    lw x9,0(x10) #load data at address a[i] in x9
    add x23,x23,x9 # add the x9 data which is a[i] into the sum
    addi x22,x22,1
    beq x0,x0,loop2
exit:

end:
  j end 
    