.data 
input: .space 16 #max length of input is 9 though("1000 1000")
.text 
	main:
	#save input string
	li $v0, 8
	la $a0, input
	li $a1, 16
	syscall
	
	#calculate first and second numbers
	li $t0, 0 #will contain the first number evetually
	li $t2, 0 #offset
	li $t8, 10 #multiplier when moving to next byte
	la $t3, input #address of input. will be loaded in another register when moving to each nextW character
	first:
		lb $t4, 0($t3) #$t4 has value of current byte		
		beq $t4,32,secondPrep #if current byte is space, stop
		addi $t4,$t4,-48 #convert to number. ascii for '0' is 48
		mult $t0,$t8 #increase first number
		mflo $t0
		add $t0,$t0,$t4 
		addi $t2,$t2,1 	#increase counter
		addi $t3,$t3,1 #move on to next address
		j first
	
	secondPrep:#prepare to load second number
	addi $t2,$t2,1 	#move on to next counter (bypassing whitespace)
	addi $t3,$t3,1 #move on to next address (bypassing whitespace)
	li $t1, 0 #will cotain the second number eventually
	second:		
		lb $t4, 0($t3) #$t4 has value of current byte	
		beq $t4,$t8,start #if we're at the end of the string, start calculations.	
		addi $t4,$t4,-48 #convert to number
		mult $t1,$t8 #increase first number
		mflo $t1
		add $t1,$t1,$t4 
		addi $t2,$t2,1 	#increase counter
		addi $t3,$t3,1 #move on to next address
		j second
	
	#uncomment these lines if input comes from newline
	#li $v0,5
	#syscall
	#move $t0,$v0 #first number
	#li $v0,5
	#syscall
	#move $t1,$v0 #second number
	start:
	li $t3, 0 #counter
	
	loop:
	bgt $t0,$t1,exit
	#check if prime number
	li $t4,2
	li $t5,0 #counter for divisors
		innerLoop:
		bgt $t4,$t0,break 
		div $t0,$t4
		mfhi $t7 
		beqz $t7,inc #check remainder. if zero, increase no. divisors
		cont:
		bge $t5,2,next #check if divisors are more than or equal to 2
		addi $t4,$t4,1 #increase to next divisor
		j innerLoop
	break:
	bge $t5,2,next
	addi $t3,$t3,1	
	next:	
	addi $t0,$t0,1	
	j loop
	
	inc:
	addi $t5,$t5,1
	j cont
	
	exit:
	move $a0,$t3 #print count
	li $v0,1
	syscall
