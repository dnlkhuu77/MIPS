# Helper macro for grabbing two command line arguments
.macro load_two_args
	lw $t0, 0($a1)
	sw $t0, arg1
	lw $t0, 4($a1)
	sw $t0, arg2
.end_macro

# Helper macro for grabbing one command line argument
.macro load_one_arg
	lw $t0, 0($a1)
	sw $t0, arg1
.end_macro

############################################################################
##
##  TEXT SECTION
##
############################################################################
.text
.globl main

main:
#check if command line args are provided
#if zero command line arguments are provided exit
beqz $a0, exit_program
li $t0, 1
#check if only one command line argument is given and call marco to save them
beq $t0, $a0, one_arg
#else save the two command line arguments
load_two_args()
j done_saving_args

#if there is only one arg, call macro to save it
one_arg:
	load_one_arg()

#you are done saving args now, start writing your code.
done_saving_args:


# YOUR CODE SHOULD START HERE
addi $sp, $sp, -4

#open a file for writing
li $v0, 13       # system call for open file
lw $a0, arg1
li $a1, 1        # Open for reading
li $a2, 1
syscall          # open a file (file descriptor returned in $v0)

move $s0, $v0	#the file descriptor is in $s0
sw $s0, 0($sp)  #the fifth argument onto the stack !!!!!IMPORTANT FOR BEARS!

li $v0, 12
syscall

beq $v0, 'i', first
beq $v0, 'b', second
beq $v0, 'm', third_one
beq $v0, 'c', third_two
beq $v0, 'l', fourth

############
first:

move $a1, $s0    #smove the file descriptor to a1
li $a0, -123	 #write this number to a file

jal itof
b closing
#############
second:

li $a0, 99
li $a1, 129
li $a2, 53
li $a3, 4

jal bears

move $a0, $v0
li $v0, 1
syscall
b closing
#####################
third_one:

la $a0, int_array
li $a1, 4 #target integer
li $a2, 0 #start index
li $a3, 7 #end index

jal recursiveFindMajorityElement

move $a0, $v0
li $v0, 1
syscall

b closing
#####################
third_two:

lw $t0, 0($sp)
addi $sp, $sp, 4

la $a0, int_array
move $a1, $t0

jal iterateCandidates

move $a0, $v0
li $v0, 1
syscall

li $v0, 16 #closing the file
syscall

li $v0, 10 #close the program
syscall
#####################
fourth:

lw $t0, 0($sp)
addi $sp, $sp, 4

la $a0, int_array3
li $a1, 0
li $a2, 7
move $a3, $t0

jal recursiveFindLoneElement

move $a0, $v0
li $v0, 1
syscall

li $v0, 16
syscall

li $v0, 10
syscall

#####################

closing:
# Close the file 
li $v0, 16 # system call for close file
syscall # close file

lw $s0, 0($sp)
addi $sp, $sp, 4

exit_program:
li $v0, 10
syscall

############################################################################
##
##  DATA SECTION
##
############################################################################
.data

.align 2

#for arguments read in
arg1: .word 0
arg2: .word 0

int_array: .word 1, 2, 2, 4, 1, 4, 4, 4, -1
int_array2: .word 1, 1, 2, 3, 3, 5, 5, 8, 8, 13, 13, -1
int_array3: .word 1, 1, 3, 3, 5, 5, 8, 8, -1
int_array4: .word 1, 1, 3, 3, 5, 5, 8, 8, 10, 10, 12, 12, 20, 20, 33, 33, 34, 35, 35, 42, 42, 51, 51, 55, 55, 66, 66, 67, 67, -1

#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw4.asm"
