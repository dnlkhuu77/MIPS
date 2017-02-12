 # Homework #3
 # name: Daniel Khuu
 # sbuid: 109372156


##############################
#
# TEXT SECTION
#
##############################
 .text

##############################
# PART I FUNCTIONS
##############################

##############################
# This function reads a byte at a time from the file and puts it
# into the appropriate position into the MMIO with the correct
# FG and BG color.
# The function begins each time at position [0,0].
# If a newline character is encountered, the function must
# populate the rest of the row in the MMIO with the spaces and
# then continue placing the bytes at the start of the next row.
#
# @param fd file descriptor of the file. ($a0)
# @param BG four-bit value indicating background color ($a1)
# @param FG four-bit value indication foreground color ($a2)
# @return int 1 means EOF has not been encountered yet, 0 means ($v0)
# EOF reached, -1 means invalid file.
##############################
load_code_chunk:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	li $t0, 0
	li $t1, 0
	li $t7, 0
	li $t8, 0

	li $t0, 0xFFFF0000 #characters
	
	move $s1, $a1 #move the bg into $s1
	move $s2, $a2 #move the fg into $s2
	
	li $t8, 0 #counter to 2000.
	li $t7, ' ' #load the space into a register

counter_reset:
	beq $t8, 2000, finished
	
background_color:
	li $t1, 0 # $t1 will be the color byte
	blt $s1, 0, background0
	bgt $s1, 15, background0
	
	or $t1, $t1, $s1
	sll $t1, $t1, 4
	
	b foreground_color

background0:
	#background color should be white
	li $t1, 15
	sll $t1, $t1, 4
	
foreground_color:
	blt $s2, 0, foreground0
	bgt $s2, 15, foreground0	
	or $t1, $t1, $s2 
	
	b reading
	
foreground0:
	#foreground color should be black
	or $t1, $t1, $0
	
reading:
	beq $t8, 2000, finished
	li $v0, 14 #system call for read from file
	#a0 already holds the file descriptor
	la $a1, part1buffer   # address of buffer to which to read
	li $a2, 1 #read the byte one-at-a-time
	syscall
	
	sll $t1, $t1, 8 #shift the color bit so we can store the answer

	beq $v0, -1, finished
	beq $v0, 0, spacingfor
	#v0 will have the return value we need
	
continued:
	#sll $t1, $t1, 8 #NOT USED
	
continued_1:
	lb $s0, 0($a1) #load the character from the buffer
	beq $s0, 10, spacing #check to see if we hit the newline, so we have to add space to the rest of the row

	or $t1, $t1, $s0 #or it with the character byte to one big byte
	sh $t1, 0($t0) #store the character byte into the address
	
	addi $t8, $t8, 1
	addi $t0, $t0, 2
	b counter_reset

spacing:
	beq $t8, 80, counter_reset
	beq $t8, 160, counter_reset
	beq $t8, 240, counter_reset
	beq $t8, 320, counter_reset
	beq $t8, 400, counter_reset
	beq $t8, 480, counter_reset
	beq $t8, 560, counter_reset
	beq $t8, 640, counter_reset
	beq $t8, 720, counter_reset
	beq $t8, 800, counter_reset
	beq $t8, 880, counter_reset
	beq $t8, 960, counter_reset
	beq $t8, 1040, counter_reset
	beq $t8, 1120, counter_reset
	beq $t8, 1200, counter_reset
	beq $t8, 1280, counter_reset
	beq $t8, 1360, counter_reset
	beq $t8, 1440, counter_reset
	beq $t8, 1520, counter_reset
	beq $t8, 1600, counter_reset
	beq $t8, 1680, counter_reset
	beq $t8, 1760, counter_reset
	beq $t8, 1840, counter_reset
	beq $t8, 1920, counter_reset
	beq $t8, 2000, finished
	
	or $t1, $t1, $t7 #make the space bit
	sh $t1, 0($t0)
	
	addi $t8, $t8, 1 #increment the counter
	addi $t0, $t0, 2 #increment the address
	b spacing

spacingfor:
	#add space
	beq $t8, 2000, finished
	or $t1, $t1, $t7 #make the space bit
	sh $t1, 0($t0)
	
	addi $t8, $t8, 1 #increment the counter
	addi $t0, $t0, 2 #increment the address
	b spacingfor
	
finished:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra

##############################
# PART II FUNCTIONS
##############################

##############################
# This function should go through the whole memory array and clear the contents of the screen.
##############################
clear_screen:
	li $t0, 0
	li $t1, 0
	li $t7, 0
	li $t8, 0

	li $t0, 0xFFFF0000 #characters	
	li $t8, 0 #counter to 2000
	li $t7, ' ' #load the space into a register
	
background:
	li $t1, 0 #$t1 will be the color byte
	
	#background color should be black
	li $t1, 0
	sll $t1, $t1, 4
	
foreground:
	#foreground color should be black	
	or $t1, $t1, $0

spacingx:
	#add space
	beq $t8, 2000, finished2
	
	or $t1, $t1, $t7 #make the space bit
	sh $t1, 0($t0)
	
	addi $t8, $t8, 1 #increment the counter
	addi $t0, $t0, 2 #increment the address
	b spacingx
	
finished2:	
	jr $ra

##############################
# PART III FUNCTIONS
##############################

##############################
# This function updates the color specifications of the cell
# specified by the cell index. This function should not modify
# the text in any fashion.
#
# @param i row of MMIO to apply the cell color. ($a0)
# @param j column of MMIO to apply the cell color. ($a1)
# @param FG the four bit value specifying the foreground color ($a2)
# @param BG the four bit value specifying the background color ($a3)
##############################
apply_cell_color:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	
	blt $a0, 0, done
	bgt $a0, 24, done
	blt $a1, 0, done
	bgt $a1, 79, done
	
	move $s1, $a2 # $s1 has the foreground
	move $s2, $a3 # $s2 has the background 

	li $t0, 0xFFFF0000 #characters
	li $t1, 0 #color bit (we must 'or' it with the specified cell.
	li $t2, 80 #t2 has 80 (80 columns)
	li $t3, 2 # every element has two bytes
	

	mul $a0, $a0, $t2 # i * number of columns
	mul $a0, $a0, $t3 # i * number of columns * element_size_in_bytes 
	mul $a1, $a1, $t3 # j * element_size_in_bytes
	
	add $a0, $a0, $a1 #$a0 is the offset
	add $t0, $t0, $a0 #add the offset
	addi $t0, $t0, 1
	
	lb $s0, 0($t0) # s0 has the specific color byte

foreground2:
	blt $s1, 0, background2
	bgt $s1, 15, background2
	
	andi $s0, $s0, 240 #set the foreground bits to zero
	or $s0, $s0, $s1 #set the byte with the color bit
	sb $s0, ($t0)

background2:
	blt $s2, 0, done
	bgt $s2, 15, done
	
	andi $s0, $s0, 15 #set the background color to zero
	sll $s2, $s2, 4 #move the background to the leftmost 4 bits
	or $s0, $s0, $s2 #set the new background color
	
	sb $s0, 0($t0)

done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra


##############################
# This function goes through and clears any cell with oldBG color
# and sets it to the newBG color. It preserves the foreground
# color of the text that was present.
#
# @param oldBG old background color specs. ($a0)
# @param newBG new background color defining the color specs ($a1)
##############################
clear_background:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	li $t0, 0
	li $t8, 0
	
	blt $a0, 0, yahoo
	bgt $a0, 15, yahoo
	
	li $t0, 0xFFFF0000 #get the memory address
	addi $t0, $t0, 1
	li $t8, 0 #counter
	
backyclear:
	beq $t8, 2000, yahoo
	lb $s0, 0($t0) #load the first color byte into $s0
	lb $s3, 0($t0) #load the color byte into $s3 to revert the foreground color back
	
	andi $s0, $s0, 240 #mask it 
	ror $s0, $s0, 4 #rotate the byte
	#andi $s0, $s0, 15 #set the foreground to zero (temporarily)
	beq $s0, $a0, equals_bruh #test to see if the two numbers are the same
	
	#ignore what we did and goes to the next color byte
	
	addi $t0, $t0, 2
	addi $t8, $t8, 1
	b backyclear
	
equals_bruh:
	and $s0, $s0, $0 #reset/mask the color byte
	bge $a1, 0, yup
	b whitey
	
yup:
	ble $a1, 15, comeon
	
whitey:
	ori $s0, $s0, 15 #set the new background to white
	b during

comeon:	
	or $s0, $s0, $a1 #set the new background with the byte

during:
	rol $s0, $s0, 4 #background-0000
	andi $s3, $s3, 15 #(0000-foreground)
	or $s0, $s0, $s3
	sb $s0, 0($t0)	
	addi $t0, $t0, 2
	addi $t8, $t8, 1
	b backyclear

yahoo:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra


##############################
# This function will compare cmp_string to the string in the MMIO
# starting at position (i,j). If there is a match the function
# will return (1, length of the match).
#
# @param cmp_string start address of the string to look for in
# the MMIO ($a0)
# @param i row of the MMIO to start string compare. ($a1)
# @param j column of MMIO to start string compare. ($a2)
# @return int length of match. 0 if no characters matched. ($v0)
# @return int 1 for exact match, 0 otherwise ($v1)
##############################
string_compare:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	li $t0, 0
	li $t1, 0
	li $t2, 0
	
	blt $a1, 0, destroyed
	bgt $a1, 24, destroyed
	blt $a2, 0, destroyed
	bgt $a2, 79, destroyed
	
	li $t0, 0xFFFF0000 #characters
	li $t1, 80 #t1 has 80 (80 columns)
	li $t2, 2 #every element has two bytes
	li $v0, 0 #initialize the characters matched counter
	li $v1, 1 #initialize the matched to 1 (if we find a unmatched pair, we will flip this to 0)
	
	mul $a1, $a1, $t1 # i * number of columns
	mul $a1, $a1, $t2 # i * number of columns * element_size_in_bytes 
	mul $a2, $a2, $t2 # j * element_size_in_bytes
	
	add $a1, $a1, $a2 #$a0 is the offset
	add $t0, $t0, $a1 #add the offset
	
looping:
	lb $s0, 0($t0) # s0 has the specific character byte (8 bits)
	lb $s1, 0($a0) #s1 has the first character from the input string
	
	beq $s0, $0, wrecked #if the next character read is null, we finished
	beq $s1, $0, wrecked #if the next character read in memory is null, we finished

	bne $s0, $s1, nonequal
	#if they are equal
	addi $t0, $t0, 2 #increment the bytes in memory counter
	addi $a0, $a0, 1 #increment the input string
	addi $v0, $v0, 1 #increment the characters counter
	b looping

nonequal:
	li $v1, 0
	b wrecked

destroyed:
	li $v0, 0
	li $v1, 0
	b wrecked

wrecked:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra


##############################
# This function goes through the whole MMIO screen and searches
# for any string matches to the search_string provided by the
# user. This function should clear the old highlights first.
# Then it will call string_compare on each cell in the MMIO
# looking for a match. If there is a match it will apply the
# background color using the apply_cell_color function.
#
# @param search_string Start address of the string to search for
# in the MMIO. ($a0)
# @param BG background color specs defining. ($a1)
##############################
search_screen:
	lw $t0, 0($sp) #load the fifth argument
	#$t0 holds the fifth argument (defaultFG)

	addi $sp, $sp, -36 #wrong stack pointer
	sw $ra, 0($sp)
	sw $s0, 4($sp) # $s0 will hold the string
	sw $s1, 8($sp) # $s1 will be the background color
	sw $s2, 12($sp) # $s2 will be the foreground color
	sw $s3, 16($sp) # a counter to keep track of highlighted letters
	sw $s4, 20($sp) # will keep track of the row number
	sw $s5, 24($sp) # will keep track of the column number
	sw $s6, 28($sp) #keep track of the current row so we can check all the cells
	sw $s7, 32($sp) #keep track of the current column so we can check all the columns
	
	move $s0, $a0 # $s0 has the string we want to compare
	move $s1, $a1 # $s1 will hold the highlighted background color
	move $s2, $a2 # $s2 will hold the highlighted foreground color
	# $t0 holds the default FG
	
	li $s4, 0 #initilize the row number
	li $s5, 0 #initilize the column number
	
	li $s6, 0 #initialize the row number (external)
	li $s7, 0 #initialize the column number (external)
	
	move $a0, $a1 #the old background color is the color if a match/highlight is found
	move $a1, $a3 #the new background color is the default original color
	jal clear_background
	
nice:
	beq $s4, 25, cunning #once we hit the 25th row, we finished looping through the memory
	move $a0, $s0 # $a0 will hold the string
	move $a1, $s4 # $a1 will hold the row number
	move $a2, $s5 # $a2 will hold the column number
	
	jal string_compare
	
	beq $v1, 1, highlighting

update:
	addi $s5, $s5, 1 #increment the column number
	beq $s5, 80, reseteverything
	b nice
	
reseteverything:
	addi $s4, $s4, 1 #increment the row number
	li $s5, 0 #reset the row number with zero
	b nice

highlighting:
	li $s3, 0 #a counter to highlight the number of characters in the string based on $v0
	move $s6, $s4 #row number updated
	move $s7, $s5 #column number updated
	b wtf

turning_on:
	beq $s3, $v0, update #get out of the loop
	
	addi $s7, $s7, 1 #update the column number (external)
	beq $s7, 80, updatingrow
	beq $s6, 25, cunning
	
wtf:	
	move $a0, $s6 #row number
	move $a1, $s7 #column number
	move $a2, $s2 #foreground color
	move $a3, $s1 #background color
	
	jal apply_cell_color
	
	addi $s3, $s3, 1
	b turning_on	

updatingrow:
	addi $s6, $s6, 1
	li $s7, 0
	b wtf
	
cunning:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	jr $ra


##############################
# PART IV FUNCTIONS
##############################

##############################
# This function goes through the whole MMIO screen and searches
# for Java syntax keywords, operators, data types, etc and
# applies the appropriate color specifications for to that match.
#use search_screen and apply_cell_color
##############################
apply_java_syntax:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	la $s0, java_keywords # $s0 holds the first java array
	li $s1, 11 #number of java_keywords
	li $s2, 0 #a counter

searching_keywords:
	beq $s2, $s1, ops #we done all the java_keywords
	lw $a0, 0($s0) #loading the first word from the java_keyword array
	li $a1, 0
	li $a2, 9
	li $a3, 0
	
	jal search_screen
	
	addi $s0, $s0, 4
	addi $s2, $s2, 1
	b searching_keywords

ops:
	la $s0, java_operators
	li $s1, 12
	li $s2, 0 #reset the counter

searching_operators:
	beq $s2, $s1, braks
	lw $a0, 0($s0)
	li $a1, 0
	li $a2, 10
	li $a3, 0
	
	jal search_screen
	
	addi $s0, $s0, 4
	addi $s2, $s2, 1
	b searching_operators
	
braks:
	la $s0, java_brackets
	li $s1, 6
	li $s2, 0

searching_brackets:
	beq $s2, $s1, datat
	lw $a0, 0($s0)
	li $a1, 0
	li $a2, 13
	li $a3, 0
	
	jal search_screen
	
	addi $s0, $s0, 4
	addi $s2, $s2, 1
	b searching_brackets
	
datat:
	la $s0, java_datatypes
	li $s1, 9
	li $s2, 0

searching_datatypes:
	beq $s2, $s1, tooeasy
	lw $a0, 0($s0)
	li $a1, 0
	li $a2, 14
	li $a3, 0
	
	jal search_screen
	
	addi $s0, $s0, 4
	addi $s2, $s2, 1
	b searching_datatypes
	
tooeasy:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


##############################
# This function goes through the whole MMIO screen finds any java
# comments and applies a blue foreground color to all of the text
# in that line. #string_compare & apply_cell_phone //12-brightblue
##############################
apply_java_line_comments:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	li $s0, 0 #row number
	li $s1, 0 #column number
	la $s2, java_line_comment

coming:
	beq $s0, 25, fin
	move $a0, $s2 # $a0 has the //
	move $a1, $s0
	move $a2, $s1
	
	jal string_compare
	
	beq $v1, 1, brightbluetime
	
	addi $s1, $s1, 1 #update the column number
	beq $s1, 80, updaterow
	b coming

updaterow:
	addi $s0, $s0, 1 #update the row number
	li $s1, 0  #reset the column number
	b coming
	
brightbluetime:
	#$s0 and $s1 already has the line comment
	move $a0, $s0
	move $a1, $s1
	li $a2, 12
	li $a3, 0
	
	jal apply_cell_color
	
	addi $s1, $s1, 1
	beq $s1, 80, updaterow
	b brightbluetime

fin:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


##############################
#
# DATA SECTION
#
##############################
.data
#put the users search string in this buffer
part1buffer: .space 1

.align 2
negative: .word -1

#java keywords red
java_keywords_public: .asciiz "public"
java_keywords_private: .asciiz "private"
java_keywords_import: .asciiz "import"
java_keywords_class: .asciiz "class"
java_keywords_if: .asciiz "if"
java_keywords_else: .asciiz "else"
java_keywords_for: .asciiz "for"
java_keywords_return: .asciiz "return"
java_keywords_while: .asciiz "while"
java_keywords_sop: .asciiz "System.out.println"
java_keywords_sop2: .asciiz "System.out.print"

.align 2
java_keywords: .word java_keywords_public, java_keywords_private, java_keywords_import, java_keywords_class, java_keywords_if, java_keywords_else, java_keywords_for, java_keywords_return, java_keywords_while, java_keywords_sop, java_keywords_sop2, negative

#java datatypes
java_datatype_int: .asciiz "int "
java_datatype_byte: .asciiz "byte "
java_datatype_short: .asciiz "short "
java_datatype_long: .asciiz "long "
java_datatype_char: .asciiz "char "
java_datatype_boolean: .asciiz "boolean "
java_datatype_double: .asciiz "double "
java_datatype_float: .asciiz "float "
java_datatype_string: .asciiz "String "

.align 2
java_datatypes: .word java_datatype_int, java_datatype_byte, java_datatype_short, java_datatype_long, java_datatype_char, java_datatype_boolean, java_datatype_double, java_datatype_float, java_datatype_string, negative

#java operators
java_operator_plus: .asciiz "+"
java_operator_minus: .asciiz "-"
java_operator_division: .asciiz "/"
java_operator_multiply: .asciiz "*"
java_operator_less: .asciiz "<"
java_operator_greater: .asciiz ">"
java_operator_and_op: .asciiz "&&"
java_operator_or_op: .asciiz "||"
java_operator_not_op: .asciiz "!="
java_operator_equal: .asciiz "="
java_operator_colon: .asciiz ":"
java_operator_semicolon: .asciiz ";"

.align 2
java_operators: .word java_operator_plus, java_operator_minus, java_operator_division, java_operator_multiply, java_operator_less, java_operator_greater, java_operator_and_op, java_operator_or_op, java_operator_not_op, java_operator_equal, java_operator_colon, java_operator_semicolon, negative

#java brackets
java_bracket_paren_open: .asciiz "("
java_bracket_paren_close: .asciiz ")"
java_bracket_square_open: .asciiz "["
java_bracket_square_close: .asciiz "]"
java_bracket_curly_open: .asciiz "{"
java_bracket_curly_close: .asciiz "}"

.align 2
java_brackets: .word java_bracket_paren_open, java_bracket_paren_close, java_bracket_square_open, java_bracket_square_close, java_bracket_curly_open, java_bracket_curly_close, negative

java_line_comment: .asciiz "//"

.align 2
user_search_buffer: .space 101
