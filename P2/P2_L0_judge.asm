.data 
str: .space 50

.text
li $v0,5
syscall
move $t0,$v0

li $t1,0
for_1:
slt $t2,$t1,$t0
beqz $t2,for_1_end
nop

li $v0,12
syscall
sb $v0,str($t1)

addi $t1,$t1,1
j for_1
nop

for_1_end:
nop

li $t4,1
beq $t1,$t4,e1_end

li $t2,2       #use $t2 as n/2,use $t7 as sign
div $t2,$t0,$t2
li $t7,0
li $t1,0
for_2:
slt $t3,$t1,$t2
beqz $t3,for_2_end
nop

sub $t4,$t0,$t1
subi $t4,$t4,1
lb $t3,str($t1)
lb $t4,str($t4)
bne $t3,$t4,end
nop

addi $t3,$t2,-1
bne $t1,$t3,if_not
nop
li $t7,1
if_not:
nop

addi $t1,$t1,1
j for_2
nop
e1_end:
li $t7,1

for_2_end:

end:
move $a0,$t7
li $v0,1
syscall
li $v0,10
syscall