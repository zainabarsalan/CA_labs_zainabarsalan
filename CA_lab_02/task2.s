.text 
.globl main 

main:
  li x20, 1 #x=1 you can put any number from 1-4 and it will go to that case 
  li x21, 1#a=1
  li x22,5#b=5
  li x23,6#c=6

  li x5,1 #case1 
  beq x20,x5,case1

  li x5, 2 #case2
  beq x20,x5, case2 

  li x5,3#case3
  beq x20,x5,case3

  li x5,4#case4
  beq x20,x5,case4
  
  li x21,0#a=0 default 
  beq x0,x0, exit


case1:
  add x21,x22,x23 #a=b+c
  beq x0, x0, exit

case2:
  sub x21,x22,x23 #a=b-c
  beq x0, x0, exit

case3:
   slli x21,x22,1 #a=b*2 so 1 bit shift left
   beq x0,x0,exit
case4:
    srai x21,x22,1 #a=b/2 so shift right
    beq x0,x0,exit
exit:
   
end:
  j end 