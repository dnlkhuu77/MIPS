.text

Main:
li $v0, 4
la $a0, prompt
syscall

li $v0, 5
syscall

move $a0, $v0
jal fib
move $t0, $v0

li $v0, 4
la $a0, answer
syscall

move $a0, $t0
li $v0, 1
syscall

li $v0, 10
syscall

#a0 = n
fib:

beqz $a0, base_one
li $v0, 1
beq $a0, $v0, base_two

addi $sp, $sp, -8
sw $ra, 0($sp)
sw $a0, 4($sp)

addi $a0, $a0, -1
jal fib

addi $sp, $sp, -4
lw $a0, 8($sp)
sw $v0, 0($sp)
##
addi $a0, $a0, -2
jal fib

move $t0, $v0
lw $t1, 0($sp)
addi $sp, $sp, 4

add $v0, $t0, $t1

lw $ra, 0($sp)
addi $sp, $sp, 8
jr $ra

base_one:
li $v0, 0
jr $ra

base_two:
li $v0, 1
jr $ra

.data
prompt: .asciiz "Enter a num: "
answer: .asciiz "answer: "