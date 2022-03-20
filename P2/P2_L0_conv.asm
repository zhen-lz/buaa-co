.data
mn: .space 16
matrix1: .space 484
matrix2: .space 484
matrix: .space 484
space: .asciiz " "
enter: .asciiz "\n"
.text
##input matrix1
li $v0,5
syscall
move $t0,$v0
li $v0,5
syscall
move $t1,$v0
li $v0,5
syscall
move $t2,$v0
li $v0,5
syscall
move $t3,$v0
## t0,t1,t2,t3 as m1,n1,m2.n2##
la $t4,mn
add $t4,$t4,0
sw $t0,0($t4)
add $t4,$t4,4
sw $t1,0($t4)
add $t4,$t4,4
sw $t2,0($t4)
add $t4,$t4,4
sw $t3,0($t4)

move $a0,$t0
move $a1,$t1
la $a2,matrix1
jal matrix_input
move $a0,$t2
move $a1,$t3
la $a2,matrix2
jal matrix_input

##end input##
li $t0,0
li $t1,0
li $t2,0
li $t3,0
##use t0,t1,t2,t3 as i,j,k,l##
Loopi:
li $t1,0

Loopj:
li $t2,0
li $t7,0 #use as result

Loopk:
li $t3,0

Loopl:
la $t4,mn
lw $t4,12($t4)
sll $t4,$t4,2
mul $t4,$t4,$t2
sll $t5,$t3,2
add $t4,$t4,$t5
lw $t4,matrix2($t4) #h(k,l)
la $t5,mn
lw $t5,4($t5)
sll $t5,$t5,2
move $t6,$t0
add $t6,$t6,$t2
mul $t5,$t5,$t6
move $t6,$t1
add $t6,$t6,$t3
sll $t6,$t6,2
add $t5,$t5,$t6
lw $t5,matrix1($t5) #f(i+k-1,j+l-1)
mul $t4,$t4,$t5
add $t7,$t7,$t4

addi $t3,$t3,1
la $t4,mn
lw $t4,12($t4)
slt $t4,$t3,$t4
beq $t4,1,Loopl
nop

addi $t2,$t2,1
la $t4,mn
lw $t4,8($t4)
slt $t4,$t2,$t4
beq $t4,1,Loopk
nop

la $t4,mn
lw $t5,12($t4)
lw $t4,4($t4)
sub $t4,$t4,$t5
addi $t4,$t4,1
sll $t4,$t4,2
mul $t4,$t4,$t0
sll $t5,$t1,2
add $t4,$t4,$t5
sw $t7,matrix($t4) #store result

addi $t1,$t1,1
la $t4,mn
lw $t5,12($t4)
lw $t4,4($t4)
sub $t4,$t4,$t5
addi $t4,$t4,1
slt $t4,$t1,$t4
beq $t4,1,Loopj
nop

addi $t0,$t0,1
la $t4,mn
lw $t5,8($t4)
lw $t4,0($t4)
sub $t4,$t4,$t5
addi $t4,$t4,1
slt $t4,$t0,$t4
beq $t4,1,Loopi
nop

li $t0,0
li $t1,0
##use t0,t1 as i.j##
loop_out_i:
li $t1,0

loop_out_j:
la $t4,mn
lw $t5,12($t4)
lw $t4,4($t4)
sub $t4,$t4,$t5
addi $t4,$t4,1
sll $t4,$t4,2
mul $t4,$t4,$t0
sll $t5,$t1,2
add $t4,$t4,$t5
lw $a0,matrix($t4)
li $v0,1
syscall
la $a0,space
li $v0,4
syscall

addi $t1,$t1,1
la $t4,mn
lw $t5,12($t4)
lw $t4,4($t4)
sub $t4,$t4,$t5
addi $t4,$t4,1
slt $t4,$t1,$t4
beq $t4,1,loop_out_j
nop

la $a0,enter
li $v0,4
syscall

addi $t0,$t0,1
la $t4,mn
lw $t5,8($t4)
lw $t4,0($t4)
sub $t4,$t4,$t5
addi $t4,$t4,1
slt $t4,$t0,$t4
beq $t4,1,loop_out_i
nop

li $v0,10
syscall

matrix_input:
##a0,a1,a2 as m,n,label##
li $s0,0
li $s1,0  #s0,s1 as i,j
loop_i:
li $s1,0

loop_j:
sll $s2,$a1,2
mul $s2,$s2,$s0
sll $s3,$s1,2
add $s2,$s2,$s3
add $s2,$s2,$a2
li $v0,5
syscall
sw $v0,0($s2)

addi $s1,$s1,1
slt $s2,$s1,$a1
beq $s2,1,loop_j
nop

addi $s0,$s0,1
slt $s2,$s0,$a0
beq $s2,1,loop_i
nop
jr $ra
