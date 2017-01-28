.globl main

.data
prompt: .asciiz  "Select operation (+, -, *, or /): "
first_num: .asciiz "First number: "
second_num: .asciiz "Second number: "
answer: .asciiz "answer = "
invalidmsg: .asciiz "Invalid input entered!"
op: .space 20
plus: .asciiz  "+"
minus: .asciiz  "-"
divide: .asciiz  "/"
multiply: .asciiz  "*"

.text
main:
    # Signature: op int int -> int
    
    # Variable mapping:
    # $ra is the return address
    # $t0 is the operator being used
    # $t1 is '+'
    # $t2 is '-'
    # $t3 is '/'
    # $t4 is '*'
    # $v0 will contain the result to be printed
    
    #Prologue
    subi $sp, $sp, 24
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)    
    sw $t3, 16($sp)    
    sw $t4, 20($sp)
        
    #Body...
    # Load operators into registers
    lb $t1, plus
    lb $t2, minus
    lb $t3, divide
    lb $t4, multiply
    
    # Jal to select op
    jal selectop
    # Move $v0 result to $t0
    move $t0, $v0
    # Move result to $a0
    move $a0, $t0
    
    # Compare $t0 with comparator words, jump to label
    beq $a0, $t1, doadd       	# if $a0 = $t1 (plus)
    beq $a0, $t2, dosub 	# if $a0 = $t2 (minus)
    beq $a0, $t3, dodivide      # if $a0 = $t3 (divide)
    beq $a0, $t4, domultiply    # if $a0 = $t4 (multiply)
    j invalid			# if invalid input is entered
    
    # Print the result
printresult:
    # Store the result of function $v0 into $a1 for return
    move $a1, $v0
    
    li $v0, 4
    la $a0, answer
    syscall
    
    # Print the result
    li $v0, 1
    move $a0, $a1
    syscall
    
# End of body 
    
    #Epilogue
    lw $t4, 20($sp)
    lw $t3, 16($sp)
    lw $t2, 12($sp)
    lw $t1, 8($sp)
    lw $t0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 24
    
exit:
    #End the program
    li $v0, 10
    syscall
    
    
# Selectop function:
selectop:
    # Variable mapping:
    # $ra is the return address
    # $t5 is the operator selected

    subi $sp, $sp, 8
    sw $ra, 24($sp)
    sw $t5, 28($sp)
      
    
    li $v0, 4		# Load print string instruction
    la $a0, prompt				
    syscall
	
    li $v0, 8		# Load read string instruction
    la $a0, op
    li $a1, 20
    syscall
    lb $a0, 0($a0)
    move $t5, $a0         # Move string into register $t5
    move $v0, $t5  
    
    
    lw $t5, 28($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 8
    
    jr $ra

# jal to functions, then jump back to main to print result and exit  
doadd:
    jal addfunc
    j printresult

dosub:
    jal subfunc
    j printresult

dodivide:
    jal divfunc
    j printresult
    
domultiply:
    jal multfunc
    j printresult
    
invalid:
    # Print invalid input
    li $v0, 4
    la $a0, invalidmsg
    syscall
    j exit
    

# Operator Functions:
addfunc:
    # Variable Mapping:
    # $sw is the $ra
    # $t5 is the first number being entered
    # $t6 is the second number being entered
    
    subi $sp, $sp, 12	# Allocating space on the stack
    sw $ra, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)

    
    # print message to input first number
    li $v0, 4		# load print string instruction
    la $a0, first_num	# load address of first_num into register $a0
    syscall
        
    # save user input into $s1
    li $v0, 5		# load read int instruction
    syscall
    move $t5, $v0
    
    # print message to input second number
    li $v0, 4
    la $a0, second_num
    syscall
    
    # save user input into $s2
    li $v0, 5		# load read int instruction
    syscall
    move $t6, $v0
    
    
    add $v0, $t5, $t6 # Add the two inputs
    
    lw $t6, 32($sp)
    lw $t5, 28($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 12   

    jr $ra

subfunc:
    # Variable Mapping:
    # $sw is the $ra
    # $t5 is the first number being entered
    # $t6 is the second number being entered
    
    subi $sp, $sp, 12	# Allocating space on the stack
    sw $ra, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    
    #jal readint
    #move $t5, $a0
    #move $t6, $a1
    
    # print message to input first number
    li $v0, 4		# load print string instruction
    la $a0, first_num	# load address of first_num into register $a0
    syscall
        
    # save user input into $s1
    li $v0, 5		# load read int instruction
    syscall
    move $t5, $v0
    
    # print message to input second number
    li $v0, 4
    la $a0, second_num
    syscall
    
    # save user input into $s2
    li $v0, 5		# load read int instruction
    syscall
    move $t6, $v0
    
    sub $v0, $t5, $t6
    
    lw $t6, 32($sp)
    lw $t5, 28($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 12
    
    jr $ra
    
divfunc:
    # Variable Mapping:
    # $sw is the $ra
    # $t5 is the first number being entered
    # $t6 is the second number being entered
    
    subi $sp, $sp, 12	# Allocating space on the stack
    sw $ra, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    
    #jal readint
    #move $t5, $a0
    #move $t6, $a1
    
    # print message to input first number
    li $v0, 4		# load print string instruction
    la $a0, first_num	# load address of first_num into register $a0
    syscall
        
    # save user input into $s1
    li $v0, 5		# load read int instruction
    syscall
    move $t5, $v0
    
    # print message to input second number
    li $v0, 4
    la $a0, second_num
    syscall
    
    # save user input into $s2
    li $v0, 5		# load read int instruction
    syscall
    move $t6, $v0

    div $v0, $t5, $t6 
    
    lw $t6, 32($sp)
    lw $t5, 28($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 12
    
    jr $ra
    
multfunc:
    # Variable Mapping:
    # $sw is the $ra
    # $t5 is the first number being entered
    # $t6 is the second number being entered
    
    subi $sp, $sp, 12	# Allocating space on the stack
    sw $ra, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    
    #jal readint
    #move $t5, $a0
    #move $t6, $a1
    
    # print message to input first number
    li $v0, 4		# load print string instruction
    la $a0, first_num	# load address of first_num into register $a0
    syscall
        
    # save user input into $s1
    li $v0, 5		# load read int instruction
    syscall
    move $t5, $v0
    
    # print message to input second number
    li $v0, 4
    la $a0, second_num
    syscall
    
    # save user input into $s2
    li $v0, 5		# load read int instruction
    syscall
    move $t6, $v0

    mul $v0, $t5, $t6 
    
    lw $t6, 32($sp)
    lw $t5, 28($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 12
    jr $ra
