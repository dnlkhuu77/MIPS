# Homework #4
# name: Daniel Khuu
# sbuid: 109372156

.macro bears_bm
	lw $a0, 0($sp)
	la $a1, bears_beg
	li $a2, 7
	li $v0, 15
	syscall
.end_macro

.macro comma_m
	lw $a0, 0($sp)
	la $a1, comma
	li $a2, 2
	li $v0, 15
	syscall
.end_macro

.macro newline_m
	lw $a0, 0($sp)
	la $a1, newline
	li $a2, 1
	li $v0, 15
	syscall
.end_macro

.macro return_m
	lw $a0, 0($sp)
	la $a1, return
	li $a2, 8
	li $v0, 15
	syscall
.end_macro

.macro bears_em
	lw $a0, 0($sp)
	la $a1, bears_end
	li $a2, 3
	li $v0, 15
	syscall
.end_macro

.macro rfme_m
	lw $a0, 0($sp)
	la $a1, rfme
	li $a2, 30
	li $v0, 15
	syscall
.end_macro

.macro can_m
	lw $a0, 0($sp)
	la $a1, can
	li $a2, 11
	li $v0, 15
	syscall
.end_macro

.text

#Part 1

#itof function
# a0 - the integer that will be written to a file
# a1 - the file desciptor of the output file
itof:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	li $s0, 0
	move $s1, $a1 #save the file descriptor
	
	li $t0, 0 #$t0 is the counter for the number of digits in the number
	li $t1, 0 #$t1 is the number of digits in the number
	li $t2, 0 # a flag to indicate a value in negative/positive
	li $t3, 0
	li $t4, 0
	li $t9, 10 # $t9 holds 10
	
	bgez $a0, positive #if the number is negative, we will trigger a flag
	li $t2, 1 #the flag will be 1 to show that the number is negative
	sub $t3, $a0, $a0 #subtracting a negative number with itself get the number to zero
	sub $a0, $t3, $a0 #subtracting zero with a negative number makes the number positive
	#t3 holds the positive number

positive:
	div $a0, $t9 #dividing by 10
	mfhi $s0 # reminder to $s0
  	mflo $a0 # quotient to $a0

complete_dividing:
	addi $s0, $s0, 48 #normalize the remainder into ASCII

	addi $sp, $sp, -1
	sb $s0, 0($sp) #store this ASCII byte into the stack
	addi $t1, $t1, 1 #increment the number of digits
	blez $a0, nextstep #if the number is equal or less than zero, exit this loop
	b positive
	
nextstep:
	beq $t2, 0, continue_on #if the number is positive, skip this part
	addi $sp, $sp, -1
	li $t4, 45 # 45 is the negative symbol
	sb $t4, 0($sp)
	addi $t1, $t1, 1

continue_on:
	bge $t0, $t1, exit_loop #if the while counter is greater than or equal to number_of_characters, exit the loop
	move $a0, $s1 #move the file descriptor to #a0
	la $a1, 0($sp)
	li $a2, 1
	li $v0, 15
	syscall
	
	addi $sp, $sp, 1
	addi $t0, $t0, 1
	b continue_on
	
exit_loop:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
  	jr $ra


#Part 2

#bears function
# a0 - number of bears given to you
# a1 - the goal
# a2 - number of bears you asked
# a3 - the number of steps in the game
# FIFTH ARGUMENT : file descriptor
# v0 - 1 if the goal is achieved; 0 otherwise
bears:
	lw $t0, 0($sp) #load the fifth argument
	
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $ra, 4($sp)
	sw $a0, 8($sp) #inital
	sw $a1, 12($sp) #goal
	sw $a2, 16($sp) #increment
	sw $a3, 20($sp) #n (number of steps)
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0

start:
	bears_bm()
	
	lw $a0, 8($sp) #initial
	lw $a1, 0($sp) #file descriptor
	jal itof
	
	comma_m()
	
	lw $a0, 12($sp)
	lw $a1, 0($sp)
	jal itof
	
	comma_m()
	
	lw $a0, 16($sp)
	lw $a1, 0($sp)
	jal itof
	
	comma_m()
	
	lw $a0, 20($sp)
	lw $a1, 0($sp)
	jal itof
	
	bears_em()
	
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t0, 0($sp)

base_case1:
	bne $a0, $a1, base_case2 #branch out to the next loop if initial != goal
	
	return_m()
	
	li $a0, 1
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 1
	b goal

base_case2:
	bne $a3, 0, recursive_1
	
	return_m()
	
	li $a0, 0
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 0
	b goal

recursive_1:
	lw $t0, 0($sp)
	
	add $a0, $a0, $a2 #intial = initial + increment
	addi $a3, $a3, -1
	
	jal bears #v0 holds the sum (RECURSION : IT MUST CALL ITSELF)
	
	bne $v0, 1, recursive_2
	
	return_m()
	
	li $a0, 1
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 1
	b goal

recursive_2:
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t0, 0($sp)
	
	#first condition
	li $t2, 0
	li $t3, 2
	div $a0, $t3 #dividing the intitial by 2
	mfhi $t2 #the remainder is in $t0
	bnez $t2, else #if the remainder isn't 0, skip this else-if
	
	#second condition
	div $a0, $t3 #divide by 2
	mflo $a0 # the quotient will be in $a0
	
	addi $a3, $a3, -1
	jal bears
	
	bne $v0, 1, else #if the result doesn't equal 1, go to the else branch
	
	return_m()
	
	li $a0, 1
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 1
	b goal
	
else:
	return_m()
	
	li $a0, 0
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 0

goal:
	lw $t0, 0($sp)
	lw $ra, 4($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	addi $sp, $sp, 24
  	jr $ra
	

#Part 3

#recursiveFindMajorityElement function
# a0 - integer array
# a1 - integer being search for
# a2 - start index
# a2 - end index
# FIFTH ARGUMENT: file descriptor
recursiveFindMajorityElement:
	lw $t0, 0($sp) #load the fifth argument
	
	addi $sp, $sp, -40
	sw $t0, 0($sp)
	sw $ra, 4($sp)
	sw $a0, 8($sp) #integer array
	sw $a1, 12($sp) #target integer
	sw $a2, 16($sp) #start index
	sw $a3, 20($sp) #end index
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0

finding:
	sub $t1, $a3, $a2 #endIndex - startIndex
	addi $t1, $t1, 1 # t1 is the array_length
	sw $t1, 24($sp) #save the array length!!!!!!!
	
	rfme_m()
	
	lw $a0, 16($sp)
	lw $a1, 0($sp)
	jal itof
	
	comma_m()
	
	lw $a0, 20($sp)
	lw $a1, 0($sp)
	jal itof
	
	comma_m()
	
	lw $a0, 24($sp) #array_length
	lw $a1, 0($sp)
	jal itof
	
	bears_em()
	
	lw $t0, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t1, 24($sp)
	
proceed: #base case
	bne $t1, 1, else_2 #outer if statement (recursive)
	
proceed_inner:
	# multiple the startIndex by 4!!!!
	li $t7, 4 
	mul $t6, $a2, $t7 #multiple the start index by 4
	add $a0, $a0, $t6 #add the offset
	
	lw $t2, 0($a0) #getting array[startIndex]
	bne $a1, $t2, else_inner #if candidate != array[startIndex], go to the inner else branch
	
	return_m()
	
	li $a0, 1
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 1
	b finish

else_inner:
	return_m()
	
	li $a0, 0
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, 0
	b finish

else_2:
	lw $t1, 24($sp) #array_length
	
	li $t3, 2
	div $t1, $t3
	mflo $t4 # t4 will be the mid
	
	sw $t4, 28($sp) # saving the midpoint
	
	li $t8, 0 #LHS_sum
	li $t9, 0 #RHS_sum
	
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	move $a3, $a2
	add $a3, $a3, $t4
	addi $a3, $a3, -1
	
	jal recursiveFindMajorityElement

	sw $v0, 32($sp) #save the first result
	
	##########
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t1, 24($sp)
	lw $t4, 28($sp)
	
	add $a2, $a2, $t4
	
	jal recursiveFindMajorityElement
	
	sw $v0, 36($sp)
	lw $t8, 32($sp)
	
	return_m()
	
	lw $v0, 36($sp)
	add $a0, $t8, $v0
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	lw $t8, 32($sp)
	lw $t9, 36($sp)
	add $v0, $t8, $t9
	
finish:	
	lw $t0, 0($sp)
	lw $ra, 4($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t1, 24($sp)
	lw $t4, 28($sp)
	lw $t8, 32($sp)
	lw $t9, 36($sp)
	addi $sp, $sp, 40
  	jr $ra


#iterateCandidates function
# a0 - input_array
# a1 - file descriptor
iterateCandidates:
	addi $sp, $sp, -32
	sw $a1, 0($sp)
	sw $ra, 4($sp)
	sw $s0, 8($sp) #input_array
	sw $s1, 12($sp)  #start_index
	sw $s2, 16($sp) #end_index
	sw $s3, 20($sp) #a counter for the for loop
	sw $s4, 24($sp) #a fixed array
	sw $s5, 28($sp) #a placeholder
	li $t0, 0
	li $t1, 0
	li $t3, 0
	li $t4, 0
	li $t9, 0
	
	li $s2, 0 #end index
	li $s1, 0 #start index
	move $s0, $a0 # s0 has the input_array (to be array[i])
	move $s4, $a0 #s4 is a fixed array
	
	move $t0, $a0 #move the array into a t register

first_while:
	lw $t1, 0($t0) #load the first integer
	beq $t1, -1, leave
	addi $s2, $s2, 1
	addi $t0, $t0, 4
	b first_while
	
leave:
	addi $s2, $s2, -1 #end_index is set
	li $s3, 0 # a for counter

hello_for:
	bgt $s3, $s2, end_for

	can_m()
	
	li $t9, 4
	mul $s5, $t9, $s3 # multiply the counter by 4 to get the correct offset
	add $s0, $s0, $s5
	
	lw $a0, 0($s0) #array[i]
	lw $a1, 0($sp)
	jal itof
	
	sub $s0, $s0, $s5 #restore the pointer in the array
	
	newline_m()
	
	move $a0, $s4 #get the original array
	
	li $t9, 4
	mul $s5, $t9, $s3
	add $s0, $s0, $s5
	
	lw $a1, 0($s0) #get array[i]. That * 4
	
	sub $s0, $s0, $s5 
	
	move $a2, $s1
	move $a3, $s2
	
	jal recursiveFindMajorityElement
	
	move $t0, $v0 #the answer is in t0
	
	move $t1, $s2
	addi $t1, $t1, 1
	li $t3, 2
	div $t1, $t3
	mflo $t4 #the condition
	
	blt $t0, $t4, end
	
	#if
	lw $a0, 0($sp)
	la $a1, maj
	li $a2, 18
	li $v0, 15
	syscall
	
	li $t9, 4
	mul $s5, $t9, $s3 # multiply the counter by 4 to get the correct offset
	add $s0, $s0, $s5
	lw $a0, 0($s0) #array[i]
	
	lw $a1, 0($sp)
	jal itof
	sub $s0, $s0, $s5
	
	lw $a0, 0($sp)
	la $a1, newline
	li $a2, 1
	li $v0, 15
	syscall
	
	li $t9, 4
	mul $s5, $t9, $s3
	add $s0, $s0, $s5
	lw $v0, 0($s0)
	b forwards
	
end:
	addi $s3, $s3, 1 #increment the for counter
	b hello_for

end_for:
	lw $a0, 0($sp)
	la $a1, maj
	li $a2, 18
	li $v0, 15
	syscall
	
	li $a0, -1
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	li $v0, -1

forwards:
	lw $a1, 0($sp)
	lw $ra, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	lw $s2, 16($sp)
	lw $s3, 20($sp)
	lw $s4, 24($sp)
	lw $s5, 28($sp)
	addi $sp, $sp, 32
  	jr $ra


#Part 4

#recursiveFindLoneElement function
# a0 - input array
# a1 - startIndex
# a2 - endIndex
# a3 - fd
recursiveFindLoneElement:
	addi $sp, $sp, -44
	sw $a3, 0($sp) #file descriptor
	sw $ra, 4($sp)
	sw $a0, 8($sp) #input_array
	sw $a1, 12($sp) #startIndex
	sw $a2, 16($sp) #endIndex
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	
	move $a0, $a3
	la $a1, rfle
	li $a2, 26
	li $v0, 15
	syscall
	
	lw $a0, 12($sp)
	lw $a1, 0($sp)
	jal itof
	
	comma_m()
	
	lw $a0, 16($sp)
	lw $a1, 0($sp)
	jal itof
	
	bears_em()

start_2:
	lw $a3, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp) #restore everything back
	
	move $t0, $a2 #computing array_length
	sub $t0, $t0, $a1
	addi $t0, $t0, 1 #t0 has the array_length
	sw $t0, 20($sp) #SAVING THE ARRAY LENGTH ONTO THE STACK

start_if:
	li $t1, 2
	div $t0, $t1
	mfhi $t3
	bne $t3, 0, start_else
	
	li $t9, -1 #t9 is the ret
	sw $t9, 24($sp) #saving ret onto the stack
	
	return_m()
	
	lw $a0, 24($sp)
	lw $a1, 0($sp)
	jal itof
	
	newline_m()
	
	lw $v0, 24($sp)
	b hooray

start_else:

	single_if:
		lw $t0, 20($sp)
		bne $t0, 1, single_else
	
		lw $t3, 8($sp) # t3 will have the array
		lw $t1, 12($sp) #t1 has start index
		sll $t1, $t1, 2 #multiply by 4
		add $t3, $t3, $t1 #array[start_index]
		lw $t9, 0($t3)
		sw $t9, 24($sp) #save the ret
	
		return_m()
	
		lw $a0, 24($sp)
		lw $a1, 0($sp)
		jal itof
	
		newline_m()
	
		lw $v0, 24($sp)
		b hooray

	single_else:
		lw $t0, 20($sp) #array length
		li $t3, 2
		div $t0, $t3
		mflo $t4 # $t4 is the midpoint
		sw $t4, 28($sp) #saving it onto the stack
		
		#target
		lw $a0, 8($sp) #load the array
		lw $t0, 28($sp) #load the midpoint
		lw $a1, 12($sp) #load the startIndex
		add $t0, $t0, $a1 #midpoint + startIndex
		sll $t0, $t0, 2 #multiply by 2 since it's an int array
		add $a0, $a0, $t0 #go to the offset
		lw $t2, 0($a0) #load the element at array[mdpt + startIndex]
		sw $t2, 32($sp) #save the target onto the stack
		
		#left
		lw $a0, 8($sp)
		lw $t0, 28($sp)
		lw $a1, 12($sp)
		add $t0, $t0, $a1
		addi $t0, $t0, -1
		sll $t0, $t0, 2
		add $a0, $a0, $t0
		lw $t2, 0($a0)
		sw $t2, 36($sp) #save the left onto the stack
		
		#right
		lw $a0, 8($sp)
		lw $t0, 28($sp)
		lw $a1, 12($sp)
		add $t0, $t0, $a1
		addi $t0, $t0, 1
		sll $t0, $t0, 2
		add $a0, $a0, $t0
		lw $t2, 0($a0)
		sw $t2, 40($sp) #save the right onto the stack
		
		double_if:
			lw $t0, 32($sp) #target
			lw $t1, 36($sp) #left
			lw $t2, 40($sp) #right
			
			beq $t0, $t1, double_else_if
			beq $t0, $t2, double_else_if
			
			return_m()
			
			lw $a0, 32($sp)
			lw $a1, 0($sp)
			jal itof
			
			newline_m()
			
			lw $v0, 32($sp)
			b hooray
			
		double_else_if:
			lw $t0, 32($sp)
			lw $t1, 36($sp)
			lw $t2, 40($sp)
			
			bne $t0, $t1, double_else_if2
			beq $t0, $t2, double_else_if2
			
			lw $a1, 12($sp) #startIndex
			li $t5, 2
			
			lw $t3, 28($sp)
			sub $t3, $t3, $a1
			addi $t3, $t3, -1 # t3 is the left_half_length
			div $t3, $t5
			mfhi $t6 #holds the remainder of the division
			bne $t6, 0, triple_else1
			
			triple_if1:
				li $t7, 0 #will be child_start_index
				li $t8, 0 #will be child_end_index
				lw $t4, 28($sp) # getting the midpoint
				
				add $t7, $a1, $t4
				addi $t7, $t7, 1
				lw $t8, 16($sp)
				
				lw $a0, 8($sp)
				move $a1, $t7
				move $a2, $t8
				
				jal recursiveFindLoneElement
				
				sw $v0, 24($sp) #save the result onto the stack
				
				return_m()
				
				lw $a0, 24($sp)
				lw $a1, 0($sp)
				jal itof
				
				newline_m()
				
				lw $v0, 24($sp)
				b hooray
			
			triple_else1:
				li $t7, 0
				li $t8, 0
				lw $t4, 28($sp) #midpoint
				
				lw $t7, 12($sp) # t7 is the child_start_index
				move $t8, $t7
				add $t8, $t8, $t4
				addi $t8, $t8, -2 
				
				lw $a0, 8($sp)
				move $a1, $t7
				move $a2, $t8
				
				jal recursiveFindLoneElement
				
				sw $v0, 24($sp)
				
				return_m()
				
				lw $a0, 24($sp)
				lw $a1, 0($sp)
				jal itof
				
				newline_m()
				
				lw $v0, 24($sp)
				b hooray
		
		double_else_if2:
			#there's no need to check the condition because there is also an else
			lw $t4, 28($sp) #t4 is the midpoint			
			lw $t6, 16($sp) #endIndex
			sub $t6, $t6, $t4
			addi $t6, $t6, 3 # t6 is the right_half_length
			
			li $t3, 2
			div $t6, $t3
			mfhi $t3 #t3 holds the remainder of the division
			
			bne $t3, 0, triple_else2
			
			triple_if2:
				lw $t7, 12($sp) # t7 is child_start_index
				move $t8, $t7
				add $t8, $t8, $t4
				addi $t8, $t8, -1 #t8 is the child_end_index
				
				lw $a0, 8($sp)
				move $a1, $t7
				move $a2, $t8
				
				jal recursiveFindLoneElement
				
				sw $v0, 24($sp)
				
				return_m()
				
				lw $a0, 24($sp)
				lw $a1, 0($sp)
				jal itof
				
				newline_m()
				
				lw $v0, 24($sp)
				b hooray
			
			triple_else2:
				lw $t4, 28($sp) #load the midpoint
				li $t7, 0
				li $t8, 0
				
				lw $t7, 12($sp)
				add $t7, $t7, $t4
				addi $t7, $t7, 2 #t7 holds the child_start_index
				
				lw $t8, 16($sp)
				
				lw $a0, 8($sp)
				move $a1, $t7
				move $a2, $t8
				
				jal recursiveFindLoneElement
				
				sw $v0, 24($sp)
				
				return_m()
				
				lw $a0, 24($sp)
				lw $a1, 0($sp)
				jal itof
				
				newline_m()
				
				lw $v0, 24($sp)
				b hooray
	
hooray:
	lw $a3, 0($sp)
	lw $ra, 4($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t9, 24($sp)
	lw $t4, 28($sp)
	addi $sp, $sp, 44 
  	jr $ra
  	
  	

### Data Section ###
.data
bears_beg: .asciiz "bears( "
comma: .asciiz ", "
newline: .asciiz "\n"
bears_end: .asciiz " )\n"
return: .asciiz "return: "

rfme: .asciiz "recursiveFindMajorityElement( "
can: .asciiz "candidate: "
maj: .asciiz "majority element: "
rfle: .asciiz "recursiveFindLoneElement( "
