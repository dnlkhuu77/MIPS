
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

li $s0, 10 #default FG should be 10
sw $s0, 0($sp) #load the fifth argument onto the stack


#open a file for writing
li $v0, 13       # system call for open file
		 # a0 has the file already
lw $a0, arg1
li $a1, 0        # Open for reading
li $a2, 0
syscall          # open a file (file descriptor returned in $v0)

move $a0, $v0      #save the file descriptor 
li $a1, 0	   #random number for BG
li $a2, 15	   #random number for FG

jal load_code_chunk

move $a0, $v0
li $v0, 1
syscall

la $a0, prompt
li $v0,  4
syscall

li $v0, 12
syscall

beq $v0, 'q', clear
beq $v0, ' ', loading
beq $v0, '3', applycellcolor
beq $v0, 'b', clear_back
beq $v0, 'c', comparing
beq $v0, '/', searching
beq $v0, 'j', java_sin

loading: 
jal load_code_chunk
b closing

clear:
jal clear_screen
b closing

applycellcolor:
li $a0, 2
li $a1, 3
li $a2, 5 #foreground
li $a3, -9 #background
jal apply_cell_color
b closing

clear_back:
li $a0, 0
li $a1, 4
jal clear_background
b closing

comparing:

la $a0, string
li $a1, 0
li $a2, 78
jal string_compare

move $a0, $v0
li $v0, 1
syscall

move $a0, $v1
syscall

b closing

searching:

la $a0, search_prompt
li $v0, 4
syscall

la $a0, search_buffer
li $a1, 100
li $v0, 8
syscall

la $a0, string
li $a1, 0
li $a2, 13
li $a3, 12
jal search_screen
b closing

java_sin:
jal apply_java_syntax
jal apply_java_line_comments
b closing

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

#prompts to display asking for user input
prompt: .asciiz "\nSpace or Enter to continue\n'q' to Quit\n'/' to search for text\n: "
search_prompt: .asciiz "\nEnter search string: "

buffer: .asciiz ""
string: .asciiz "ABC"
edge: .asciiz "ABBABBA"
abbc: .asciiz "ABBC"
public: .asciiz "public"
search_buffer: .space 100


#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw3.asm"
