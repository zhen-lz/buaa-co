.data
matrix: .space 12000
space: .asciiz " "
enter: .asciiz "\n"

.text
li $t0,0  #use $t0 as cont
li $t1,0  #use $t1,$t2 as i,j
li $t2,0
li $t3,0  #use $t3,$t4 as m,n
li $t4,0

li $v0,5
syscall
move $t3,$v0
li $v0,5
syscall
move $t4,$v0

Loop_i_in:
slt	$t5,$t1,$t3		# $t5 = ( $t1 < $t3) ? 1 : 0
beq $t5,$0, Loop_i_in_end

li $t2,0
Loop_j_in:
slt $t5,$t2,$t4
beq $t5,$0,Loop_j_in_end

li $v0,5
syscall
beq $v0,$0,if_else

li $t5,12
mult $t5,$t0
mflo $t5
addi $t6,$t1,1
sw $t6,matrix($t5)
addi $t5,$t5,4
addi $t6,$t2,1
sw $t6,matrix($t5)
addi $t5,$t5,4
sw $v0,matrix($t5)
addi $t0,$t0,1

j if_end

if_else:
nop

if_end:

addi $t2,$t2,1
j Loop_j_in
Loop_j_in_end:

addi $t1,$t1,1
j Loop_i_in
Loop_i_in_end:
nop

Loop_out:
beq $t0,$0,Loop_out_end
addi $t0,$t0,-1
li $t5,12
mult $t0,$t5
mflo $t5
lw $a0,matrix($t5)
li $v0,1
syscall
la $a0,space
li $v0,4
syscall
addi $t5,$t5,4
lw $a0,matrix($t5)
li $v0,1
syscall
la $a0,space
li $v0,4
syscall
addi $t5,$t5,4
lw $a0,matrix($t5)
li $v0,1
syscall
la $a0,enter
li $v0,4
syscall

j Loop_out

Loop_out_end:

li $v0,10
syscall