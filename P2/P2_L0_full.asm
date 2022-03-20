.data
symbol: .space 28
array: .space 28
space: .asciiz " "
enter: .asciiz "\n"
stack: .space 100

.text
main:
##t0 as n(can't change)##
la $sp,stack
add $sp,$sp,100
##initial stack##
li $v0,5
syscall
move $t0,$v0
li $a0,0
jal FullArray
li $v0,10
syscall


FullArray:
##a0 as index##
blt $a0,$t0,work
li $s0,0
loop_r:
sll $s1,$s0,2
lw $s1,array($s1)
move $a0,$s1
li $v0,1
syscall
la $a0,space
li $v0,4
syscall

addi $s0,$s0,1
slt $s1,$s0,$t0
beq $s1,1,loop_r
nop
la $a0,enter
li $v0,4
syscall
jr $ra

work:
li $s0,0
loop:
sll $s1,$s0,2
lw $s1,symbol($s1)
bnez $s1,end  #if
nop
sll $s1,$a0,2
add $s2,$s0,1
sw $s2,array($s1)
sll $s1,$s0,2
li $s2,1
sw $s2,symbol($s1)

sw $ra,-4($sp)
addi $sp,$sp,-4
sw $a0,-4($sp)
addi $sp,$sp,-4
sw $s0,-4($sp)
addi $sp,$sp,-4
addi $a0,$a0,1
jal FullArray

lw $s0,0($sp)
addi $sp,$sp,4
lw $a0,0($sp)
addi $sp,$sp,4
lw $ra,0($sp)
addi $sp,$sp,4

sll $s1,$s0,2
sw $0,symbol($s1)
end:

addi $s0,$s0,1
slt $s1,$s0,$t0
beq $s1,1,loop
nop
jr $ra
