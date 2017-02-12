# Homework #1
# Daniel Khuu
# 109372156

.data
.align 2
arg1: .word 0
arg2: .word 0
error: .asciiz "Incorrect argument provided.\n"
sm: .asciiz "Signed Magnitude: "
one: .asciiz "One's Complement: "
gray: .asciiz "Gray Code: "
dbl: .asciiz "Double Dabble: "
msg1: .asciiz "You entered "
msg2: .asciiz " which parsed to "
msg3: .asciiz "In hex it looks like "
msg4: .asciiz "\n"
msg5: .asciiz "-"

# Helper macro for grabbing command line arguments
.macro load_args
	lw $t0, 0($a1)
	sw $t0, arg1
	lw $t0, 4($a1)
	sw $t0, arg2
.end_macro

.text
.globl main
main:
	load_args()
	lw $t2, arg1
	add $t2, $0, $0
	lw $t3, arg1
	add $t3, $0, $0
	lw $t4, arg1
	add $t4, $0, $0
	lw $t5, arg1
	add $t5, $0, $0
	lw $t6, arg1
	add $t6, $0, $0
	lw $t7, arg1
	add $t7, $0, $0
	lw $t8, arg1
	add $t8, $0, $0
	lw $t9, arg1
	add $t9, $0, $0
	
	
	
	lw $t0, arg2
	lb $t2, ($t0)
	beq $t2, '1', nonerrorbus
	beq $t2, 's', nonerrorbus
	beq $t2, 'g', nonerrorbus
	beq $t2, 'd', nonerrorbus
	
	la $a0, error
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
	nonerrorbus: #check to see there is a second byte in arg2
	lb $t2, 1($t0)
	beq $t2, 0, nonerror
	
	la $a0, error
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
	nonerror:
	
	lw $t0, arg1
	li $t4, '0' #load immediate to $t4 (register)
	#li $t5, 0 #value: 0
	li $t6, 10 #value: 10
	li $t7, 1 #if negative, it's 0; otherwise, it's 1
	li $t8, -1
	
	
	lb $t2, ($t0) #check the input for a -
	beq $t2, '-', negpartone
	b loop1
	
negpartone:
	li $t7, 0
	addi $t0, $t0, 1

loop1:
	lb $t2, ($t0)
	blt $t2, '0', negcheck
	bgt $t2, '9', negcheck
	
	mul $t3, $t3, $t6 #multiple sum by 10
	sub $t2, $t2, $t4
	add $t3, $t3, $t2
	
	beq $t2, '0', subtract
	addi $t0, $t0, 1
	b loop1

negcheck:	
	beqz $t7, subtract
	b continue1
	
subtract:
	sub $t3, $0, $t3
	
	
continue1:
	la $a0, msg1
	li $v0, 4
	syscall
	
	lw $a0, arg1
	syscall
	
	la $a0, msg2
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, msg4
	li $v0, 4
	syscall
	
	la $a0, msg3
	syscall
	
	move $a0, $t3
	li $v0, 34
	syscall
	
	la $a0, msg4
	li $v0, 4
	syscall
	
	move $t5, $t3 #part3

#PART 2

	part2:
	
	lw $t0, arg2
	lb $t2, ($t0) #loading the 2nd argument
	
	beq $t2, '1', lbranch
	beq $t2, 's', sbranch
	beq $t2, 'g', gbranch
	beq $t2, 'd', part3

	b done
	
	lbranch:
	beq $t7, 1, ldone #if it's positive, just print
	
	add $t3, $t3, $t8
	
	la $a0, one
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 34
	syscall

	b done
	
	ldone:
	la $a0, one
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 34
	syscall
	
	b done
	
	
	sbranch:
	
	beq $t7, 1, sdone #if it's positive, just print
	li $t9, 0x80000000
	
	add $t3, $t3, $t8 #subtract by 1
	xori $t3, $t3, -1 #invert the bits
	or $t3, $t3, $t9  #get the 1 on the leftmost digit back
	
	la $a0, sm
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 34
	syscall
	
	b done
	
	sdone:
	
	la $a0, sm
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 34
	syscall
	
	
	b done
	
	gbranch:
	beq $t7, 1, gray_true #if integer is positive, we proceed to the algorithm
	add $t3, $t3, $t8
	xori $t3, $t3, -1
	sub $t3, $0, $t3
	
	#WE HAVE TO RETURN THE LEFTMOST DIGIT TO 0 IF POSITIVE
	
	gray_true:
	#$t9 will be temporary holder for original $t3
	add $t9, $t3, $0 #make the original num with t5 is equal to 0
	
	srl $t3, $t3, 1
	xor $t3, $t3, $t9
	
	la $a0, gray
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 34
	syscall
	
	b done
	
	done:
	la $a0, msg4
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
		
	
#PART 3
	part3:
	and $t9, $t9, $0 #zeroed out var r / $t9 will be var r
	li $t8, 0 #$t8 will be the loop condition; k
	beq $t7, 1, double_dabble #if positive, we do the algorithm
	sub $t5, $0, $t5 #turn negative to positive
	
	double_dabble:
	li $t2, 1 #update msb; if negative it's 0; otherwise 1
	beq $t8, 32, continue_2
	addi $t8, $t8, 1 #update the counter
	
	#$t2 will be our var msb; if negative = 0; positive = 1
	bgez $t5, something
	li $t2, 0
	
	something:
	sll $t9, $t9, 1
	sll $t5, $t5, 1
	
	beq $t2, 1, continueon
	
	addi $t9, $t9, 1
	
	continueon:
	bge $t8, 32, double_dabble
	beqz $t9, double_dabble
	
	li $t0, 0xf0000000 #$t0 will be mask
	li $t1, 0x40000000 #$t1 will be cmp
	li $t2, 0x30000000 #$t2 will be add
	
	li $t3, 0 #loop updater 0
	
	doubleforloop:
	bge $t3, 8, double_dabble
	addi $t3, $t3, 1 #increment the counter
	and $t4, $t0, $t9 #$t4 will be var mv
	ble $t4, $t1, hello #if mv <= cmp, repeat the inner for loop
	add $t9, $t9, $t2
	
	hello:
	srl $t0, $t0, 4
	srl $t1, $t1, 4
	srl $t2, $t2, 4
	b doubleforloop #when over, repeat the inner for loop
	
	continue_2:
	la $a0, dbl
	li $v0, 4
	syscall
	
	beq $t7, 1, continue3 #positive numbers will skip having a negative sign added
	
	la $a0, msg5
	syscall
	
	continue3:
	
	move $a0, $t9
	li $v0, 34
	syscall
	
	la $a0, msg4
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
