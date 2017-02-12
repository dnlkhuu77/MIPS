##############################################################
# Homework #2
# name: Daniel Khuu
# sbuid: 109372156
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

toUpper:
	la $v0, 0($a0) #take address in $a0 and store into return
	lw $t0, sum
	add $t0, $0, $0 #register $t0 to zero
	lw $t1, sum
	add $t1, $0, $0 #register $t1 to zero
	lw $t2, sum
	add $t2, $0, $0 #register $t2 to zero ; set the string to be 0 if returned
	
	move $t0, $a0 #set $t0 be the string itself

tester:	
	lb $t1, ($t0) #$t1 is the individual bits of the string, $t0	
	beq $t1, $0, printer1 #if we hit null, we end the function	
	bge $t1, 'a', tester2 #if the bit is greater or equal to 'a', then continue the search	
	addi $t0, $t0, 1 #go to next character in string before we reloop the check	
	b tester
	
tester2:
	ble $t1, 'z', performer1 #if the bit is less than or equal to 'z', then continue the function	
	addi $t0, $t0, 1	
	b tester #otherwise, we go to the next character and redo the function
	
performer1:
	addi $t1, $t1, -32 #subtract 32 to the bit to capitalize the character
	sb $t1, ($t0) #save the character in $t1 back to $t0
	addi $t0, $t0, 1 #go to next character in string
	b tester
	
printer1:
	jr $ra
	

length2Char:
	#$a0 is the string and $a1 is the character stopper
	lw $t0, sum
	add $t0, $0, $0
	lw $t1, sum
	add $t1, $0, $0
	lw $t2, sum
	add $t2, $0, $0
	li $t3, 0 #$t3 will be our answer
	
	la $t0, ($a0) #t0 is our string
	lb $t1, ($a1) #t1 is our terminator character
	
loop_one:
	lb $t2, ($t0) #t2 is our individual bits from $t0
	beq $t2, $0, term #if we hit the null
	beq $t2, $t1, term #if we hit the character terminator
	addi $t3, $t3, 1 #increment the length counter
	addi $t0, $t0, 1 #go to the next character in string
	j loop_one
	
term:	
	move $v0, $t3
	jr $ra

strcmp:
	#$a0 is first string, $a1 is second string, $a2 is the length
	lw $t0, sum
	add $t0, $0, $0
	lw $t1, sum
	add $t1, $0, $0
	lw $t2, sum
	add $t2, $0, $0
	lw $t3, sum #to read how many characters are in string 1 (just temporarily)
	add $t3, $0, $0
	lw $t4, sum #to read how many characters are in string 2 (just temporarily)
	add $t4, $0, $0
	li $t5, 0 #counter for $t3
	li $t6, 0 #counter for $t4
	
	la $t0, ($a0) #$t0 is the first string
	la $t1, ($a1) #t1 is the second string
	li $t2, 0 #current position
	li $t8, 0 #number of characters that matched
	li $t9, 1 #this register is 1 if $t0=$t1; 0 otherwise
	
	bltz $a2, zeroed #if length is less than 0
	
	#count how many characters are in the two strings
count:
	lb $t3, ($t0)
	beq $t3, $0, count2 #if the bit goes to null, go to second string
	addi $t5, $t5, 1 #$t5 will hold the number of characters in $t1
	addi $t0, $t0, 1
	b count
	
count2:
	lb $t4, ($t1)
	beq $t4, $0, comparestuff #if the bit goes to null, go the compartive operation
	addi $t6, $t6, 1
	addi $t1, $t1, 1
	b count2
	
comparestuff:
	bgt $a2, $t5, zeroed
	bgt $a2, $t6, zeroed
	
	ble $t5,$t6, hello
	#ble $a2, $t5, hello
	#ble $a2, $t6, hello
	li $t9, 0 #if the two strings are not the same length, they cannot be equal
	
hello:	
	la $t0, ($a0) #reset everything
	la $t1, ($a1)
	add $t3, $0, $0
	add $t4, $0, $0
	beqz $a2, operation_continued #if length is equal to 0
	
operation:
	beq $t2, $a2, enteroutputs #if our current position = length of the string, exit the while loop
	
operation_continued:
	lb $t3, ($t0) #load the first byte from string 1 to $t3
	lb $t4, ($t1) #load the first byte from string 2 to $t4
	
	beq $t3, $0, enteroutputs
	beq $t4, $0, enteroutputs
	
	bne $t3, $t4, nonequal
	#if the two bytes are equal
	addi $t8, $t8, 1 #increment our first output; the number of matched characters
	addi $t2, $t2, 1 #increment our current position on the two strings
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	b operation

nonequal:
	li $t9, 0 #set the second output to 0 since they're not equal
	move $v0, $t8
	addi $t2, $t2, 1 #increment our position
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	b finally
	
enteroutputs:
	move $v0, $t8
	move $v1, $t9
	b finally
zeroed:
	li $v0, 0
	li $v1, 0
finally:
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	#$a0 is our message, $a1 is our morse answer, $a2 is how long can $a1 be
	#stack try
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	
	lw $s0, sum
	add $s0, $0, $0
	lw $s1, sum
	add $s1, $0, $0
	lw $t0, sum
	add $t0, $0, $0
	lw $t1, sum
	add $t1, $0, $0
	lw $t2, sum
	add $t2, $0, $0
	lw $t3, sum
	add $t3, $0, $0
	lw $t4, sum
	add $t4, $0, $0
	lw $t7, sum
	add $t7, $0, $0
	lw $t8, sum
	add $t8, $0, $0
	
	li $v0, 0 #set the number of characters successfully into Morse code
	li $v1, 0 #currently, the message isn't completely turned ($v1)
	li $s1, 4 #used to multiply by 4 to use the MorseCode array
	
	move $t0, $a0 #$t0 will be our string
	la $s0, MorseCode #s0 will be our MorseCode array
	move $t1, $s0 #$t1 will be our MorseCode to found Morse in
	addi $a2, $a2, -1 #subtract the size by 1 so that the final character is null
	
	la $t5, heresanx #put a string of x
	lb $t6, 0($t5) #print the character x to be inserted
	
	move $t7, $t1

checkifempty:
	lb $t2, ($t0)
	beq $t2, $0, conquers	
	
loopMorse:
	bge $v0, $a2, addthenull #if the size of our message equals our max, we will add the null
	
	move $t1, $t7 #reset the pointer at 0 of the MorseCode array
	
	lb $t2, ($t0) #get the byte from string 1
	beq $t2, $0, conquer #if the character is null, we add the null before finishing
	beq $t2, ' ', spacex #if the character is a space, add the double x
	
	blt $t2, '!', lowercase #if the character is less than !, ignore the character
	bgt $t2, 'Z', lowercase #if the character is greater than Z, ignore the character
	
	addi $t2, $t2, -33 #turn the value into an i for the MorseCode array
	mul $t2, $t2, $s1 #with a word array, we will search by multiples of 4
	add $t1, $t1, $t2 #finding the word in the MorseCode array
	lw $t3, ($t1) #getting the word of 4 bytes from the array
	b letterandx
	
lowercase:
	addi $t0, $t0, 1
	b loopMorse
		
letterandx:
	lb $t4, ($t3) #getting one symbol at a time from the Morse word
	beqz $t4, printx #if the bit is null, we finished printing the letter, so we need the x
	sb $t4, ($a1) #store the symbol into our resultant string
	addi $a1, $a1, 1 #go to next character in result string
	addi $t3, $t3, 1 #load the next byte in the morse code
	addi $v0, $v0, 1 #increase the size counter of our string
	bge $v0, $a2, addthenull
	b letterandx
	
printx:
	sb $t6, ($a1) #insert the x into the resultant string
	addi $v0, $v0, 1 #the x increases the size of the string
	addi $a1, $a1, 1 #go to next character in result string
	addi $t0, $t0, 1 #move to the next character of first string
	bge $v0, $a2, addthenull
	b loopMorse
	
spacex:
	addi $t0, $t0, -1
	lb $t8, ($t0)
	addi $t0, $t0, 1
	beq $t8, $0, fishy
	beq $t8, ' ', fishy
	
	bne $v0, 0, somet

	blt $t2, '!', fishy #if the character is less than !, ignore the character
	bgt $t2, 'Z', fishy #if the character is greater than Z, ignore the character
	
somet:
	sb $t6, ($a1) #insert the x
	addi $a1, $a1, 1
	addi $v0, $v0, 1 #increase the size of the string by 2

fishy:
	addi $t0, $t0, 1 #move to the next character in the first string
	bge $v0, $a2, addthenull
	
	b loopMorse
	
addthenull:
	sb $0, ($a1) #we will add the null to the final result string
	addi $v0, $v0, 1 #add the length of the string
	b conclus
	
conquer:
	addi $t0, $t0, -1
	lb $t1, ($t0)
	beq $t1, ' ', conquer_2
	blt $t1, '!', conquers #if the character is less than !, ignore the character
	bgt $t1, 'Z', conquers #if the character is greater than Z, ignore the character
geez:
	sb $t6, ($a1)
	addi $v0, $v0, 2
	addi $a1, $a1, 1
	li $v1, 1 #the message is complete
	sb $0, ($a1)
	b conclus

conquer_2: #if the last character is a space
	addi $t0, $t0, -1
	lb $t1, ($t0)
	beq $t1, $0, geez #if the input is an empty string
	
	li $v1, 1 #the message is complete
	sb $0, ($a1)

conquers:
	sb $0, ($a1)
	addi $v0, $v0, 1
	addi $a1, $a1, 1
element:
	li $v1, 1
	
conclus:
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
	
createKey:
	#$a0 will be our input string, $a1 will the result string, there is no $v0
	lw $t0, sum
	add $t0, $0, $0
	lw $t1, sum
	add $t1, $0, $0
	lw $t2, sum
	add $t2, $0, $0
	lw $t3, sum
	add $t3, $0, $0
	lw $t9, sum
	add $t9, $0, $0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal toUpper
	move $t0, $v0 #move the result string back into $a0
	move $t9, $a1 #move the key into $t9
	
firstOuterLoop:
	move $a1, $t9 #insert the pointer of the result string back to the start
	
	lb $t1, ($t0) #get the first bit of the phrase
	beq $t1, $0, middle #if the character is null, we finish looking through the string
	blt $t1, 'A', nonsymbol #if the character is less than A, ignore
	bgt $t1, 'Z', nonsymbol #if the character is greater than Z, ignore
	b firstInnerLoop
	
nonsymbol:
	addi $t0, $t0, 1
	b firstOuterLoop
	
firstInnerLoop:
	lb $t2, ($a1) #get the character from the result string
	beq $t2, $0, insertchar #if the character is null, return to the outer loop
	beq $t2, $t1, nonsymbol #if the character of the input string and result string match, ignore
	addi $a1, $a1, 1 #move the pointer of the result string
	b firstInnerLoop

insertchar:
	sb $t1, ($a1) #store the character into the resultant string
	addi $t0, $t0, 1 #move to the next position in the input string
	b firstOuterLoop
	
middle:
	move $t9, $a1 #make a copy of the result string
	li $t3, 65 #this will be our alphabet
	
secondOuterLoop:
	lb $t2, ($t9)
	beq $t2, $0, printchar #if the character is null, print the character
	bne $t3, $t2, notequ
	
	addi $t3, $t3, 1 #go to the next alphabet
	move $t9, $a1
	b secondOuterLoop

printchar:
	sb $t3, ($t9)
	addi $t3, $t3, 1
	bgt $t3, 'Z', complete
	move $t9, $a1
	b secondOuterLoop
	
notequ:
	addi $t9, $t9, 1
	b secondOuterLoop

complete:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	

keyIndex:
	#$a0 is our first string, $v0 is our key number
	lw $t0, sum
	add $t0, $0, $0
	lw $t1, sum
	add $t1, $0, $0
	lw $t2, sum
	add $t2, $0, $0
	lw $t3, sum
	add $t3, $0, $0
	lw $t8, sum
	add $t8, $0, $0
	lw $t9, sum
	add $t9, $0, $0
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	li $s0, 0 #keep a counter on the i of keys[i]
	li $t9, 0 #counter so we can check for null
	move $t0, $a0 #$t0 will have our entire input string ($a0 will be unchanged for comaprsion)
	
checkForNull:
	beq $t9, 3, nextup
	lb $t3, ($t0) #touble-shotting
	
	#lb $s1, ($t1) #get the character from string
	beq $t3, $0, incomplete #if the string is >4 characters long, we don't compare
	
	addi $t9, $t9, 1 #increment the counter
	addi $t0, $t0, 1 
	b checkForNull

nextup:
	#move $t0, $a0
	la $a1, FMorseCipherArray #$t1 will be our array
	#move $a0, $t0 #move our input string into the first argument

getting:
	#move $a1, $t1 #move the FMorseCipher array into the second argument
	li $a2, 3 #we compare the the first three bytes	
	jal strcmp	
	beq $v0, 3, completion #if it does match, we will have completed the function

tryagain:
	addi $a1, $a1, 3
	addi $s0, $s0, 1
	beq $s0, 26, incomplete #if the FMorseArray goes out of bounds, it's incomplete
	b getting
	
incomplete:
	li $v0, -1
	b hope
	
completion:
	move $v0, $s0

hope:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra


FMCEncrypt:
	#$a0 is the input string, $a1 is the phrase, $a2 is the empty output, $a3 is the size of the message
	#$v0 is the output string, $v1 is 1 if completed; 0 otherwise
	lw $t0, sum
	add $t0, $0, $0
	lw $t1, sum
	add $t1, $0, $0
	lw $t2, sum
	add $t2, $0, $0
	lw $t3, sum
	add $t3, $0, $0
	lw $t4, sum
	add $t4, $0, $0
	lw $t5, sum
	add $t5, $0, $0
	lw $t6, sum
	add $t6, $0, $0
	lw $t7, sum
	add $t7, $0, $0
	lw $t8, sum
	add $t8, $0, $0
	addi $sp, $sp, -40
	sw $a2, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $ra, 36($sp)
	
	li $s7, 0 #counter
	li $s4, 1 #for $v1
	move $s5, $a3 #preserve the size
	la $s6, FMC_stuff
	
	move $s0, $a1 #$s0 is phrase
	la $a1, immediate #to create an empty buffer for the answer to hold
	li $a2, 100
	jal toMorse
	#immediate holds the morse
	
storeKey:
	#$a1 holds the starting address of morse code
	move $a0, $s0 #move the phrase into the argument
	la $a1, key_holder
	jal createKey
	
	# key_holder will hold the key

hold_on:
	lw $a2, 0($sp) #move $a2 off the stack to hold the answer
	move $s3, $s6 #save the front pointer
	la $a0, immediate #$a0 will hold the morse code
	#a1 has the key
		
continue_on:
	beq $s7, $s5, not_complete
	jal keyIndex
	beq $v0, -1, answer
	#v0 holds the index
	la $s2, key_holder #$s2 holds the key

yahoo:
	add $s2, $s2, $v0
	lb $t2, ($s2) #get the character from the key_holder
	beq $t2, $0, answer
	sb $t2, ($s6) #s6 has the answer
	addi $s6, $s6, 1
	addi $s7, $s7, 1
	addi $a0, $a0, 3
	b continue_on
	
not_complete:
	li $s4, 0

answer:
	move $s6, $s3
	move $a2, $s6
	move $v0, $a2
	move $v1, $s4
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	jr $ra

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Dine your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra



.data

MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 

MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."


FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"
sum: .word 0
heresanx: .word 120
immediate: .space 3000
			.byte 0
key_holder: .space 26
			.byte 0
FMC_stuff: .space 300
			.byte 0