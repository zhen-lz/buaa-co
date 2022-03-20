.data
	matrix1: .space 256
	matrix2: .space 256
    matrixout: .space 256
    space: .asciiz  " "
    enter: .asciiz "\n"

.text
    li $v0,5 #读入n
    syscall
    move $t0,$v0

    li $t1,0 #将$t1,$t2作为i,j
    li $t2,0 

    Loop_i_matrix1: #读入matrix1
    sll $t5,$t1,5
    li $t2,0

    Loop_j_matrix1:
    sll $t6,$t2,2
    add $t6,$t5,$t6
    li $v0,5
    syscall
    sw $v0, matrix1($t6)
    addi $t2,$t2,1
    blt	$t2, $t0, Loop_j_matrix1	# if $t2 < $t1 ,to Loop_j_matrix1

    addi $t1,$t1,1
    blt	$t1, $t0, Loop_i_matrix1	# if $t1 < $t1 ,to Loop_i_matrix1

    li $t5,0
    li $t6,0
    li $t1,0
    li $t2,0

    Loop_i_matrix2: #读入matrix2
    sll $t5,$t1,5
    li $t2,0

    Loop_j_matrix2:
    sll $t6,$t2,2
    add $t6,$t5,$t6
    li $v0,5
    syscall
    sw $v0, matrix2($t6)
    addi $t2,$t2,1
    blt	$t2, $t0, Loop_j_matrix2	# if $t2 < $t1 ,to Loop_j_matrix2

    addi $t1,$t1,1
    blt	$t1, $t0, Loop_i_matrix2	# if $t1 < $t1 ,to Loop_i_matrix2

    li $t5,0
    li $t6,0
    li $t1,0
    li $t2,0
    li $t3,0
    li $t4,0

    Loop_i_out:
    li $t2,0

    Loop_k_out:
    li $t7,0
    li $s0,0

    Loop_out:
    sll $t5,$t1,5
    sll $t6,$t2,2
    sll $t4,$t7,2
    add	$t5,$t5,$t4
    sll $t4,$t7,5
    add $t6,$t6,$t4

    lw $s1,matrix1($t5)
    lw $s2,matrix2($t6)
    mult $s1, $s2
    mflo $t4
    add $s0,$s0,$t4

    addi $t7,$t7,1
    blt $t7,$t0,Loop_out

    sll $t5,$t1,5
    sll $t6,$t2,2
    add $t5,$t5,$t6
    sw $s0,matrixout($t5)
   
    addi $t2,$t2,1
    blt $t2,$t0,Loop_k_out

    addi $t1,$t1,1
    blt $t1,$t0,Loop_i_out

    li $t1,0
    li $t2,0
    
    out_i:
    sll $t5,$t1,5
    li $t2,0

    out_j:
    sll $t6,$t2,2
    add $t6,$t5,$t6
    lw $a0,matrixout($t6)
    li $v0,1
    syscall
    la $a0,space
    li $v0,4
    syscall
    addi $t2,$t2,1
    blt	$t2,$t0,out_j

    la $a0,enter
    li $v0,4
    syscall
    addi $t1,$t1,1
    blt	$t1,$t0,out_i