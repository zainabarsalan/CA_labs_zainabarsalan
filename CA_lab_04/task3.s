.text
.globl main

main:
    li x10,0x200 #address for array a
    li x11,3 #len a =3
    li x12,5 #populating array
    sw x12,0(x10) #storing 5 in array a[0]
    li x12,40 #populating array
    sw x12,4(x10) #storing 40 in array a[1]
    li x12,20 #populating array
    sw x12,8(x10) #storing 20 in array a[2]

    beq x10,x0,end #if array is null then just return
    beq x11,x0,end #if len==0 then also just return

    li x13,0 #i=0

loop1:
    beq x13,x11,end #if i==len, end
    add x14,x0,x13 #j=i

loop2:
    beq x14,x11,endj #if j==len, exit loop
    slli x15,x13,2 # i*4
    add x16,x10,x15 #base address+(i*4)
    lw x17,0(x16) #load a[i] into x17

    slli x18,x14,2 # j*4
    add x19,x10,x18 #base address+ (j*4)
    lw x20,0(x19) #load a[j] into x20

    bge x17,x20,noswap #if a[i]>=a[j] no swap

    sw x20,0(x16) #a[i]=a[j]
    sw x17,0(x19) #a[j]=old a[i]

noswap:
    addi x14,x14,1 #j++
    beq x0,x0,loop2 #loop back to j loop

endj:
    addi x13,x13,1 #i++
    beq x0,x0,loop1 #loop back to i loop

end:
    j end